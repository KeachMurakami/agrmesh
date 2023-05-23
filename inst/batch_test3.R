# オフライン作業用のローカル保存先のディレクトリを指定して初期化、フォルダ再作成。
# ローカル保存先を完全削除、関係ないところは消さないように。
# 安全のためエクスプローラで消してもOKです。

your_local <- "~/path/to/your/dir"
unlink(your_local, recursive = TRUE)
dir.create(your_local, recursive = TRUE)


library(tidyverse)
library(jpndistrict)
library(agrmesh)
library(lubridate)



# read_amgsds -------------------------------------------------------------



# autodownload = FALSEなのでエラー、こっちがデフォルト挙動
read_amgsds(today(), lats = 35, lons = 138, elements = "TMP_mea", source = "daily", localdir = your_local)

read_amgsds(today(), lats = 35, lons = 138, elements = "TMP_mea", source = "daily", localdir = your_local, autodownload = TRUE)
# ℹ TMP_meaのNetCDFファイルをOPeNDAPサーバからダウンロードします。
# # A tibble: 1 × 5
# time         lat   lon site_id TMP_mea
# <date>     <dbl> <dbl> <chr>     <dbl>
# 1 2023-02-28  35.0  138. 1          6.73

read_amgsds(today(), lats = 35, lons = 138, elements = "TMP_mea", source = "daily", localdir = your_local)
# ℹ ~/path/to/your/dir以下に保存されたTMP_meaデータを読み込みます。
# # A tibble: 1 × 5
# time         lat   lon site_id TMP_mea
# <date>     <dbl> <dbl> <chr>     <dbl>
# 1 2023-02-28  35.0  138. 1          6.73

# 同一の１次メッシュなら緯度経度がずれてもOK
read_amgsds(today(), lats = 34.9, lons = 138, elements = "TMP_mea", source = "daily", localdir = your_local)
# ℹ ~/path/to/your/dir以下に保存されたTMP_meaデータを読み込みます。
# # A tibble: 1 × 5
# time         lat   lon site_id TMP_mea
# <date>     <dbl> <dbl> <chr>     <dbl>
# 1 2023-02-28  34.9  138. 1          7.60

# 別の１次メッシュなのでエラー
read_amgsds(today(), lats = 34.3, lons = 138, elements = "TMP_mea", source = "daily", localdir = your_local)

# 不適切なローカルフォルダなのでエラー
read_amgsds(today(), lats = 35, lons = 138, elements = "TMP_mea", source = "daily", localdir = "~/some/wrong/directory")



read_amgsds(today(), lats = 35, lons = 138, elements = "area", source = "geo", localdir = your_local, autodownload = TRUE)
# ℹ areaのNetCDFファイルをOPeNDAPサーバからダウンロードします。
# # A tibble: 1 × 5
# time    lat   lon site_id     area
# <chr> <dbl> <dbl> <chr>      <dbl>
# 1 ----   35.0  138. 1       1055003.


read_amgsds(today() + years(50) + days(0:5), lats = 35, lons = 138, elements = "RH", source = "scenario", model = "MIROC5", RCP = "RCP2.6", localdir = your_local, autodownload = TRUE)
# ℹ RHのNetCDFファイルをOPeNDAPサーバからダウンロードします。
# # A tibble: 6 × 5
# time         lat   lon site_id    RH
# <date>     <dbl> <dbl> <chr>   <dbl>
# 1 2073-02-28  35.0  138. 1        49.0
# 2 2073-03-01  35.0  138. 1        62.0
# 3 2073-03-02  35.0  138. 1        50.0
# 4 2073-03-03  35.0  138. 1        71.9
# 5 2073-03-04  35.0  138. 1        88.0
# 6 2073-03-05  35.0  138. 1        54.1


