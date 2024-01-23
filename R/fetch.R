#' Generate paths to AMGSDS data.
#'
#' Generate relative paths to NetCDF files in AMGSDS Server and local directory.
#'
#' @param times A time range to extract.
#' @param lats Latitude range to extract.
#' @param lons longitude range to extract
#' @param element name of element to extract
#' @param source data source
#' @param model climate simulation model for scenario data
#' @param RCP Representative Concentration Pathways for scenario data
#' @param is_clim return climatological normals if `TRUE`
#'
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @export
generate_path <-
  function(times, lats, lons, element, source = "daily",
           model = NULL, RCP = NULL, is_clim = FALSE){

    if(any(!(lubridate::tz(times) %in% c("Asia/Tokyo", "Japan")))){

      tryCatch({
        times <- lubridate::with_tz(times, tzone = "Asia/Tokyo")
        # usethis::ui_warn(c("`times`\u3067\u4e0e\u3048\u3089\u308c\u305f\u6642\u9593\u306f\u6642\u5dee\u3092\u8003\u616e\u305b\u305a\u65e5\u672c\u6a19\u6e96\u6642 (JST; tzone = 'Asia/Tokyo') \u306b\u5909\u63db\u3055\u308c\u307e\u3057\u305f\u3002"))
      },
      error = function(e){
        times
      })
    }

    tryCatch({
      yyyy <- unique(lubridate::year(times))
    },
    error = function(e){
      stop(c("`times`\u304c\u66d6\u6627\u306a\u5f62\u5f0f\u3067\u3059\u3002", "`times`\u306b\u306fYYY-MM-DD\u306e\u3088\u3046\u306b\u533a\u5207\u308a\u6587\u5b57\u3092\u4f7f\u3063\u305f\u6587\u5b57\u5217\u304b\u3001\u65e5\u4ed8\u30fb\u6642\u9593\u95a2\u9023\u30af\u30e9\u30b9\u306e\u30aa\u30d6\u30b8\u30a7\u30af\u30c8\u3092\u4e0e\u3048\u3066\u304f\u3060\u3055\u3044\u3002"))
      # usethis::ui_stop(c("`times` is ambiguous format.", "Use delimiter like YYYY-MM-DD or Date/Time class objects."))
    })

    if(length(yyyy) != 1){
      stop(c("`times`\u306e\u7bc4\u56f2\u304c\u8907\u6570\u5e74\u306b\u307e\u305f\u304c\u3063\u3066\u3044\u307e\u3059\u3002", "`times`\u306e\u59cb\u70b9\u3068\u7d42\u70b9\u3092\u540c\u4e00\u5e74\u306b\u3057\u3066\u304f\u3060\u3055\u3044\u3002"))
      # usethis::ui_stop(c("`times` must be in a single year.", "Data handling over multiple years is not supported at the moment."))
    }

    # check data availability
      check_source_availability(source, element, times, is_clim)
    if(source == "scenario"){
      check_scenario_availability(.times = times, .element = element, .model = model, .RCP = RCP)
    }

    mesh_3rd <- point2code(lats = lats, lons = lons, simple = FALSE)
    mesh <- mesh_3rd$primary

    if(source %in% c("daily", "scenario")){
      time_index <- paste0("[", stringr::str_c(lubridate::yday(range(times)) - 1, collapse = ":1:"), "]")
    } else if(source == "geo"){
      time_index <- ""
    } else if(source == "hourly"){
      time_index <- range(lubridate::yday(times)) * 24 - c(24, 1)
      if(time_index[1] < 0){
        stop(c("`times`\u306e\u59cb\u70b9\u304c\u4e0d\u6b63\u3067\u3059\u3002",
               "YYYY-01-01 00:00\u306f\u59cb\u70b9\u306b\u3067\u304d\u307e\u305b\u3093\u3002",
               "\u59cb\u70b9\u3092YYYY-01-01 01:00\u3068\u3059\u308b\u304b\u3001YYYY-01-01\u3068\u3057\u3066\u304f\u3060\u3055\u3044\u3002"))
        # usethis::ui_stop(c("Invalid start time.", "Start from `YYYY-01-01 01:00` not from `YYYY-01-01 00:00`, or consider to extract data with YYYY-01-01 format."))
      }
      time_index <- paste0("[", stringr::str_c(time_index, collapse = ":1:"), "]")
    } else {
      stop('`source`\u306b\u306f\"daily\"\u3001\"hourly\"\u3001\"scenario\"\u3001 \"geo\"\u306e\u3044\u305a\u308c\u304b\u3092\u6307\u5b9a\u3057\u3066\u304f\u3060\u3055\u3044\u3002')
      # usethis::stop('argument `source` must be either "daily", "hourly", "scenario", or "geo".')
    }

    generate_main <-
      function(meshes){
        if(source == "daily" & is_clim){
          main <- stringr::str_glue("/AMD/{yyyy}/c{element}/AMDy{yyyy}p{meshes}c{element}.nc.nc")
        } else if(source == "daily" & !is_clim){
          main <- stringr::str_glue("/AMD/{yyyy}/e{element}/AMDy{yyyy}p{meshes}e{element}.nc.nc")
        } else if(source == "hourly" & is_clim){
          # this line will not appear because of `check_source_availability`
          stop("climatological normals for hourly data are not available")
        } else if(source == "hourly" & !is_clim){
          main <- stringr::str_glue("/AMD_Hourly/{yyyy}/e{element}/AMDy{yyyy}p{meshes}e_h_{element}.nc.nc")
        } else if(source == "scenario" & is_clim){
          # this line will not appear because of `check_source_availability`
          stop("climatological normals for scenario data are not available")
        } else if(source == "scenario" & !is_clim){
          main <- stringr::str_glue("/AMS/{model}/{RCP}/{yyyy}/e{element}/AMSy{yyyy}p{meshes}e{element}.nc.nc")
        } else if(source == "geo"){
          main <- stringr::str_glue("/AMD/geodata/g{element}/AMDy____p{meshes}g{element}.nc.nc")
        }
        return(main)
      }

    # get lat/lon index of the covering cell
    lat_index <- paste0(as.numeric(mesh_3rd$lat_index), ":1:", as.numeric(mesh_3rd$lat_index))
    lon_index <- paste0(as.numeric(mesh_3rd$lon_index), ":1:", as.numeric(mesh_3rd$lon_index))
    path_point <- stringr::str_glue("{generate_main(mesh)}?{element}{time_index}[{lat_index}][{lon_index}]")

    if(length(lons) == 1 & length(lats) == 1){
      path_area <- path_point
      path_complete <- generate_main(mesh)

      align <- c(1, 1)
    } else {

      # 指定緯度経度範囲に含まれる面データ抽出の場合
      lat_s <- min(as.numeric(substring(mesh, 1, 2)) * 100 + as.numeric(mesh_3rd$lat_index))
      lat_n <- max(as.numeric(substring(mesh, 1, 2)) * 100 + as.numeric(mesh_3rd$lat_index))
      lon_w <- min(as.numeric(substring(mesh, 3, 4)) * 100 + as.numeric(mesh_3rd$lon_index))
      lon_e <- max(as.numeric(substring(mesh, 3, 4)) * 100 + as.numeric(mesh_3rd$lon_index))

      lat_1st <- substring(lat_s, 1, 2):substring(lat_n, 1, 2)
      lon_1st <- substring(lon_w, 1, 2):substring(lon_e, 1, 2)

      # 緯度方向に複数の１次メッシュにまたがる場合・またがらない場合で場合分け
      if(length(lat_1st) == 1){
        lat_3rd <- paste0(as.numeric(substring(lat_s, 3, 4)), ":1:", as.numeric(substring(lat_n, 3, 4)))
      } else {
        lat_3rd <- c(paste0(as.numeric(substring(lat_s, 3, 4)), ":1:79"), rep("0:1:79", max(length(lat_1st) - 2, 0)), paste0("0:1:", as.numeric(substring(lat_n, 3, 4))))
      }

      # 経度方向に複数の１次メッシュにまたがる場合・またがらない場合で場合分け
      if(length(lon_1st) == 1){
        lon_3rd <- paste0(as.numeric(substring(lon_w, 3, 4)), ":1:", as.numeric(substring(lon_e, 3, 4)))
      } else {
        lon_3rd <- c(paste0(as.numeric(substring(lon_w, 3, 4)), ":1:79"), rep("0:1:79", max(length(lon_1st) - 2, 0)), paste0("0:1:", as.numeric(substring(lon_e, 3, 4))))
      }

      paths <-
        tidyr::crossing(lat = paste0(lat_1st, "_", lat_3rd),
                        lon = paste0(lon_1st, "_", lon_3rd)) %>%
        tidyr::separate(.data$lat, into = c("lat_1st", "lat_3rd"), sep = "_", remove = TRUE) %>%
        tidyr::separate(.data$lon, into = c("lon_1st", "lon_3rd"), sep = "_", remove = TRUE) %>%
        dplyr::mutate(mesh = paste0(lat_1st, lon_1st),
                      path_comp = stringr::str_glue("{generate_main(mesh)}"),
                      path_area = stringr::str_glue("{path_comp}?{element}{time_index}[{lat_3rd}][{lon_3rd}]"))

      path_area <- paths$path_area
      path_complete <- paths$path_comp

      align <- c(length(lat_1st), length(lon_1st))
    }

    list(point = path_point, area = path_area, complete = path_complete) %>%
      purrr::map(`attributes<-`, list(mesh = mesh_3rd, align = align))
  }

