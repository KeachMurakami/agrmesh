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
  function(userid = Sys.getenv("amgsds_id"), password = Sys.getenv("amgsds_pw"), server = "amd.rd.naro.go.jp", .force = FALSE){

    is_network_available <- TRUE

    # save user id and password in R_environ
    # this message appears only once after installation
    if(userid == "" | password == ""){
      usethis::edit_r_environ()
      invisible(TRUE)
    }

    # verify network connection
    tryCatch({
      connect <- readr::read_lines("https://www.google.com")
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
        connect <- readr::read_lines(stringr::str_glue("https://{userid}:{password}@{server}/opendap/AMD/"))
        usethis::ui_done("USERID and PASSWORD -> verified\n")
      },
      error = function(e){
        usethis::ui_oops(c("Incorrect USERID and/or PASSWORD/", "Use correct `amgsds_id` and `amgsds_pw`."))
        usethis::edit_r_environ()
        invisible(TRUE)
      })
    }
  }
