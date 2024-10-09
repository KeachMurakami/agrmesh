nonempty_meshes <-
  stringr::str_glue("https://{Sys.getenv('amgsds_id')}:{Sys.getenv('amgsds_pw')}@amd.rd.naro.go.jp/opendap/AMD/1980/eAPCP/contents.html") %>%
  rvest::read_html() %>%
  rvest::html_nodes("a") %>%
  rvest::html_text() %>%
  stringr::str_subset("p....e") %>%
  stringr::str_extract("(p....e)") %>%
  readr::parse_number()

nonempty_meshes_fewer <-
  stringr::str_glue("https://{Sys.getenv('amgsds_id')}:{Sys.getenv('amgsds_pw')}@amd.rd.naro.go.jp/opendap/AMS/MIROC5/historical/2005/eAPCP/contents.html") %>%
  rvest::read_html() %>%
  rvest::html_nodes("a") %>%
  rvest::html_text() %>%
  stringr::str_subset("p....e") %>%
  stringr::str_extract("(p....e)") %>%
  readr::parse_number()

usethis::use_data(nonempty_meshes, overwrite = TRUE)
usethis::use_data(nonempty_meshes_fewer, overwrite = TRUE)
