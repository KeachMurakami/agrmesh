#' Verify and initialize id and pw for AMGSDS system
#'
#' @name amgsds_config
#'
#' @export
#' @param userid your user id issued by the development group
#' @param password your password issued by the development group
#' @param server URL for OPeNDAP server
#' @param .force logical. pass verification for offline .onLoad
amgsds_config <-
  function(userid = Sys.getenv("amgsds_id"), password = Sys.getenv("amgsds_pw"), server = "https://amd.rd.naro.go.jp/opendap", .force = FALSE){
    status_url <- stringr::str_glue("{server}/status/status")
    is_network_available <- TRUE

    # save user id and password in R_environ
    # this message appears only once after installation
    if(userid == "" | password == ""){
      usethis::edit_r_environ()
      invisible(TRUE)
    }

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

    if(is_network_available){
      # verify id/pw
      tryCatch({
        handle <- curl::new_handle()
        curl::handle_setopt(handle, userpwd = stringr::str_glue('{userid}:{password}'))
        curl::handle_setopt(handle, sslversion = 6)
        curl::handle_setopt(handle, useragent = 'curl/7.50.1')
        curl::handle_setopt(handle, httpheader = c('Accept' = '*/*'))

        connect <- curl::curl_fetch_memory(url = status_url, handle = handle)
        if(connect$status_code == 200){
          usethis::ui_done("USERID and PASSWORD -> verified\n")
        } else {
          usethis::ui_oops(c("Incorrect USERID and/or PASSWORD/", "Use correct `amgsds_id` and `amgsds_pw`."))
          usethis::edit_r_environ()
          invisible(TRUE)
        }
      },
      error = function(e){
        stop("unexpexted error")
      })
    }
  }
