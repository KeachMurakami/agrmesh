#' Confirm lat/lon ranges are in the scope
#'
#' @param lats latitudes
#' @param lons longitudes
#' @return stop if lats or lons protrude from the supported area
#'
check_latlon_range <-
  function(lats, lons){
    if(max(lats) > 46 | min(lats) < 24 | max(lons) > 146 | min(lons) < 122){
      stop(c("\u6307\u5b9a\u3055\u308c\u305f\u7def\u5ea6\u30fb\u7d4c\u5ea6\u5730\u70b9\u304c\u5bfe\u8c61\u7bc4\u56f2\u306b\u542b\u307e\u308c\u307e\u305b\u3093\u3002",
             "\u8a31\u5bb9\u7bc4\u56f2\u306f\u7def\u5ea624\u201346\u00b0\u3001\u7d4c\u5ea6122\u2013146\u00b0\u3067\u3059\u3002"))
      # usethis::ui_stop(c("latitudes or longitudes out of bounds.", "acceptable latitude and longitude ranges are 24N-46N and 122E-146E."))
    }
  }


#' Preview elements and time ranges covered by AMGSDS source dataset
#'
#' @param source type of source: daily, hourly, geo, or scenario
#' @param internal_use set TRUE for internal data check functions
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom lubridate ymd
#' @importFrom lubridate ymd_h
#' @export
preview_dataset <-
  function(source = "daily", internal_use = FALSE){
    if(source == "daily"){
      availability_table <-
        tibble::tribble(
          ~ element, ~ unit,    ~ from,            ~ to,              ~ clim_from,       ~ description,
          "TMP_mea", "\u00b0C", ymd("1980-01-01", tz = "Asia/Tokyo"), ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("2011-01-01", tz = "Asia/Tokyo"), "\u65e5\u5e73\u5747\u6c17\u6e29",
          "TMP_max", "\u00b0C", ymd("1980-01-01", tz = "Asia/Tokyo"), ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("2011-01-01", tz = "Asia/Tokyo"), "\u65e5\u6700\u9ad8\u6c17\u6e29",
          "TMP_min", "\u00b0C", ymd("1980-01-01", tz = "Asia/Tokyo"), ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("2011-01-01", tz = "Asia/Tokyo"), "\u65e5\u6700\u4f4e\u6c17\u6e29",
          "APCP",    "mm d-1",  ymd("1980-01-01", tz = "Asia/Tokyo"), ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("2011-01-01", tz = "Asia/Tokyo"), "\u964d\u6c34\u91cf",
          "APCPRA",  "mm d-1",  ymd("2008-01-01", tz = "Asia/Tokyo"), ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("2011-01-01", tz = "Asia/Tokyo"), "\u964d\u6c34\u91cf",
          "OPR",     "-",       ymd("1980-01-01", tz = "Asia/Tokyo"), ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("2011-01-01", tz = "Asia/Tokyo"), "1 mm\u4ee5\u4e0a\u306e\u964d\u6c34\u306e\u6709\u7121",
          "SSD",     "h",       ymd("1980-01-01", tz = "Asia/Tokyo"), ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("2011-01-01", tz = "Asia/Tokyo"), "\u65e5\u7167\u6642\u9593",
          "GSR",     "MJ m-2",  ymd("1980-01-01", tz = "Asia/Tokyo"), ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("2011-01-01", tz = "Asia/Tokyo"), "\u5168\u5929\u65e5\u5c04\u91cf",
          "DLR",     "MJ m-2",  ymd("2008-01-01", tz = "Asia/Tokyo"), ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u4e0b\u5411\u304d\u9577\u6ce2\u653e\u5c04\u91cf",
          "RH",      "%",       ymd("2008-01-01", tz = "Asia/Tokyo"), ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u65e5\u5e73\u5747\u76f8\u5bfe\u6e7f\u5ea6",
          "WIND",    "m s-1",   ymd("1980-01-01", tz = "Asia/Tokyo"), ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u65e5\u5e73\u5747\u98a8\u901f",
          "SD",      "cm",      ymd("1980-10-01", tz = "Asia/Tokyo"), ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u7a4d\u96ea\u6df1",
          "SWE",     "mm",      ymd("1980-10-01", tz = "Asia/Tokyo"), ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u7a4d\u96ea\u76f8\u5f53\u6c34\u91cf",
          "SFW",     "mm d-1",  ymd("1980-10-01", tz = "Asia/Tokyo"), ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u65e5\u964d\u96ea\u76f8\u5f53\u6c34\u91cf",
          "PTMP",    "-",       lubridate::today(tz = "Asia/Tokyo"),  ymd("2025-12-31", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u4e88\u5831\u6c17\u6e29\u306e\u78ba\u304b\u3089\u3057\u3055")
    } else if(source == "hourly"){
      availability_table <-
        tibble::tribble(
          ~ element, ~ unit,    ~ from,                 ~ to,                                                         ~ clim_from,       ~ description,
          "TMP",     "\u00b0C", ymd_h("1991-01-01 01", tz = "Asia/Tokyo"), ymd_h(paste(lubridate::today(tz = "Asia/Tokyo") + lubridate::days(10), "00")), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u6c17\u6e29",
          "RH",      "%",       ymd_h("2008-01-01 01", tz = "Asia/Tokyo"), ymd_h(paste(lubridate::today(tz = "Asia/Tokyo") + lubridate::days(10), "00")), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u76f8\u5bfe\u6e7f\u5ea6",
          "DLR",      "MJ m-2",       ymd_h("2008-01-01 01", tz = "Asia/Tokyo"), ymd_h(paste(lubridate::today(tz = "Asia/Tokyo") + lubridate::days(10), "00")), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u4e0b\u5411\u304d\u9577\u6ce2\u653e\u5c04\u91cf",
          "APCPRA",      "mm",       ymd_h("2022-01-01 01", tz = "Asia/Tokyo"), ymd_h(paste(lubridate::today(tz = "Asia/Tokyo") + lubridate::days(10), "00")), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u964d\u6c34\u91cf",
          "PREC",      "mm",       ymd_h("2022-01-01 01", tz = "Asia/Tokyo"), ymd_h(paste(lubridate::today(tz = "Asia/Tokyo") + lubridate::days(10), "00")), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u964d\u6c34\u91cf"
          )
    } else if(source == "geo"){
      availability_table <-
        tibble::tribble(
          ~ element,         ~ unit,    ~ from,            ~ to,              ~ description,
          "altitude",        "\u00b0C", ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u5e73\u5747\u6a19\u9ad8",
          "area",            "%",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u9762\u7a4d",
          "landuse_H210100", "%",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u7530",
          "landuse_H210200", "%",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u305d\u306e\u4ed6\u306e\u8fb2\u7528\u5730",
          "landuse_H210500", "%",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u68ee\u6797",
          "landuse_H210600", "%",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u8352\u5730",
          "landuse_H210700", "%",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u5efa\u7269\u7528\u5730",
          "landuse_H210901", "%",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u9053\u8def",
          "landuse_H210902", "%",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u9244\u9053",
          "landuse_H211000", "%",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u305d\u306e\u4ed6\u306e\u7528\u5730",
          "landuse_H211100", "%",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u6cb3\u5ddd\u5730\u304a\u3088\u3073\u6e56\u6cbc",
          "landuse_H211400", "%",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u6d77\u6d5c",
          "landuse_H211500", "%",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u6d77\u6c34\u57df",
          "landuse_H211600", "%",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u30b4\u30eb\u30d5\u5834",
          "pref_all60",      "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u5168\u56fd\u4e00\u62ec\u90fd\u9053\u5e9c\u770c\u7bc4\u56f2\u56f3",

          "pref_0100",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053",
          "pref_0101",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053\u77f3\u72e9\u632f\u8208\u5c40",
          "pref_0102",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053\u6e21\u5cf6\u7dcf\u5408\u632f\u8208\u5c40",
          "pref_0103",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053\u6a9c\u5c71\u632f\u8208\u5c40",
          "pref_0104",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053\u5f8c\u5fd7\u7dcf\u5408\u632f\u8208\u5c40",
          "pref_0105",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053\u7a7a\u77e5\u7dcf\u5408\u632f\u8208\u5c40",
          "pref_0106",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053\u4e0a\u5ddd\u7dcf\u5408\u632f\u8208\u5c40",
          "pref_0107",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053\u7559\u840c\u632f\u8208\u5c40",
          "pref_0108",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053\u5b97\u8c37\u7dcf\u5408\u632f\u8208\u5c40",
          "pref_0109",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053\u30aa\u30db\u30fc\u30c4\u30af\u7dcf\u5408\u632f\u8208\u5c40",
          "pref_0110",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053\u80c6\u632f\u7dcf\u5408\u632f\u8208\u5c40",
          "pref_0111",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053\u65e5\u9ad8\u632f\u8208\u5c40",
          "pref_0112",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053\u5341\u52dd\u7dcf\u5408\u632f\u8208\u5c40",
          "pref_0113",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053\u91e7\u8def\u7dcf\u5408\u632f\u8208\u5c40",
          "pref_0114",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5317\u6d77\u9053\u6839\u5ba4\u632f\u8208\u5c40",
          "pref_0200",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u9752\u68ee\u770c",
          "pref_0300",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5ca9\u624b\u770c",
          "pref_0400",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5bae\u57ce\u770c",
          "pref_0500",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u79cb\u7530\u770c",
          "pref_0600",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5c71\u5f62\u770c",
          "pref_0700",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u798f\u5cf6\u770c",
          "pref_0800",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u8328\u57ce\u770c",
          "pref_0900",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u6803\u6728\u770c",
          "pref_1000",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u7fa4\u99ac\u770c",
          "pref_1100",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u57fc\u7389\u770c",
          "pref_1200",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5343\u8449\u770c",
          "pref_1300",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u6771\u4eac\u90fd",
          "pref_1400",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u795e\u5948\u5ddd\u770c",
          "pref_1500",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u65b0\u6f5f\u770c",
          "pref_1600",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5bcc\u5c71\u770c",
          "pref_1700",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u77f3\u5ddd\u770c",
          "pref_1800",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u798f\u4e95\u770c",
          "pref_1900",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5c71\u68a8\u770c",
          "pref_2000",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u9577\u91ce\u770c",
          "pref_2100",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5c90\u961c\u770c",
          "pref_2200",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u9759\u5ca1\u770c",
          "pref_2300",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u611b\u77e5\u770c",
          "pref_2400",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u4e09\u91cd\u770c",
          "pref_2500",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u6ecb\u8cc0\u770c",
          "pref_2600",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u4eac\u90fd\u5e9c",
          "pref_2700",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5927\u962a\u5e9c",
          "pref_2800",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5175\u5eab\u770c",
          "pref_2900",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5948\u826f\u770c",
          "pref_3000",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u548c\u6b4c\u5c71\u770c",
          "pref_3100",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u9ce5\u53d6\u770c",
          "pref_3200",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5cf6\u6839\u770c",
          "pref_3300",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5ca1\u5c71\u770c",
          "pref_3400",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5e83\u5cf6\u770c",
          "pref_3500",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5c71\u53e3\u770c",
          "pref_3600",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5fb3\u5cf6\u770c",
          "pref_3700",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u9999\u5ddd\u770c",
          "pref_3800",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u611b\u5a9b\u770c",
          "pref_3900",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u9ad8\u77e5\u770c",
          "pref_4000",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u798f\u5ca1\u770c",
          "pref_4100",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u4f50\u8cc0\u770c",
          "pref_4200",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u9577\u5d0e\u770c",
          "pref_4300",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u718a\u672c\u770c",
          "pref_4400",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5927\u5206\u770c",
          "pref_4500",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u5bae\u5d0e\u770c",
          "pref_4600",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u9e7f\u5150\u5cf6\u770c",
          "pref_4700",       "-",       ymd("0001-01-01", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u90fd\u9053\u5e9c\u770c\u5225\u7bc4\u56f2\u56f3 \u6c96\u7e04\u770c") %>%
          dplyr::mutate(clim_from = .data$from)
    } else if(source == "scenario"){
      availability_table <-
        tibble::tribble(
          ~ element, ~ unit,    ~ from,            ~ to,              ~ clim_from, ~ description,
          "TMP_mea", "\u00b0C", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u65e5\u5e73\u5747\u6c17\u6e29",
          "TMP_max", "\u00b0C", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u65e5\u6700\u9ad8\u6c17\u6e29",
          "TMP_min", "\u00b0C", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u65e5\u6700\u4f4e\u6c17\u6e29",
          "APCP",    "mm d-1",  ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u964d\u6c34\u91cf",
          "GSR",     "MJ m-2",  ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u5168\u5929\u65e5\u5c04\u91cf",
          "RH",      "%",       ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u65e5\u5e73\u5747\u76f8\u5bfe\u6e7f\u5ea6",
          "WIND",    "m s-1",   ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"), ymd("9999-12-31", tz = "Asia/Tokyo"), "\u65e5\u5e73\u5747\u98a8\u901f")
    } else {
      stop('`source`\u306b\u306f "daily" \u3001 "hourly" \u3001 "geo" \u3001 "scenario" \u306e\u3044\u305a\u308c\u304b\u3092\u6307\u5b9a\u3057\u3066\u304f\u3060\u3055\u3044\u3002')
      # usethis::ui_stop('argument `source` must be either "daily", "hourly", "scenario", or "geo".')
    }

    if(internal_use){
      return(availability_table)
    } else {
      availability_table %>%
        dplyr::mutate(clim_from = lubridate::year(.data$clim_from),
                      clim_from = dplyr::if_else(.data$clim_from == 9999, NA_real_, .data$clim_from),
                      clim_to = dplyr::if_else(is.na(.data$clim_from), NA_real_, lubridate::year(.data$to)),
                      .before = 6) %>%
        dplyr::rename(climatological_from = .data$clim_from, climatological_to = .data$clim_to) %>%
        return()
    }
  }

#' Confirm data availability
#'
#' @param .source source
#' @param .element element
#' @param .times time range
#' @param .clim is climatological
#' @importFrom rlang .data
#' @return stop if either elements or times are not supported by the source data
#'
check_source_availability <-
  function(.source, .element, .times, .clim){


    availability_table <-
      preview_dataset(.source, internal_use = TRUE)

    check_element <-
      dplyr::filter(availability_table, .data$element %in% .element)

    if(.clim){
      check_timerange <-
        dplyr::filter(check_element, min(.times) >= .data$clim_from, max(.times) <= .data$to)
    } else {
      check_timerange <-
        dplyr::filter(check_element, min(.times) >= .data$from, max(.times) <= .data$to)
    }

    if(NROW(check_element) < length(.element)){
      print(availability_table)
      stop("\u6307\u5b9a\u3055\u308c\u305f\u8981\u7d20\u306f\u30c7\u30fc\u30bf\u30bb\u30c3\u30c8\u306b\u542b\u307e\u308c\u3066\u3044\u307e\u305b\u3093\u3002\u8868\u793a\u3055\u308c\u305f\u30c6\u30fc\u30d6\u30eb\u3067\u30c7\u30fc\u30bf\u30bb\u30c3\u30c8\u304c\u30b5\u30dd\u30fc\u30c8\u3059\u308b\u8981\u7d20\u30fb\u6642\u9593\u7bc4\u56f2\u3092\u78ba\u8a8d\u3057\u3066\u304f\u3060\u3055\u3044\u3002")
      # usethis::ui_stop("element is not covered.")
    }
    if(NROW(check_timerange) < length(.element)){
      print(availability_table)
      stop("\u6307\u5b9a\u3055\u308c\u305f\u6642\u9593\u7bc4\u56f2\u306f\u30c7\u30fc\u30bf\u30bb\u30c3\u30c8\u306b\u542b\u307e\u308c\u3066\u3044\u307e\u305b\u3093\u3002\u8868\u793a\u3055\u308c\u305f\u30c6\u30fc\u30d6\u30eb\u3067\u30c7\u30fc\u30bf\u30bb\u30c3\u30c8\u304c\u30b5\u30dd\u30fc\u30c8\u3059\u308b\u8981\u7d20\u30fb\u6642\u9593\u7bc4\u56f2\u3092\u78ba\u8a8d\u3057\u3066\u304f\u3060\u3055\u3044\u3002")
      # usethis::ui_stop("time is not covered.")
    }
  }


#' Confirm scenario availability
#'
#' @param .times time range
#' @param .element element
#' @param .model model
#' @param .RCP RCP
#' @importFrom rlang .data
#' @return stop if either elements, model, or RCP is not supported by the scenario
#'
check_scenario_availability <-
  function(.times, .element, .model, .RCP){

    availability_table <-
      tibble::tribble(
        ~ model,     ~ RCP,        ~ element, ~ from,            ~ to,
        "MRI-CGCM3", "historical", "TMP_mea", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "historical", "TMP_max", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "historical", "TMP_min", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "historical", "APCP",    ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "historical", "GSR",     ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "historical", "RH",      ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "historical", "WIND",    ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "RCP2.6",     "TMP_mea", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "RCP2.6",     "TMP_max", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "RCP2.6",     "TMP_min", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "RCP2.6",     "APCP",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "RCP2.6",     "GSR",     ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "RCP2.6",     "RH",      ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "RCP2.6",     "WIND",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "RCP8.5",     "TMP_mea", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "RCP8.5",     "TMP_max", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "RCP8.5",     "TMP_min", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "RCP8.5",     "APCP",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "RCP8.5",     "GSR",     ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "RCP8.5",     "RH",      ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MRI-CGCM3", "RCP8.5",     "WIND",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),

        "MIROC5", "historical", "TMP_mea", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "historical", "TMP_max", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "historical", "TMP_min", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "historical", "APCP",    ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "historical", "GSR",     ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "historical", "RH",      ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "historical", "WIND",    ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "RCP2.6",     "TMP_mea", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "RCP2.6",     "TMP_max", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "RCP2.6",     "TMP_min", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "RCP2.6",     "APCP",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "RCP2.6",     "GSR",     ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "RCP2.6",     "RH",      ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "RCP2.6",     "WIND",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "RCP8.5",     "TMP_mea", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "RCP8.5",     "TMP_max", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "RCP8.5",     "TMP_min", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "RCP8.5",     "APCP",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "RCP8.5",     "GSR",     ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "RCP8.5",     "RH",      ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "MIROC5", "RCP8.5",     "WIND",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),

        "CSIRO-Mk3-6-0", "historical", "TMP_mea", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "historical", "TMP_max", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "historical", "TMP_min", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "historical", "APCP",    ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "historical", "GSR",     ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "historical", "RH",      ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "historical", "WIND",    ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "RCP2.6",     "TMP_mea", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "RCP2.6",     "TMP_max", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "RCP2.6",     "TMP_min", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "RCP2.6",     "APCP",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "RCP2.6",     "GSR",     ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "RCP2.6",     "RH",      ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "RCP2.6",     "WIND",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "RCP8.5",     "TMP_mea", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "RCP8.5",     "TMP_max", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "RCP8.5",     "TMP_min", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "RCP8.5",     "APCP",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "RCP8.5",     "GSR",     ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "RCP8.5",     "RH",      ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "CSIRO-Mk3-6-0", "RCP8.5",     "WIND",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),

        "GFDL-CM3", "historical", "TMP_mea", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2004-12-31", tz = "Asia/Tokyo"),  # 2005 not available
        "GFDL-CM3", "historical", "TMP_max", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2004-12-31", tz = "Asia/Tokyo"),  # 2005 not available
        "GFDL-CM3", "historical", "TMP_min", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2004-12-31", tz = "Asia/Tokyo"),  # 2005 not available
        "GFDL-CM3", "historical", "APCP",    ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2004-12-31", tz = "Asia/Tokyo"),  # 2005 not available
        "GFDL-CM3", "historical", "GSR",     ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2004-12-31", tz = "Asia/Tokyo"),  # 2005 not available
        "GFDL-CM3", "historical", "RH",      ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2004-12-31", tz = "Asia/Tokyo"),  # 2005 not available
        "GFDL-CM3", "historical", "WIND",    ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2004-12-31", tz = "Asia/Tokyo"),  # 2005 not available
        "GFDL-CM3", "RCP2.6",     "TMP_mea", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "GFDL-CM3", "RCP2.6",     "TMP_max", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "GFDL-CM3", "RCP2.6",     "TMP_min", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "GFDL-CM3", "RCP2.6",     "APCP",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "GFDL-CM3", "RCP2.6",     "GSR",     ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "GFDL-CM3", "RCP2.6",     "RH",      ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "GFDL-CM3", "RCP2.6",     "WIND",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "GFDL-CM3", "RCP8.5",     "TMP_mea", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "GFDL-CM3", "RCP8.5",     "TMP_max", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "GFDL-CM3", "RCP8.5",     "TMP_min", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "GFDL-CM3", "RCP8.5",     "APCP",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "GFDL-CM3", "RCP8.5",     "GSR",     ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "GFDL-CM3", "RCP8.5",     "RH",      ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "GFDL-CM3", "RCP8.5",     "WIND",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),

        "HadGEM2-ES", "historical", "TMP_mea", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "HadGEM2-ES", "historical", "TMP_max", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "HadGEM2-ES", "historical", "TMP_min", ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "HadGEM2-ES", "historical", "APCP",    ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "HadGEM2-ES", "historical", "GSR",     ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "HadGEM2-ES", "historical", "RH",      ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "HadGEM2-ES", "historical", "WIND",    ymd("1981-01-01", tz = "Asia/Tokyo"), ymd("2005-12-31", tz = "Asia/Tokyo"),
        "HadGEM2-ES", "RCP2.6",     "TMP_mea", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "HadGEM2-ES", "RCP2.6",     "TMP_max", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "HadGEM2-ES", "RCP2.6",     "TMP_min", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "HadGEM2-ES", "RCP2.6",     "APCP",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2099-12-31", tz = "Asia/Tokyo"), # 2100 not available
        "HadGEM2-ES", "RCP2.6",     "GSR",     ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2098-12-31", tz = "Asia/Tokyo"), # 2099, 2100 not available
        "HadGEM2-ES", "RCP2.6",     "RH",      ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2099-12-31", tz = "Asia/Tokyo"), # 2100 not available
        "HadGEM2-ES", "RCP2.6",     "WIND",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2100-12-31", tz = "Asia/Tokyo"),
        "HadGEM2-ES", "RCP8.5",     "TMP_mea", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2099-12-31", tz = "Asia/Tokyo"), # 2100 not available
        "HadGEM2-ES", "RCP8.5",     "TMP_max", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2099-12-31", tz = "Asia/Tokyo"), # 2100 not available
        "HadGEM2-ES", "RCP8.5",     "TMP_min", ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2099-12-31", tz = "Asia/Tokyo"), # 2100 not available
        "HadGEM2-ES", "RCP8.5",     "APCP",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2099-12-31", tz = "Asia/Tokyo"), # 2100 not available
        "HadGEM2-ES", "RCP8.5",     "GSR",     ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2099-12-31", tz = "Asia/Tokyo"), # 2100 not available
        "HadGEM2-ES", "RCP8.5",     "RH",      ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2099-12-31", tz = "Asia/Tokyo"), # 2100 not available
        "HadGEM2-ES", "RCP8.5",     "WIND",    ymd("2006-01-01", tz = "Asia/Tokyo"), ymd("2099-12-31", tz = "Asia/Tokyo")  # 2100 not available
      )

    check_element <-
      dplyr::filter(availability_table,
                    .data$element %in% .element,
                    .data$model == .model,
                    .data$RCP == .RCP)

    check_timerange <-
      dplyr::filter(check_element, min(.times) > .data$from, max(.times) < .data$to)

    if(NROW(check_element) < length(.element)){
      print(availability_table)
      stop("\u6307\u5b9a\u3055\u308c\u305f\u8981\u7d20\u306f\u30c7\u30fc\u30bf\u30bb\u30c3\u30c8\u306b\u542b\u307e\u308c\u3066\u3044\u307e\u305b\u3093\u3002")
      # usethis::ui_stop("element is not covered.")
    }
    if(NROW(check_timerange) < length(.element)){
      print(availability_table)
      stop("\u6307\u5b9a\u3055\u308c\u305f\u6642\u9593\u7bc4\u56f2\u306f\u30c7\u30fc\u30bf\u30bb\u30c3\u30c8\u306b\u542b\u307e\u308c\u3066\u3044\u307e\u305b\u3093\u3002")
      # usethis::ui_stop("time is not covered.")
    }
  }


#' (lat, lon) -> covering mesh code
#'
#' Convert lat/lon to Japanese mesh code that covers the site
#'
#' @param lats latitudes
#' @param lons longitudes
#' @param simple (internal use)
#' @return mesh code
#'
#' @export
point2code <-
  function(lats, lons, simple = TRUE){
    check_latlon_range(lats, lons)

    if(length(lats) != length(lons)){
      stop("\u4e0e\u3048\u3089\u308c\u305f\u7def\u5ea6 (lons) \u3068\u7d4c\u5ea6 (lats) \u306e\u9577\u3055\u304c\u7570\u306a\u308a\u307e\u3059\u3002")
    }

    lat1 <- lats * 60
    chr12 <- `%/%`(lat1, 40)
    lat2 <- `%%`(lat1, 40)
    chr5 <- `%/%`(lat2, 5)
    chr7 <- `%%`(lat2, 5) %>% `*`(60) %>% `%/%`(30)
    lon1 <- (lons - 100)
    chr34 <- `%/%`(lon1, 1)
    lon2 <- `%%`(lon1, 1) %>% `*`(60)
    chr6 <- `%/%`(lon2, 7.5)
    chr8 <- `%%`(lon2, 7.5) %>% `*`(60) %>% `%/%`(45)


    code <- paste0(chr12, chr34, chr5, chr6, chr7, chr8)

    if(simple){
      return(code)
    } else {
      return(list(primary = substring(code, 1, 4),
                  lat_index = paste0(substring(code, 5, 5), substring(code, 7, 7)),
                  lon_index = paste0(substring(code, 6, 6), substring(code, 8, 8))))
    }
  }



#' (lat range, lon range) -> covered mesh codes
#'
#' Convert a lat/lon bbox to Japanese mesh codes that covered by the bbox
#'
#' @param lats latitudes
#' @param lons longitudes
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#'
#' @export
area2code <-
  function(lats, lons){
    check_latlon_range(lats, lons)
    code_left_bottom <- point2code(min(lats), min(lons))
    code_right_upper <- point2code(max(lats), max(lons))

    lb <- code2point(code_left_bottom)
    ru <- code2point(code_right_upper)

    lat_full <- seq(lb$lat, ru$lat, by = 2/3)
    lon_full <- seq(lb$lon, ru$lon, by = 1)

    expand.grid(lat = lat_full, lon = lon_full) %>%
      dplyr::mutate(code = point2code(.data$lat, .data$lon)) %>%
      dplyr::pull(.data$code)
  }



#' mesh code -> (lat, lon)
#'
#' Convert Japanese mesh code to lat/lon of the center of the mesh
#'
#' @param code mesh code(s)
#' @return lat/lon of mesh center(s)
#'
#' @export
code2point <-
  function(code){
    if(any(nchar(code) != 8)){
        stop("`code` must be 8 chrs.")
    }

    lat_south <- as.numeric(substring(code, 1, 2)) * 2/3
    lon_west <- as.numeric(substring(code, 3, 4)) + 100

    lat_12 <- as.numeric(substring(code, 1, 2)) * 2 / 3
    lat_5 <- as.numeric(substring(code, 5, 5)) * 2 / 3 / 8
    lat_7 <- as.numeric(substring(code, 7, 7)) * 2 / 3 / 8 / 10
    lon_34 <- as.numeric(substring(code, 3, 4)) + 100
    lon_6 <- as.numeric(substring(code, 6, 6)) / 8
    lon_8 <- as.numeric(substring(code, 8, 8)) / 8 / 10

    list(lat = (lat_12 + lat_5 + lat_7 + 15 / 3600),
         lon = (lon_34 + lon_6 + lon_8 + 22.5 / 3600))
  }