#' Replace stop words in amgsds paths for WindowsOS
#'
#' @param str One or more character vectors.
#' @param rev Restore replaced words if `TRUE`
#'
replace_stop_words <-
  function(str, rev = FALSE){
    if(!rev){
      str <- stringr::str_replace_all(string = str, pattern = "\\?", replacement = "____")
      str <- stringr::str_replace_all(string = str, pattern = ":", replacement = "----")
      str <- stringr::str_replace_all(string = str, pattern = "([A-Z])----", replacement = paste0(substr(str, 1, 1), ":"))
    } else {
      str <- stringr::str_replace_all(string = str, pattern = "____", replacement = "?")
      str <- stringr::str_replace_all(string = str, pattern = "----", replacement = ":")
    }
    return(str)
  }



#' Download NetCDF files from AMGSDS server
#'
#' @name download_netcdf
#'
#' @param amgsds_path path object generated by generate_path function
#' @param outdir local directory to store downloaded files
#' @param server URL for OPeNDAP server
#' @param .silent suppress download messages if `TRUE`
#' @export
download_netcdf <-
  function(amgsds_path, outdir, server = "amd.rd.naro.go.jp", .silent = TRUE){

    remote <- stringr::str_glue('https://{Sys.getenv("amgsds_id")}:{Sys.getenv("amgsds_pw")}@{server}/opendap/')

    nonempty_mesh <- stringr::str_c(paste0("p", nonempty_meshes), collapse = "|")
    available_path <- stringr::str_subset(amgsds_path, nonempty_mesh)

    from <- paste0(remote, available_path)
    to <- paste0(outdir, available_path)

    suppressWarnings({
      purrr::walk(dirname(to), dir.create, recursive = TRUE, showWarnings = FALSE)

      tryCatch({
        purrr::walk2(from, replace_stop_words(to), ~ curl::curl_download(url = .x, destfile = .y, quiet = .silent))
      },
      error = function(e){
        stop("\u30c7\u30fc\u30bf\u306e\u53d6\u5f97\u306b\u5931\u6557\u3057\u307e\u3057\u305f\u3002amgsds_config()\u3092\u5b9f\u884c\u3057\u3001\u30cd\u30c3\u30c8\u30ef\u30fc\u30af\u306b\u63a5\u7d9a\u3055\u308c\u3066\u3044\u308b\u304b\u3001ID\u30fbPW\u304c\u8a8d\u8a3c\u3055\u308c\u308b\u304b\u3001\u306e\uff12\u70b9\u3092\u78ba\u8a8d\u3057\u3066\u304f\u3060\u3055\u3044\u3002\r\n\u5c06\u6765\u30b7\u30ca\u30ea\u30aa\u30c7\u30fc\u30bf\u3092\u5229\u7528\u3057\u3066\u3044\u308b\u5834\u5408\u306b\u306f\u3001\u30e2\u30c7\u30eb\u3068RCP\u3001\u5bfe\u8c61\u6642\u671f\u304c\u9069\u5207\u306b\u8a2d\u5b9a\u3055\u308c\u3066\u3044\u308b\u304b\u3092\u78ba\u8a8d\u3057\u3066\u304f\u3060\u3055\u3044\u3002")
      })
    })

  }

