# internal configurations -------------------------------------------------

.pkg_config <- new.env(parent = emptyenv())

.pkg_config$active_mode <- "classic"

.pkg_config$config <- list(
  oracle = list(
    opendap_ext = ".nc.dap.nc4",
    opendap_sep = "dap4.ce=/",
    OCI_TOKEN_FILE = file.path(path.expand("~"), ".idcs_device_tokens.json"),
    OCI_TOKEN_URL = "https://idcs-277be580d4864cef98b9c7d572600423.identity.oraclecloud.com/oauth2/v1/token",
    OCI_DEVICE_URL = "https://idcs-277be580d4864cef98b9c7d572600423.identity.oraclecloud.com/oauth2/v1/device",
    OCI_CLIENT_ID = "5e72bb0b28334e7ea392eebfb57a9f86",
    OCI_SCOPE = "openid profile email offline_access groups get_groups"
  ),
  classic = list(
    opendap_ext = ".nc.nc",
    opendap_sep = ""
  )
)

get_config_value <- function(key, mode = NULL) {
  if (is.null(mode)) {
    mode <- .pkg_config$active_mode
  }

  .pkg_config$config[[mode]][[key]]
}

set_config_value <- function(key, value, mode = NULL) {
  if (is.null(mode)) {
    mode <- .pkg_config$active_mode
  }

  .pkg_config$config[[mode]][[key]] <- value
}


#' Switch AMGSDS system between Oracle and classic ones
#'
#' @name switch_system
#'
#' @param mode chr. AMGSDS system mode, "oracle" or "classic" (for commercial users)
#' @param url chr. Specific opendap server (for commercial users)
#'
#' @export
switch_system <-
  function(mode = c("oracle", "classic"), server = NULL) {
    mode <- match.arg(mode)
    .pkg_config$active_mode <- mode

    cat("\n\n\n")
    cli::cli_alert_success(sprintf("Switched to %s mode.", mode))

    if(mode == "classic" & is.null(server)){
      cli::cli_h1("Important notice for non-commercial users")
      cli::cli_alert_danger("\u91cd\u8981\u306a\u304a\u77e5\u3089\u305b\n\u304a\u4f7f\u3044\u306e\u8a8d\u8a3c\u65b9\u5f0f\u3067\u306e\u5229\u7528\u306f\u8fd1\u65e5\u4e2d\u306b\u505c\u6b62\u3055\u308c\u307e\u3059\u3002\u4ee5\u4e0b\u306e\u30b3\u30de\u30f3\u30c9\u3067\u65b0\u3057\u3044\u8a8d\u8a3c\u65b9\u5f0f\u306b\u5207\u308a\u66ff\u3048\u3066\u304f\u3060\u3055\u3044\u3002")
      cli::cli_alert("switch_system(mode = 'oracle')")
    }

    if(is.null(server)){
      default_servers <- list(oracle = "https://amd2.rd.naro.go.jp/opendap-api", classic = "https://amd.rd.naro.go.jp/opendap")
      Sys.setenv(amgsds_server = default_servers[[mode]])
    } else {
      Sys.setenv(amgsds_server = server)
      message(sprintf("Data provider: %s", server))
    }
    invisible(mode)
  }


#' Verify and initialize id and pw for AMGSDS system
#'
#' @name amgsds_config
#'
#' @param mode  chr. AMGSDS system mode, "oracle" or "classic" (for commercial users)
#' @param .force logical. pass verification for offline .onLoad
#' @export
amgsds_config <-
  function(mode = .pkg_config$active_mode, .force = FALSE){
    server <- Sys.getenv("amgsds_server")
    status_url <- stringr::str_glue("{server}/status/status")

    # save user id, password, and server in R_environ
    # this message appears only once after installation
    if(server == ""){
      usethis::edit_r_environ()
      stop()
    }

    is_network_available <- TRUE

    # verify network connection
    tryCatch({
      connect <- curl::curl_fetch_memory(url = "http://clients3.google.com/generate_204")
    },
    error = function(e){
      is_network_available <<- FALSE
      if(.force){
        usethis::ui_oops(c("Not connected to the internet", "Check the connection and restart Rstudio."))
      } else {
        stop("Not connected to the internet.")
      }
    })

    if(mode == "oracle"){
      if(is_network_available){
        tryCatch(
          {
            access_token <- get_access_token()
            handle <- curl::new_handle()
            curl::handle_setheaders(handle, "User-Agent" = "curl/7.50.1", "Accept" = "*/*", "Authorization" = paste("Bearer", access_token))
            connect <- curl::curl_fetch_memory(status_url, handle = handle)

            if(connect$status_code == 200){
              usethis::ui_done("Passed authentification\n")
            } else {
              stop("Network error")
              invisible(TRUE)
            }
          },
          error = function(e){
            stop("unexpexted error")
          })
      }
    } else {

      userid = Sys.getenv("amgsds_id")
      password = Sys.getenv("amgsds_pw")

      # save user id and password in R_environ
      # this message appears only once after installation
      if(userid == "" | password == ""){
        usethis::edit_r_environ()
        invisible(TRUE)
      }

      if(is_network_available){
        tryCatch(
          {
            handle <- curl::new_handle()
            curl::handle_setopt(handle, userpwd = stringr::str_glue('{userid}:{password}'))
            curl::handle_setopt(handle, sslversion = 6)
            curl::handle_setopt(handle, useragent = 'curl/7.50.1')
            curl::handle_setopt(handle, httpheader = c('Accept' = '*/*'))

            connect <- curl::curl_fetch_memory(url = status_url, handle = handle)
            if(connect$status_code == 200){
              usethis::ui_done("USERID and PASSWORD -> verified\n")
            } else {
              usethis::ui_oops(c("Incorrect USERID, PASSWORD, and/or server/", "Use correct `amgsds_id`, `amgsds_pw`, and `amgsds_server."))
              usethis::edit_r_environ()
              invisible(TRUE)
            }
          },
          error = function(e){
            stop("unexpexted error")
          })
      }
    }
  }
