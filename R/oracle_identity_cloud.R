# Oracle Identity Cloud Service OAuth 2.0 Device Flow Authentication
# Translated from AMD_Tools4.py
#
# The Oracle Token consists of two tokens: access token and refresh token.
#

#' Save oracle tokens
#'
#' @name save_tokens
#'
#' @param tokens Oracle tokens
save_tokens <- function(tokens) {

  first_access <- as.numeric(Sys.time())
  OCI_TOKEN_FILE <- get_config_value("OCI_TOKEN_FILE")

  tryCatch({
    token_data <- list(
      access_token = tokens$access_token,
      refresh_token = tokens$refresh_token,
      expires_in = tokens$expires_in,
      obtained_at = as.numeric(Sys.time()),
      first_access = first_access
    )

    suppressWarnings(file.remove(OCI_TOKEN_FILE))
    jsonlite::write_json(token_data, OCI_TOKEN_FILE, pretty = TRUE)
  }, error = function(e) {
    cat(sprintf('Tokens were not saved. Check write permission to %s.\n',
                normalizePath(OCI_TOKEN_FILE, mustWork = FALSE)))
    stop(e)
  })
}


#' Load oracle tokens
#'
#' @name load_tokens
#'
#' @param OCI_TOKEN_FILE path to the Oracle token file
load_tokens <- function(OCI_TOKEN_FILE = get_config_value("OCI_TOKEN_FILE")) {
  if (!file.exists(OCI_TOKEN_FILE)) {
    return(NULL)
  }

  tryCatch({
    return(jsonlite::read_json(OCI_TOKEN_FILE))
  }, error = function(e) {
    cat(sprintf('Tokens were not accessible. Check access permission to %s.\n',
                normalizePath(OCI_TOKEN_FILE, mustWork = FALSE)))
    stop(e)
  })
}


#' Simplified token retrieval with automatic refresh
#'
#' @name get_access_token
get_access_token <- function() {
  token <- ensure_tokens()
  return(token$access_token)
}

#' Verify validity of access token
#'
#' @name verify_access_token
#'
#' @param tokens Oracle tokens
#' @param warn_hour warn upcoming re-authorization
#' @param dtime small buffer time to suppress errors due to time lag
verify_access_token <- function(tokens, warn_hour = 6, dtime = 30) {

  # our system restrict access for seven days per authentication
  valid_days_after_first_access = 7

  if (is.null(tokens) || is.null(tokens$access_token) || is.null(tokens$expires_in) || is.null(tokens$obtained_at)) {
    return(FALSE)
  }

  now <- as.numeric(Sys.time())

  hours_to_reauth <- valid_days_after_first_access * 24 - (now - tokens$first_access[[1]])/3600
  if(hours_to_reauth < warn_hour){
    cat(sprintf('%s hours left for expiration.\nPlease `authorize_device()` to avoid interuption during data access.\n',
                floor(hours_to_reauth)))
  }

  return((tokens$obtained_at[[1]] + tokens$expires_in[[1]] - dtime) > now)
}


#' Authorize device via Oracle MFA
#'
#' @name authorize_device
#'
#' @export
authorize_device <- function() {

  payload <- list(client_id = get_config_value("OCI_CLIENT_ID"), response_type = "device_code", scope = get_config_value("OCI_SCOPE"))

  tryCatch({
    response <- httr::POST(
      url = get_config_value("OCI_DEVICE_URL"),
      body = payload,
      encode = "form",
      httr::add_headers("Content-Type" = "application/x-www-form-urlencoded")
    )

    if (httr::status_code(response) != 200) {
      cli::cli_abort("Server error: {httr::status_code(response)}")
    }

    data <- httr::content(response, "parsed")

    cat("=== Oracle Cloud Authentification ===\n")
    cli::cli_alert_info("Verification URL, valid for 5 min:\n  -> ")
    cli::cli_text(cli::style_hyperlink(text = data$verification_uri, url = data$verification_uri), "\n")
    cli::cli_text("Device Code:\n  ->", data$user_code, "\n\n")

    cat("Open the verification URL and sign in Oracle Cloud via two-factor authentification.\n")
    cat("Enter and submit the Device Code in ‘Device Log In’ window to grant access.\n")

    invisible(data)
  }, error = function(e) {
    cat('デバイスコードの取得ができませんでした。\n')
    stop(e)
  })
}