#' Read NetCDF files from local directory
#'
#' @name read_netcdf
#'
#' @param amgsds_path path object generated by generate_path function
#' @param output format of output object
#' @param localdir local directory for downloaded NetCDF files
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @export
read_netcdf <-
  function(amgsds_path, output = "tibble", localdir){

    files <- paste0(localdir, replace_stop_words(amgsds_path))
    is_hourly <- stringr::str_detect(files[1], pattern = "Hourly")
    is_geo <- stringr::str_detect(files[1], pattern = "geodata")

    ncconnect <-
      purrr::map(files, function(file){
        if(file.exists(file)){
          tidync::tidync(file)
        } else {
          NULL
        }
      })

    if(output == "tibble"){
      result <-
        ncconnect %>%
        purrr::map_dfr(.id = "site_id", function(con){
          if(is.null(con)){
            return(NULL)
          } else {
            return(tidync::hyper_tibble(con))
          }
        })

      if(is_geo){
        result <-
          dplyr::select(result, .data$lat, .data$lon, dplyr::everything()) %>%
          dplyr::mutate(time = "----", .before = 1)
      } else if(is_hourly){
        result <-
          dplyr::select(result, .data$time, .data$lat, .data$lon, dplyr::everything()) %>%
          dplyr::mutate(time = as.POSIXct(.data$time * 3600, origin = "1899-12-31 15:00", tz = "Asia/Tokyo"))
      } else {
        result <-
          dplyr::select(result, .data$time, .data$lat, .data$lon, dplyr::everything()) %>%
          dplyr::mutate(time = as.Date(.data$time, origin = "1900-01-01", tz = "Asia/Tokyo"))
      }

    } else if(output == "array"){

      is_available <- stringr::str_extract(basename(amgsds_path), "p[:digit:]{4}") %in% paste0("p", nonempty_meshes)

      if(is_geo){
        axis <- list(lon = "lon", lat = "lat")
      } else {
        axis <- list(lon = "lon", lat = "lat", time = "time")
      }

      axes <-
        axis %>%
        purrr::map(function(x){
          ncconnect %>%
            purrr::map(function(con){
              if(is.null(con)){
                return(NULL)
              } else {
                return(tidync::hyper_transforms(con))
              }
            }) %>%
            purrr::map_dfr(x) %>%
            dplyr::pull(x) %>%
            unique %>% sort
        })

      if(is_geo){
        axes$time <- "----"
      } else if(is_hourly){
        axes$time <- as.POSIXct(axes$time * 3600, origin = "1899-12-31 15:00", tz = "Asia/Tokyo")
      } else {
        axes$time <- as.Date(axes$time, origin = "1900-01-01", tz = "Asia/Tokyo")
      }

      val <-
        ncconnect %>%
        purrr::map(function(con){
          if(is.null(con)){
            return(NULL)
          } else {
            return(tidync::hyper_array(con,  drop = FALSE)[[1]])
          }
        })

      ##################
      # to be improved #
      ##################

      # redundant code: need refactoring to improve performance and readability
      #
      # concatenating multiple netcdf arrays into a single array
      # some missing primary meshes are filled with NA.

      align <- attributes(amgsds_path)$align
      meshes <- array(1:prod(align), rev(align))
      is_meshes_available <- array(is_available, rev(align))

      non_empty_lon <- apply(is_meshes_available, 1, any) # from west to east
      non_empty_lat <- apply(is_meshes_available, 2, any) # from south to north

      edge_south <- meshes[, 1]
      edge_north <- meshes[, align[1]]
      edge_west  <- meshes[1,]
      edge_east  <- meshes[align[2],]

      nrow_south <- purrr::map(val[edge_south], ncol) %>% unlist %>% unique
      nrow_north <- purrr::map(val[edge_north], ncol) %>% unlist %>% unique
      ncol_west <-  purrr::map(val[edge_west], nrow) %>% unlist %>% unique
      ncol_east <-  purrr::map(val[edge_east], nrow) %>% unlist %>% unique

      for(LAT in which(non_empty_lat)){
        for(LON in which(non_empty_lon)){
      # for(LAT in 1:align[1]){
      #   for(LON in 1:align[2]){
          index <- (LAT-1) * align[2] + LON

          if(LAT == 1){
            NLAT <- nrow_south
          } else if(LAT == align[1]){
            NLAT <- nrow_north
          } else {
            NLAT <- 80
          }

          if(LON == 1){
            NLON <- ncol_west
          } else if(LON == align[2]){
            NLON <- ncol_east
          } else {
            NLON <- 80
          }

          if(is.null(val[[index]])){
            if(is_geo){
              val[[index]] <- array(NA, dim = c(NLON, NLAT))
            } else {
              val[[index]] <- array(NA, dim = c(NLON, NLAT, length(axes$time)))
            }
          }
        }
      }

      result <-
        purrr::map(1:align[1], function(x){
          val[(x - 1) * align[2] + 1:align[2]] %>%
            abind::abind(along = 1)
        }) %>%
        abind::abind(along = 2)

      ###############################


      if(is_geo){
        # add third dimension
        dim(result) <- c(dim(result), 1)
      }

      attributes(result)$axes <- axes
      attributes(result)$dimnames <- NULL
    } else {
      result <-
        ncconnect
    }
    return(result)
  }


