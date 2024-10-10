#' Conver array to long-format tibble
#'
#' @name unfold_array
#' @param amgsds_array AMGSDS array object (output = "array")
#' @param time_index indices of time to be extracted
#' @param na.rm logical. missing values including NaN are removed if `TRUE`
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom rlang :=
#'
#' @export
unfold_array <-
  function(amgsds_array, time_index = NULL, na.rm = TRUE){

    # when a single element is fetched
    if(!is.list(amgsds_array)){

      axes <- attributes(amgsds_array)$axes
      variable <- attributes(amgsds_array)$variable

      if(!is.null(time_index)){
        dat <- amgsds_array[,, time_index]
        val_time <- axes$time[time_index]
      } else{
        dat <- amgsds_array
        val_time <- axes$time
      }

      val_lat  <- axes$lat
      val_lon  <- axes$lon
      n_time <- length(val_time)
      n_lat  <- length(val_lat)
      n_lon  <- length(val_lon)

      result <-
        tibble::tibble(rlang::`!!`(variable) := c(dat)) %>%
        dplyr::mutate(time = rep(val_time, each = n_lon * n_lat),
                      lat = rep(rep(val_lat, each  = n_lon), times = n_time),
                      lon = rep(rep(val_lon, times = n_lat), times = n_time),
                      .before = 1)

      if(na.rm){
        result <- stats::na.omit(result)
      }

    } else {
      # when some elements are fetched at once and given as a list
      result <-
        purrr::map(amgsds_array,  ~ unfold_array(., time_index = time_index, na.rm = na.rm)) %>%
        purrr::reduce(dplyr::full_join, c("time", "lat", "lon"))
    }

    return(result)
  }

#' Conver long-format tibble to array
#'
#' @name fold_tibble
#' @param amgsds_tibble AMGSDS tibble object (output = "tibble")
#' @importFrom rlang .data
#'
#' @export
fold_tibble <-
  function(amgsds_tibble){

    variable <- setdiff(names(amgsds_tibble), c("time", "lat", "lon"))
    # when a single element is fetched

    purrr::map(variable, function(v){
      array <-
        split(amgsds_tibble, amgsds_tibble$time) |>
        purrr::map(function(x){
          dplyr::select(x, .data$lat, .data$lon, tidyselect::all_of(v)) |>
          tidyr::spread(lat, !!(v)) |>
          dplyr::select(-.data$lon)
        }) |>
        abind::abind(along = 3)

      dimnames(array) <- c(NULL, NULL, NULL)
      attr(array, which = "axes") <- list(lon = sort(unique(amgsds_tibble$lon)),
                                          lat = sort(unique(amgsds_tibble$lat)),
                                          time = sort(unique(amgsds_tibble$time)))
      attr(array, which = "variable") <- v

      return(array)
    })
  }