read_amgsds(times = ymd_hm(c("2019-08-01 02:00", "2019-08-02 04:00"), tz = "Asia/Tokyo"), lats = c(34.5, 34.8), lons = c(138.1, 138.2), elements = "RH", mode = "area", source = "hourly", output = "tibble", localdir = your_local, autodownload = TRUE, .silent = FALSE)
# ℹ RHのNetCDFファイルをOPeNDAPサーバからダウンロードします。
# [100%] Downloaded 1117 bytes...
# [100%] Downloaded 1117 bytes...
# Downloaded 112164716 bytes...
# time                  lat   lon    RH
# <dttm>              <dbl> <dbl> <dbl>
# 1 2019-08-01 02:00:00  34.6  138.  96.8
# 2 2019-08-01 02:00:00  34.6  138.  96.8
# 3 2019-08-01 02:00:00  34.6  138.  97.3
# 4 2019-08-01 02:00:00  34.6  138.  96.9
# 5 2019-08-01 02:00:00  34.6  138.  96.5
# 6 2019-08-01 02:00:00  34.6  138.  96.4
# 7 2019-08-01 02:00:00  34.6  138.  96.5
# 8 2019-08-01 02:00:00  34.6  138.  97
# 9 2019-08-01 02:00:00  34.6  138.  96.9
# 10 2019-08-01 02:00:00  34.6  138.  96.8
# # … with 4,877 more rows
# # ℹ Use `print(n = ...)` to see more rows
# >


# １次メッシュが存在しない緯度経度範囲を含む広域データをarrayで取得できることを確認。
read_amgsds(lats = c(32, 35), lons = c(130, 140), elements = "area", source = "geo", output = "array", mode = "area", localdir = your_local, autodownload = TRUE)
# ℹ areaのNetCDFファイルをOPeNDAPサーバからダウンロードします。





# download netcdf ---------------------------------------------------------

# もう一回ローカルディレクトリを削除・作成
unlink(your_local, recursive = TRUE)
dir.create(your_local, recursive = TRUE)

path_nagasaki <- generate_path(times = today(), lats = c(30, 36), lons = c(125, 130), element = "GSR", source = "daily")[["complete"]]

download_netcdf(path_nagasaki, outdir = your_local, .silent = FALSE)
# [100%] Downloaded 1117 bytes...
# [100%] Downloaded 1117 bytes...
# [100%] Downloaded 1117 bytes...
# ....
# [100%] Downloaded 1117 bytes...
# [100%] Downloaded 1117 bytes...
# Downloaded 9348864 bytes...

nagasaki <- read_amgsds(times = today(), lats = c(32, 34), lons = c(126, 130), element = "GSR", source = "daily", output = "array", mode = "area", localdir = your_local)
# ℹ ~/path/to/your/dir以下に保存されたGSRデータを読み込みます。

nagasaki %>%
  unfold_array() %>%
  plot2d_leaflet(thin = 1)

nagasaki %>%
  unfold_array() %>%
  plot2d_shape(pref_code = 40:45)


path_kanto <- generate_path(times = today(), lats = c(31.8, 40.1), lons = c(133, 140), element = "pref_all60", source = "geo")[["complete"]]
download_netcdf(path_kanto, outdir = your_local, .silent = FALSE)
# [100%] Downloaded 1117 bytes...
# [100%] Downloaded 1117 bytes...
# [100%] Downloaded 1117 bytes...
# ....
# [100%] Downloaded 1117 bytes...
# [100%] Downloaded 1117 bytes...
# Downloaded 9348864 bytes...

kanto <- read_amgsds(times = today(), lats = c(31.8, 40.1), lons = c(138, 140), element = "pref_all60", source = "geo", output = "array", mode = "area", localdir = your_local)
# ℹ ~/path/to/your/dir以下に保存されたpref_all60データを読み込みます。

# ちょっとみづらいのでズームして、県境がずれていないことを確認
# thin = .5 で表示セルを50%に間引いているのでまばらでOK
kanto %>%
  unfold_array() %>%
  plot2d_leaflet(thin = .5)

# thin = .5 で表示セルを50%に間引いているのでまばらでOK
kanto %>%
  unfold_array() %>%
  plot2d_shape(pref_code = 5:20) +
  coord_sf(xlim = c(135, 142), ylim = c(34, 40))
