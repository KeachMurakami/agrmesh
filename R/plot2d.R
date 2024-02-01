#' Extract a single variable column name
#'
#' @param tbl AMGSDS tibble
#' @param element_index index of element to be shown
#'
check_variables <-
  function(tbl, element_index = 1){
    variable_name <-
      setdiff(names(tbl), c("lon", "lat", "time", "site_id"))

    if(length(variable_name) > 1){
      usethis::ui_warn(paste0("\u8907\u6570\u306e\u8981\u7d20\u306e\u30c7\u30fc\u30bf\u304c\u5b58\u5728\u3057\u307e\u3059\u3002`element_index`\u3067\u6307\u5b9a\u3055\u308c\u305f", element_index, "\u756a\u76ee\u306e\u8981\u7d20\u306e\u307f\u304c\u8868\u793a\u3055\u308c\u3066\u3044\u307e\u3059\u3002"))
      # usethis::ui_warn("two or more variables exist, showing the first variable.")
    }

    return(variable_name[element_index])
  }



#' Create polygon shape geometry from data with latitude and longitude
#'
#' @param amgsds_tibble AMGSDS object
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @export
polygonize <-
  function(amgsds_tibble){
    polys <-
      amgsds_tibble %>%
      dplyr::mutate(bound_lat0 = .data$lat - 1/240,
                    bound_lat1 = .data$lat + 1/240,
                    bound_lon0 = .data$lon - 1/160,
                    bound_lon1 = .data$lon + 1/160) %>%
      tidyr::nest(bbox = tidyselect::starts_with("bound")) %>%
      dplyr::mutate(geometry =
                      purrr::map(.data$bbox, function(x){
                        do.call(rbind,
                                list(c(x$bound_lon0, x$bound_lat0),
                                     c(x$bound_lon1, x$bound_lat0),
                                     c(x$bound_lon1, x$bound_lat1),
                                     c(x$bound_lon0, x$bound_lat1),
                                     c(x$bound_lon0, x$bound_lat0))) %>%
                                   list %>%
                                   sf::st_polygon()
                        })
                    ) %>%
      sf::st_as_sf(crs = 4326)
  }




#' Plotting AMGSDS variables with shape map
#'
#' @param amgsds_tibble AMGSDS tibble object
#' @param element_index index of element to be shown
#' @param time_index index of time to be shown
#' @param alpha transparency of tiles (0 = fully transparent, 1 = opaque)
#' @param pref_code pref id, refer to jpndistrict::jpnprefs
#' @importFrom rlang .data
#'
#' @export
plot2d_shape <-
  function(amgsds_tibble, element_index = 1, time_index = 1, alpha = .5, pref_code){

    # require(jpndistrict)
    if(class(amgsds_tibble)[1] %in% c("array", "list")){
      amgsds_tibble <- amgsds_tibble %>% unfold_array()
    }

    variable_name <- check_variables(amgsds_tibble, element_index)

    uniq_times <- unique(amgsds_tibble$time)
    num_times <- length(uniq_times)

    if(num_times > 1){
      dat <- dplyr::filter(amgsds_tibble, .data$time %in% uniq_times[time_index[time_index <= num_times]])

      usethis::ui_warn(paste0(num_times, "\u500b\u306e\u65e5\u4ed8\u30fb\u6642\u523b\u306e\u30c7\u30fc\u30bf\u304c\u5b58\u5728\u3057\u307e\u3059\u3002", "`time_index`\u3067\u6307\u5b9a\u3055\u308c\u305f", stringr::str_flatten(time_index[time_index <= num_times], collapse = "-"), "\u756a\u76ee\u306e\u30c7\u30fc\u30bf\u306e\u307f\u304c\u8868\u793a\u3055\u308c\u3066\u3044\u307e\u3059\u3002"))
      # usethis::ui_warn(paste0("two or more temporal data exist, showing ", time_index, "th data."))
    } else{
      dat <- amgsds_tibble
    }

    pref_shapes <- purrr::map_dfr(pref_code, ~ jpndistrict::jpn_pref(.))

    lon_range <- range(dat$lon, na.rm = TRUE)
    lat_range <- range(dat$lat, na.rm = TRUE)

    ggplot2::ggplot(data = dat) +
      ggplot2::geom_sf(data = pref_shapes, fill = "grey") +
      ggplot2::geom_tile(alpha = alpha, ggplot2::aes(.data$lon, .data$lat, fill = .data[[variable_name]])) +
      ggplot2::geom_sf(data = pref_shapes, fill = NA, col = "white") +
      ggplot2::scale_fill_viridis_c(na.value = NA) +
      ggplot2::facet_wrap(~ time) +
      ggplot2::coord_sf(xlim = lon_range, ylim = lat_range)
  }