#' Fetch data from AMGSDS server
#'
#' @name fetch_amgsds
#' @param times time range to extract
#' @param lats latitude range to extract
#' @param lons longitude range to extract
#' @param elements names of element to extract
#' @param mode switch point/area/whole-mesh extraction
#' @param source data source
#' @param output format of output object
#' @param model climate simulation model for scenario data
#' @param RCP Representative Concentration Pathways for scenario data
#' @param is_clim logical. return climatological normals if `TRUE`
#' @param server URL for OPeNDAP server
#' @param .silent logical. suppress download message if `TRUE`
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#' fetch_amgsds(times = c("2021-03-12", "2021-03-30"), lats = 43, lons = 143,
#'              elements = c("TMP_min", "TMP_max", "RH"))
#' fetch_amgsds(times = lubridate::today() + 1:5, lats = 35:36, lons = 139:140,
#'              elements = "APCP", mode = "area", output = "array")
#' fetch_amgsds(times = c("2023-08-03 10:30", "2023-08-05 19:30"), lats = 35, lons = 135,
#'              elements = "TMP", mode = "point", source = "hourly")
#' }
#'
#' @export
fetch_amgsds <-
  function(times = Sys.time(),
           lats, lons, elements,
           mode = "point",
           source = "daily",
           output = "tibble",
           model = "MIROC5", RCP = "RCP8.5",
           is_clim = FALSE, server = "amd.rd.naro.go.jp", .silent = TRUE){

    yyyy <- unique(lubridate::year(times))

    if(length(elements) == 1){
      if(length(yyyy) == 1){
        amgsds_path <-
          generate_path(times, lats, lons, elements, source = source,
                        model = model, RCP = RCP, is_clim = is_clim)

        tempdir <- tempdir()
        download_netcdf(amgsds_path[[mode]], tempdir, server, .silent = .silent)

        result <- read_netcdf(amgsds_path[[mode]], output = output, localdir = tempdir)

        if(mode != "point" & output == "tibble"){
          result$site_id <- NULL
        }

        if(output == "array"){
          attributes(result)$variable <- elements
        }
        return(result)
      } else {
        multiyears <- lubridate::year(times)
        multiyears <- multiyears[1]:multiyears[2]
        timesplits <-
          purrr::map(seq_along(multiyears), function(y){
            if(y == 1){
              c(min(lubridate::with_tz(times, tzone = "Asia/Tokyo")), lubridate::ymd(paste0(multiyears[y], "-12-31"), tz = "Asia/Tokyo"))
            } else if (y == length(multiyears)){
              c(lubridate::ymd(paste0(multiyears[y], "-01-01"), tz = "Asia/Tokyo"), max(lubridate::with_tz(times, tzone = "Asia/Tokyo")))
            } else {
              c(lubridate::ymd(paste0(multiyears[y], "-01-01"), tz = "Asia/Tokyo"), lubridate::ymd(paste0(multiyears[y], "-12-31"), tz = "Asia/Tokyo"))
            }

          }) %>%
          purrr::map(lubridate::date)

        result <-
          purrr::map(timesplits, ~ fetch_amgsds(., lats, lons, elements, mode, source, output, model, RCP, is_clim, server, .silent))

        if(output == "tibble"){
          result <-
            dplyr::bind_rows(result)
        }
      }

    } else {
      result <-
        purrr::map(elements,  ~ fetch_amgsds(times, lats, lons, ., mode, source, output, model, RCP, is_clim, server, .silent))
      if(output == "tibble"){
        common_names <-
          purrr::map(result, names) %>%
          purrr::reduce(intersect)

        result <-
          result %>%
          purrr::reduce(dplyr::full_join, common_names)

      }
    }

    is_hour_explicit <- any(nchar(as.character(times)) > 10)

    if(output == "tibble" & is_hour_explicit){
      result <-
        result %>%
        dplyr::filter(dplyr::between(.data$time, min(times), max(times)))
    } else if(output == "tibble" & !is_hour_explicit){
      result <-
        result %>%
        dplyr::filter(dplyr::between(.data$time, min(times), max(times) + lubridate::hours(23)))
    }
    return(result)
  }

