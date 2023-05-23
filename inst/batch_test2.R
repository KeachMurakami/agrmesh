# ctrl + Enterで１ライン実行を進めてください。

library(tidyverse)
library(jpndistrict)
library(agrmesh)
library(lubridate)

sites <-
  tibble(
    site = c("Tokyo Tower", "Tokyo Sta.", "Mt. Fuji"),
    lat = c(35.66, 35.68, 35.36),
    lon = c(139.75, 139.77, 138.72)
  )



# 点データ --------------------------------------------------------------------


# 日別データ取得まわり

fetch_amgsds(lats = sites$lat, lons = sites$lon, element = c("TMP_mea", "APCP"))
# # A tibble: 3 × 6
# time         lat   lon site_id TMP_mea  APCP
# <date>     <dbl> <dbl> <chr>     <dbl> <dbl>
# 1 2023-02-28  35.7  140. 1         11.8      0
# 2 2023-02-28  35.7  140. 2         11.8      0
# 3 2023-02-28  35.4  139. 3         -9.98     0

fetch_amgsds(times = "1999/08/30 03:40", lats = sites$lat, lons = sites$lon, element = "TMP_min", .silent = FALSE)
# [100%] Downloaded 1117 bytes...
# [100%] Downloaded 1117 bytes...
# [100%] Downloaded 1117 bytes...
# Downloaded 1268 bytes...# A tibble: 3 × 5
# time         lat   lon site_id TMP_min
# <date>     <dbl> <dbl> <chr>     <dbl>
# 1 1999-08-30  35.7  140. 1         24.4
# 2 1999-08-30  35.7  140. 2         24.5
# 3 1999-08-30  35.4  139. 3          6.10


# ソース不適切エラー
fetch_amgsds(lats = sites$lat, lons = sites$lon, source = "XXX", element = "TMP_mea")
# 日付曖昧エラー
fetch_amgsds(times = "20110101", lats = sites$lat, lons = sites$lon, element = "TMP_mea")
# 緯度範囲外エラー
fetch_amgsds(lats = c(25, 99, 30), lons = sites$lon, element = "TMP_mea")
# 時間範囲外エラー (気温確からしさは過去値なし)
fetch_amgsds(times = "1999/08/30 03:40", lats = sites$lat, lons = sites$lon, element = "PTMP")
# 時間範囲外エラー (1990年代は平年値なし)
fetch_amgsds(times = "1999/08/30 03:40", lats = sites$lat, lons = sites$lon, element = "APCP", is_clim = TRUE)
# 適合要素なしエラー
fetch_amgsds(lats = sites$lat, lons = sites$lon, element = "TMP___min")
# lat/lon長さ不一致エラー
fetch_amgsds(lats = sites$lat[1], lons = sites$lon[1:2], element = c("TMP_mea", "APCP"))
# 複数年跨ぎエラー
fetch_amgsds(times = today() + years(0:1), lats = sites$lat, lons = sites$lon, element = "TMP_mea")


# 時別データ取得まわり

fetch_amgsds(times = c("2023-01-30 13:30", "2023-01-31 22:30"), lats = sites$lat[1], lons = sites$lon[1], elements = "RH", source = "hourly")
# # A tibble: 34 × 5
# time                  lat   lon site_id    RH
# <dttm>              <dbl> <dbl> <chr>   <dbl>
# 1 2023-01-30 13:00:00  35.7  140. 1        49.1
# 2 2023-01-30 14:00:00  35.7  140. 1        51.3
# 3 2023-01-30 15:00:00  35.7  140. 1        43.4
# 4 2023-01-30 16:00:00  35.7  140. 1        36.5
# 5 2023-01-30 17:00:00  35.7  140. 1        38.1
# 6 2023-01-30 18:00:00  35.7  140. 1        46
# 7 2023-01-30 19:00:00  35.7  140. 1        40.6
# 8 2023-01-30 20:00:00  35.7  140. 1        41.7
# 9 2023-01-30 21:00:00  35.7  140. 1        41.1
# 10 2023-01-30 22:00:00  35.7  140. 1        42.7
# # … with 24 more rows
# # ℹ Use `print(n = ...)` to see more rows
fetch_amgsds(times = c("2023-01-30", "2023-01-31"), lats = sites$lat[1], lons = sites$lon[1], elements = "RH", source = "hourly", .silent = FALSE)
# [100%] Downloaded 1117 bytes...
# Downloaded 1380 bytes...# A tibble: 48 × 5
# time                  lat   lon site_id    RH
# <dttm>              <dbl> <dbl> <chr>   <dbl>
# 1 2023-01-30 01:00:00  35.7  140. 1        72.8
# 2 2023-01-30 02:00:00  35.7  140. 1        66.8
# 3 2023-01-30 03:00:00  35.7  140. 1        71.4
# 4 2023-01-30 04:00:00  35.7  140. 1        71.1
# 5 2023-01-30 05:00:00  35.7  140. 1        69.7
# 6 2023-01-30 06:00:00  35.7  140. 1        69.9
# 7 2023-01-30 07:00:00  35.7  140. 1        70.9
# 8 2023-01-30 08:00:00  35.7  140. 1        63.4
# 9 2023-01-30 09:00:00  35.7  140. 1        56.4
# 10 2023-01-30 10:00:00  35.7  140. 1        52.9
# # … with 38 more rows
# # ℹ Use `print(n = ...)` to see more rows