#' Plotting AMGSDS variables on interactive leaflet map
#'
#' @param amgsds_tibble AMGSDS tibble object
#' @param element_index index of element to be shown
#' @param time_index index of time to be shown
#' @param alpha transparency of tiles (0 = fully transparent, 1 = opaque)
#' @param pallete color palette
#' @param basemap source of background map
#' @param thin thinning factor to avoid hanging (1 = show all meshes, 0.05 = show 5 % of available meshes)
#' @importFrom rlang .data
#' @importFrom magrittr %>%
#'
#' @export
plot2d_leaflet <-
  function(amgsds_tibble, element_index = 1, time_index = 1, alpha = .7, pallete = "viridis", basemap = leaflet:::providers$Esri.WorldImagery, thin = 1){

    if(class(amgsds_tibble)[1] %in% c("array", "list")){
      amgsds_tibble <- amgsds_tibble %>% unfold_array()
    }

    variable_name <- check_variables(amgsds_tibble, element_index)
    names(amgsds_tibble)[names(amgsds_tibble) == variable_name] <- "value"

    uniq_times <- unique(amgsds_tibble$time)
    num_times <- length(uniq_times)

    if(num_times > 1){
      dat <- dplyr::filter(amgsds_tibble, .data$time %in% uniq_times[time_index[time_index <= num_times]])

      usethis::ui_warn(paste0(num_times, "\u500b\u306e\u65e5\u4ed8\u30fb\u6642\u523b\u306e\u30c7\u30fc\u30bf\u304c\u5b58\u5728\u3057\u307e\u3059\u3002", "`time_index`\u3067\u6307\u5b9a\u3055\u308c\u305f", stringr::str_flatten(time_index[time_index <= num_times], collapse = "-"), "\u756a\u76ee\u306e\u30c7\u30fc\u30bf\u306e\u307f\u304c\u8868\u793a\u3055\u308c\u3066\u3044\u307e\u3059\u3002"))
      # usethis::ui_warn(paste0("two or more temporal data exist, showing ", time_index, "th data."))
    } else{
      dat <- amgsds_tibble
    }

    polys <-
      dat %>%
      dplyr::filter(!is.na(.data$value)) %>%
      polygonize() %>%
      dplyr::sample_frac(size = thin)

    fill_pallete <- leaflet::colorNumeric(palette = pallete, domain = polys$value, na.color = NA)

    leaflet::leaflet(polys) %>%
      leaflet::addProviderTiles(provider = basemap) %>%
      leaflet::addPolygons(popup = ~ as.character(round(value, 1)),
                           popupOptions = leaflet::popupOptions(maxWidth ="100%", closeOnClick = TRUE),
                           fillOpacity = alpha, stroke = FALSE,
                           color = ~ fill_pallete(value), group = ~ time) %>%
      leaflet::addLayersControl(
        baseGroups = sort(unique(polys$time)),
        options = leaflet::layersControlOptions(collapsed = FALSE)
      ) %>%
      leaflet::addLegend(pal = fill_pallete, values = ~ value, title = variable_name)
  }
