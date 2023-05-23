# 初期設定周り

## 準備、自分の環境に合わせてお願いします。



# sfのインストールは[公式ページ](https://r-spatial.github.io/sf/)を参照。

install.packages("devtools") # if not installed
install.packages("sf") # shapeデータの利用のため
devtools::install_github("uribo/jpndistrict") # 国内の行政区画データの利用のため

# いまはtar.gzを適当なところにおいてインストールしてください。
install.packages("~/agrmesh_0.0.0.XXXX.tar.gz", repos = NULL, type = "source")

library(agrmesh)
# インストール後に、`library(agrmesh)`を実行し、パッケージを読み込みます。
# 初回読み込み時に環境設定ファイル (`.Renviron`) が開かれます。
# ユーザのR利用状況によっては既に数行分、`XXX=****`のような形式で設定が記入されている場合があります。
# 末尾に以下のようにIDとパスワードを追記し、保存したのちにRstudioを再起動してください。
#
# ```
# XXXX=****
# YYYY=****
# ZZZZ=****
# amgsds_id=YOURID
# amgsds_pw=YOURPW
# ```

# オフライン状態だとエラー
amgsds_config()
# Not connected to the internet.

# オンライン状態だと
amgsds_config()
# ✔ USERID and PASSWORD -> verified

# usethis::edit_r_environ()で
# amgsds_id = hoge　に変更して再起動してから、オンライン状態で実行すると.Renvironが開いて以下のメッセージ
library(agrmesh)
# ✖ Incorrect USERID and/or PASSWORD/
#   Use correct `amgsds_id` and `amgsds_pw`.
# • Modify '/Users/keach/.Renviron'
# • Restart R for changes to take effect
