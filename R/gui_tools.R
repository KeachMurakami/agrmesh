#' Launch map finder
#'
#' Launch an interactive leaflet map to find lat/lon
#'
#' @export
find_location <-
  function(){

    # to import unused `leaflet.extras`
    ignore_unused_imports <- function(){
      leaflet.extras::leafletExtrasDependencies
    }

    suppressWarnings({

      basemap <-
        leaflet::setView(mapview::mapview()@map, lng = 138, lat = 38, zoom = 6)

      sites <- mapedit::editMap(basemap, record = TRUE,
                                title = "\u5730\u70b9\u002f\u7bc4\u56f2\u3092\u6307\u5b9a\u3057\u3066\u304f\u3060\u3055\u3044",
                                editor = "leaflet.extras",
                                editorOptions = list(polylineOptions = FALSE,
                                                     polygonOptions = FALSE,
                                                     circleMarkerOptions = FALSE)
      )

      if(is.null(sites$finished)){
        usethis::ui_todo("\u5bfe\u8c61\u5730\u70b9\u002f\u7bc4\u56f2\u3092\u9078\u629e\u3057\u3066\u304b\u3089\u0027\u0044\u006f\u006e\u0065\u0027\u30dc\u30bf\u30f3\u3092\u62bc\u3057\u3066\u304f\u3060\u3055\u3044\u002e")
      } else {
        all_sites <- tibble::as_tibble(sf::st_coordinates(sites$finished))
        unique_sites <- dplyr::distinct(all_sites, lon = .data$X, lat = .data$Y)


        result <-
          list(points = unique_sites,
               lat_range = range(unique_sites$lat),
               lon_range = range(unique_sites$lon))

        return(result)
      }

    })
  }

#' #' set time of interest for gui-users
#' #'
#' set_toi <-
#'   function(){
#'     calendarInput <-
#'       function(id, label = NULL){
#'         ns <- shiny::NS(id)
#'
#'         miniUI::miniPage(
#'           shinyWidgets::airDatepickerInput(inputId = ns("air"), label = label, range = TRUE, inline = TRUE),
#'           miniUI::gadgetTitleBar(title = "Set time range of interest",
#'                                  right = miniUI::miniTitleBarButton("done", "Done", primary = TRUE))
#'         )
#'       }
#'
#'     calendar <-
#'       function(input, output, session){
#'         return(shiny::reactive({input$air}))
#'       }
#'
#'     ui <-
#'       calendarInput("calendar_dates", label = "Time range")
#'
#'     server <-
#'       function(input, output, session) {
#'         catcher <- shiny::callModule(calendar, "calendar_dates")
#'
#'         shiny::observeEvent(input$done, {
#'           shiny::stopApp(catcher())
#'         })
#'         session$onSessionEnded(function() {
#'           shiny::stopApp(isolate(catcher()))
#'         })
#'         shiny::observeEvent(input$cancel, {
#'           shiny::stopApp(NULL)
#'         })
#'       }
#'
#'     res <- shiny::runGadget(ui, server)
#'
#'     if(lubridate::year(res)[1] != lubridate::year(res)[2]){
#'       usethis::ui_stop("years of start and end dates must be the same.")
#'     }
#'
#'     result <- list(year = lubridate::year(res)[1],
#'                    doy = seq(lubridate::yday(res[1]), lubridate::yday(res[2])))
#'     return(result)
#'   }
