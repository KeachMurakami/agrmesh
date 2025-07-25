% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fetch.R
\name{fetch_amgsds}
\alias{fetch_amgsds}
\title{Fetch data from AMGSDS server}
\usage{
fetch_amgsds(
  times = Sys.time(),
  lats,
  lons,
  elements,
  mode = "point",
  source = "daily",
  output = "tibble",
  model = "MIROC5",
  RCP = "RCP8.5",
  is_clim = FALSE,
  server = "amd.rd.naro.go.jp/opendap",
  .ver = "AMD",
  .silent = TRUE
)
}
\arguments{
\item{times}{time range to extract}

\item{lats}{latitude range to extract}

\item{lons}{longitude range to extract}

\item{elements}{names of element to extract}

\item{mode}{switch point/area/whole-mesh extraction}

\item{source}{data source}

\item{output}{format of output object}

\item{model}{climate simulation model for scenario data}

\item{RCP}{Representative Concentration Pathways for scenario data}

\item{is_clim}{logical. return climatological normals if \code{TRUE}}

\item{server}{URL for OPeNDAP server (experimental)}

\item{.ver}{AMD system version (experimental)}

\item{.silent}{logical. suppress download message if \code{TRUE}}
}
\description{
Fetch data from AMGSDS server
}
\examples{
\dontrun{
fetch_amgsds(times = c("2021-03-12", "2021-03-30"), lats = 43, lons = 143,
             elements = c("TMP_min", "TMP_max", "RH"))
fetch_amgsds(times = lubridate::today() + 1:5, lats = 35:36, lons = 139:140,
             elements = "APCP", mode = "area", output = "array")
fetch_amgsds(times = c("2023-08-03 10:30", "2023-08-05 19:30"), lats = 35, lons = 135,
             elements = "TMP", mode = "point", source = "hourly")
}

}