# YYYY-01-01 00:00はエラー (日界の問題)
fetch_amgsds(times = c("2023-01-01 0:00", "2023-01-01 05:00"), lats = sites$lat[1], lons = sites$lon[1], elements = "RH", source = "hourly")
# 時間範囲外エラー
fetch_amgsds(times = c("1995-01-30", "1995-01-31"), lats = sites$lat[1], lons = sites$lon[1], elements = "RH", source = "hourly")
# 適合要素なしエラー
fetch_amgsds(lats = sites$lat, lons = sites$lon, element = "TMP___min", source = "hourly")


# タイムゾーン周り ----------------------------------------------------------------

(time_jst <- ymd_hm("2021-10-20 05:00", tz = "Asia/Tokyo"))
# [1] "2021-10-20 05:00:00 JST"
(time_ambiguous <- "2021-10-20 05:00")
# [1] "2021-10-20 05:00"
(time_utc <- ymd_hm("2021-10-20 05:00", tz = "UTC"))
# [1] "2021-10-20 05:00:00 UTC"
(time_POSIXlt <- as.POSIXlt("2021-10-20 05:00", "GMT"))
# [1] "2021-10-20 05:00:00 GMT"

# 05:00のデータ
fetch_amgsds(times = time_jst, lats = 43, lons = 141.4, element = "TMP", source = "hourly")
fetch_amgsds(times = time_ambiguous, lats = 43, lons = 141.4, element = "TMP", source = "hourly")
# 14:00のデータ
fetch_amgsds(times = time_utc, lats = 43, lons = 141.4, element = "TMP", source = "hourly")
fetch_amgsds(times = time_POSIXlt, lats = 43, lons = 141.4, element = "TMP", source = "hourly")

# timezoneがUTCなど明示的に指定してある場合、JST時刻に変換されたデータをとってくる。
# times引数にtimezone不明瞭な文字列が来た場合には、JSTと想定して読み込む。
# 若干気持ちわるいが...






# 地理情報データ取得まわり

fetch_amgsds(lats = sites$lat, lons = sites$lon, elements = "altitude", source = "geo")
# # A tibble: 3 × 5
# time    lat   lon site_id altitude
# <chr> <dbl> <dbl> <chr>      <dbl>
# 1 ----   35.7  140. 1              4
# 2 ----   35.7  140. 2              3
# 3 ----   35.4  139. 3           3212
fetch_amgsds(lats = sites$lat, lons = sites$lon, elements = "pref_all60", source = "geo")
# # A tibble: 3 × 5
# time    lat   lon site_id pref_all60
# <chr> <dbl> <dbl> <chr>        <dbl>
# 1 ----   35.7  140. 1             1300
# 2 ----   35.7  140. 2             1300
# 3 ----   35.4  139. 3             2200

# 適合要素なしエラー
fetch_amgsds(lats = sites$lat, lons = sites$lon, element = "TMP___min", source = "geo")


# シナリオデータ取得まわり

fetch_amgsds(lats = sites$lat, lons = sites$lon, elements = "TMP_mea", source = "scenario", model = "MIROC5", RCP = "RCP2.6")
# # A tibble: 3 × 5
# time         lat   lon site_id TMP_mea
# <date>     <dbl> <dbl> <chr>     <dbl>
# 1 2023-02-28  35.7  140. 1          9.00
# 2 2023-02-28  35.7  140. 2          9.10
# 3 2023-02-28  35.4  139. 3         -9.30

# 時間範囲外エラー
fetch_amgsds(lats = sites$lat, lons = sites$lon, elements = "TMP_mea", source = "scenario", model = "MIROC5", RCP = "historical")








# 面データ --------------------------------------------------------------------

area_data <- fetch_amgsds(times = c("2023-01-10", "2023-01-11"), lats = 41:42, lons = 140:141, elements = "APCP", mode = "area", output = "array", .silent = FALSE)
# [100%] Downloaded 1117 bytes...
# [100%] Downloaded 1117 bytes...
# [100%] Downloaded 1117 bytes...
# [100%] Downloaded 1117 bytes...
# [100%] Downloaded 1117 bytes...
# [100%] Downloaded 1117 bytes...
# Downloaded 1100 bytes...
dim(area_data)
# > dim(area_data)
# [1]  81 121   2