#' Load data from local directory
#'
#' @name load_amgsds
#' @param times time range to extract
#' @param lats latitude range to extract
#' @param lons longitude range to extract
#' @param elements names of element to extract
#' @param mode switch point/area/whole-mesh extraction
#' @param source data source
#' @param output format of output object
#' @param model climate simulation model for scenario data
#' @param RCP Representative Concentration Pathways for scenario data
#' @param is_clim logical. return climatological normals if `TRUE`
#' @param server URL for OPeNDAP server
#' @param .silent logical. suppress download message if `TRUE`
#' @param localdir localdir directory for downloaded NetCDF files
#' @param autodownload logical. download lacking NetCDF files if `TRUE`
#'
#' @export
load_amgsds <-
  function(times = Sys.time(),
           lats, lons, elements,
           mode = "point",
           source = "daily",
           output = "tibble",
           model = "MIROC5", RCP = "RCP8.5",
           is_clim = FALSE, server = "amd.rd.naro.go.jp", .silent = TRUE,
           localdir, autodownload = FALSE){
    if(length(elements) == 1){
      amgsds_path <-
        generate_path(times, lats, lons, elements, source = source,
                      model = model, RCP = RCP, is_clim = is_clim)

      # check if all mesh data available
      not_exist <- !file.exists(paste0(localdir, amgsds_path[["complete"]]))
      is_available <- stringr::str_extract(basename(amgsds_path[["complete"]]), "p[:digit:]{4}") %in% paste0("p", nonempty_meshes)

      if(sum(not_exist & is_available) > 0 & autodownload){

        usethis::ui_info(paste0(elements, "\u306eNetCDF\u30d5\u30a1\u30a4\u30eb\u3092OPeNDAP\u30b5\u30fc\u30d0\u304b\u3089\u30c0\u30a6\u30f3\u30ed\u30fc\u30c9\u3057\u307e\u3059\u3002"))
        # usethis::ui_info(paste(elements, "NetCDF files are downloaded from OPeNDAP server."))
        download_netcdf(amgsds_path = amgsds_path[["complete"]][not_exist & is_available], outdir = localdir, server, .silent = .silent)

      } else if(sum(not_exist & is_available) > 0 & !autodownload){

        stop(paste0(elements, "\u306e\u5fc5\u8981\u306aNetCDF\u30d5\u30a1\u30a4\u30eb\u304c", localdir, "\u4ee5\u4e0b\u306b\u5b58\u5728\u3057\u307e\u305b\u3093\u3002", "`load_amgsds(..., autodownload = TRUE)`\u3068\u3059\u308b\u3068\u5fc5\u8981\u306a\u30d5\u30a1\u30a4\u30eb\u304c\u30c0\u30a6\u30f3\u30ed\u30fc\u30c9\u3055\u308c\u307e\u3059\u3002"))
        # usethis::ui_oops(paste(elements, "NetCDF files are not available. Set `autodownload = TRUE` to allow file download."))

      } else {

        usethis::ui_info(paste0(localdir, "\u4ee5\u4e0b\u306b\u4fdd\u5b58\u3055\u308c\u305f", elements, "\u30c7\u30fc\u30bf\u3092\u8aad\u307f\u8fbc\u307f\u307e\u3059\u3002"))
        # usethis::ui_info(paste(elements, "data are loaded local files from", localdir))

      }

      result0 <- read_netcdf(amgsds_path = amgsds_path[["complete"]], output = output, localdir = localdir)

      if(is.character(times)){
        times <- lubridate::with_tz(times, tzone = "Asia/Tokyo")
      }

      if(output == "array"){
        axes <- attributes(result0)$axes
        if(source == "geo"){
          time_extract <- 1
        } else if(source == "hourly"){
          time_extract <- dplyr::between(as.POSIXct(axes$time, tz = "Asia/Tokyo"), min(times), max(times))
        } else {
          time_extract <- dplyr::between(axes$time, as.Date.character(min(times)), as.Date.character(max(times)))
        }
        if(mode == "point"){

          lat_extract <- purrr::map_int(lats, ~ which.min(abs(. - axes$lat)))
          lon_extract <- purrr::map_int(lons, ~ which.min(abs(. - axes$lon)))

          axes$lat  <- axes$lat[lat_extract]
          axes$lon  <- axes$lon[lon_extract]
          axes$time <- axes$time[time_extract]

          result <-
            result0[lon_extract, lat_extract, time_extract, drop = FALSE]

          attributes(result)$variable <- elements
          attributes(result)$axes <- axes

        } else if(mode == "area"){
          lat_extract <- which(dplyr::between(axes$lat, min(lats), max(lats)))
          lon_extract <- which(dplyr::between(axes$lon, min(lons), max(lons)))
          axes$lat <- axes$lat[lat_extract]
          axes$lon <- axes$lon[lon_extract]
          axes$time <- axes$time[time_extract]

          result <- result0[lon_extract, lat_extract, time_extract, drop = FALSE]
          attributes(result)$variable <- elements
          attributes(result)$axes <- axes
        } else {
          result <- result0[,,time_extract, drop = FALSE]
          axes$time <- axes$time[time_extract]
          attributes(result)$variable <- elements
          attributes(result)$axes <- axes
        }
      } else if(output == "tibble"){

        if(source == "geo"){
          axes <- list(lon = unique(result0$lon),
                       lat = unique(result0$lat),
                       time = "----")
        } else {

          if(source == "hourly"){
            result0 <-
              result0 %>%
              dplyr::filter(dplyr::between(.data$time, min(times), max(times)))
          } else {
            result0 <-
              result0 %>%
              dplyr::filter(dplyr::between(.data$time, as.Date.character(min(times)), as.Date.character(max(times))))
          }

          axes <- list(lon = unique(result0$lon),
                       lat = unique(result0$lat),
                       time = unique(result0$time))
        }

        if(mode != "point"){
          result0$site_id <- NULL
        }

        if(mode == "point"){
          lat_extract <- axes$lat[purrr::map_int(lats, ~ which.min(abs(. - axes$lat)))]
          lon_extract <- axes$lon[purrr::map_int(lons, ~ which.min(abs(. - axes$lon)))]

          result <-
            purrr::map2_dfr(.id = "site_id", lat_extract, lon_extract, function(LAT, LON){
              dplyr::filter(result0, .data$lat == LAT, .data$lon == LON)
            })
        } else if(mode == "area"){
          result <-
            dplyr::filter(result0,
                          dplyr::between(.data$lat, min(lats), max(lats)),
                          dplyr::between(.data$lon, min(lons), max(lons)))
        } else {
          result <- result0
        }
      } else {
        # output = "raw"
        result <- result0
      }

      return(result)
    } else {
      result <-
        purrr::map(elements,  ~ load_amgsds(times, lats, lons, ., mode, source, output, model, RCP, is_clim, .silent, localdir, autodownload))
      if(output == "tibble"){
        common_names <-
          purrr::map(result, names) %>%
          purrr::reduce(intersect)

        result <-
          result %>%
          purrr::reduce(dplyr::full_join, common_names)
      }
    }

    return(result)
  }