#' authorize device via Oracle Multi-Factor authentication
#'
#' @name pll_for_tokens
#'
#' @param device_code
#' @param interval
#' @param expires_in
#'
#' @export
poll_for_tokens <- function(device_code, interval, expires_in) {

  payload <- list(
    grant_type = "urn:ietf:params:oauth:grant-type:device_code",
    device_code = device_code,
    client_id = get_config_value("OCI_CLIENT_ID")
  )

  deadline <- min(expires_in, 300) # max poll: 300 sec
  wait_time <- max(10, as.numeric(interval %||% 5))
  start_time <- Sys.time()

  while (TRUE) {
    if (as.numeric(Sys.time() - start_time) > deadline) {
      cli::cli_abort("Timeout.")
    }

    tryCatch({
      response <- httr::POST(
        url = get_config_value("OCI_TOKEN_URL"),
        body = payload,
        encode = "form",
        httr::add_headers("Content-Type" = "application/x-www-form-urlencoded")
      )

      if (httr::status_code(response) == 200) {
        tokens <- httr::content(response, "parsed")
        tokens$obtained_at <- as.numeric(Sys.time())
        save_tokens(tokens)
        return(tokens)
      } else {
        # エラーレスポンスを解析
        error_content <- httr::content(response, "parsed")
        error_code <- error_content$error

        if (error_code == "authorization_pending") {
          # 承認待ち - 何もしない
        } else if (error_code == "slow_down") {
          wait_time <- wait_time + 5  # インターバルを延長
        } else if (error_code %in% c("expired_token", "access_denied")) {
          stop(sprintf("device flow aborted: %s (%s)",
                       error_code, error_content$error_description %||% ""))
        } else {
          stop(sprintf("unexpected error: %s (%s)",
                       error_code, error_content$error_description %||% ""))
        }
      }
    }, error = function(e) {
      if (!grepl("device flow aborted|unexpected error|タイムアウト", e$message)) {
        cat("Unknown error 3513:", e$message, "\n")
      }
      stop(e)
    })

    Sys.sleep(wait_time)
  }
}

#' Refresh access token using refresh token
#'
#' @name refresh_access_token
#'
#' @param tokens
refresh_access_token <- function(tokens) {

  refresh_token <- tokens$refresh_token
  first_access <- tokens$first_access[[1]]

  payload <- list(grant_type = "refresh_token", refresh_token = refresh_token, client_id = get_config_value("OCI_CLIENT_ID"))

  tryCatch({
    response <- httr::POST(
      url = get_config_value("OCI_TOKEN_URL"),
      body = payload,
      encode = "form",
      httr::add_headers("Content-Type" = "application/x-www-form-urlencoded")
    )

    if (httr::status_code(response) != 200) {
      cli::cli_abort("Server error: {httr::status_code(response)}")
    }

    tokens <- httr::content(response, "parsed")
    tokens$obtained_at <- as.numeric(Sys.time())
    save_tokens(tokens, first_access = first_access)
    cli::cli_alert_success("Access token is refreshed.\n")
    return(tokens)
  }, error = function(e) {
    cat("Access token was not refreshed:", e$message, "\n")
    stop(e)
  })
}


#' Ensure Oracle tokens to be valid
#'
#' @name ensure_tokens
#'
ensure_tokens <- function() {
  tokens <- load_tokens()

  # use access token if valid
  if (!is.null(tokens) && verify_access_token(tokens)) {
    return(tokens)
  }

  # try to refresh access toke
  if (!is.null(tokens) && !is.null(tokens$refresh_token)) {
    tryCatch({
      return(refresh_access_token(tokens))
    }, error = function(e) {
      cat("Access token was not refreshed:", e$message, "\n")
    })
  }

  # authorize if tokens are not available
  dev <- authorize_device()
  interval <- as.numeric(dev$interval %||% 5)
  return(poll_for_tokens(dev$device_code, interval, as.numeric(dev$expires_in)))
}