# 経度範囲外エラー
fetch_amgsds(times = c("2023-01-10", "2023-01-11"), lats = 41:42, lons = 140:179, elements = "APCP", mode = "area", output = "array")
# 時間範囲外エラー
fetch_amgsds(times = c("2088-01-10", "2088-01-11"), lats = 41:42, lons = 140:141, elements = "APCP", mode = "area", output = "array")


fetch_amgsds(times = c("2088-01-10", "2088-01-11"), lats = 41:42, lons = 140:141, elements = "APCP", mode = "area", output = "array", source = "scenario", model = "MIROC5", RCP = "RCP8.5")
# 出力略

area_geo <- fetch_amgsds(times = c("2088-01-10", "2088-01-11"), lats = 41:42, lons = 140:141, elements = "pref_all60", mode = "area", output = "array", source = "geo")
dim(area_geo)
# > dim(area_geo)
# [1]  81 121 1


area_long_by_unfold <- area_geo %>% unfold_array
print(area_long_by_unfold)
# # A tibble: 4,854 × 4
# time    lat   lon pref_all60
# <chr> <dbl> <dbl>      <dbl>
# 1 ---    41.0  140.          0
# 2 ---    41.0  140.        200
# 3 ---    41.0  140.        200
# 4 ---    41.0  140.        200
# 5 ---    41.0  140.        200
# 6 ---    41.0  140.        200
# 7 ---    41.0  140.        200
# 8 ---    41.0  140.        200
# 9 ---    41.0  140.        200
# 10 ---    41.0  140.        200
# # … with 4,844 more rows
# # ℹ Use `print(n = ...)` to see more rows
# >

area_long_by_fetch <-
  fetch_amgsds(times = c("2088-01-10", "2088-01-11"), lats = 41:42, lons = 140:141, elements = "pref_all60", mode = "area", output = "tibble", source = "geo")
print(area_long_by_fetch)
# # A tibble: 4,854 × 4
# time    lat   lon pref_all60
# <chr> <dbl> <dbl>      <dbl>
# 1 ----   41.0  140.          0
# 2 ----   41.0  140.        200
# 3 ----   41.0  140.        200
# 4 ----   41.0  140.        200
# 5 ----   41.0  140.        200
# 6 ----   41.0  140.        200
# 7 ----   41.0  140.        200
# 8 ----   41.0  140.        200
# 9 ----   41.0  140.        200
# 10 ----   41.0  140.        200
# # … with 4,844 more rows
# # ℹ Use `print(n = ...)` to see more rows

table(arrange(area_long_by_fetch, lat, lon), arrange(area_long_by_unfold, lat, lon))
# TRUE

# すべてOK
area_long_by_unfold %>% plot2d_shape(pref_code = 1:2)
area_long_by_fetch %>% plot2d_shape(pref_code = 1:2)
area_long_by_unfold %>% plot2d_leaflet(thin = 1)
area_long_by_fetch %>% plot2d_leaflet(thin = 1)


# 複数要素の面データの扱い
area_multidata <- fetch_amgsds(times = c("2023-01-10", "2023-01-11"), lats = 34:35, lons = 135:136,
                               elements = c("TMP_mea", "SSD"), mode = "area", output = "array")
dim(area_multidata)
# NULL
dim(area_multidata[[1]])
# [1] 81 121 2


area_multidata %>% plot2d_shape(pref_code = 26:30) # 気温@2023-01-10
# Warning: 複数の要素のデータが存在します。`element_index`で指定された1番目の要素のみが表示されています。
# Warning: 複数の日付・時刻のデータが存在します。`time_index`で指定された1番目のデータのみが表示されています。

area_multidata %>% unfold_array %>% plot2d_shape(pref_code = 26:30) # 気温@2023-01-10、上と同一
# Warning: 複数の要素のデータが存在します。`element_index`で指定された1番目の要素のみが表示されています。
# Warning: 複数の日付・時刻のデータが存在します。`time_index`で指定された1番目のデータのみが表示されています。

area_multidata %>% unfold_array %>% plot2d_shape(pref_code = 26:30, time_index = 2) # 気温@2023-01-11
# Warning: 複数の要素のデータが存在します。`element_index`で指定された1番目の要素のみが表示されています。
# Warning: 複数の日付・時刻のデータが存在します。`time_index`で指定された2番目のデータのみが表示されています。

area_multidata %>% unfold_array %>% plot2d_shape(pref_code = 26:30, time_index = 2, element_index = 2) # 日照時間 (SSD)@2023-01-10
# Warning: 複数の要素のデータが存在します。`element_index`で指定された2番目の要素のみが表示されています。
# Warning: 複数の日付・時刻のデータが存在します。`time_index`で指定された2番目のデータのみが表示されています。
