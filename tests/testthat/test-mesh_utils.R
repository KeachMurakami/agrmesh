# check_latlon_range
test_that("check if given lat/lon are covered", {
  expect_no_error(check_latlon_range(43, 140))
  expect_no_error(check_latlon_range(35:40, 140))
  expect_no_error(check_latlon_range(43, 140:130))

  expect_error(check_latlon_range(-43, 140:130))
  expect_error(check_latlon_range(43, c(140, 173, 130)))
})


# preview_dataset
test_that("display dataset informations", {
  expect_error(preview_dataset("hoge", internal_use = TRUE))
  expect_error(preview_dataset("hoge", internal_use = FALSE))

  # 15 elements in daily
  expect_equal(NROW(preview_dataset("daily", internal_use = TRUE)), 15)
  # 2 elements in hourly (TMP, RH)
  expect_equal(NROW(preview_dataset("hourly", internal_use = TRUE)), 2)
  # 76 elements in geo
  expect_equal(NROW(preview_dataset("geo", internal_use = TRUE)), 76)
  # 7 elements in scenario
  expect_equal(NROW(preview_dataset("scenario", internal_use = TRUE)), 7)
})


# check_source_availability
test_that("check if requested data are supported", {

  # wrong source
  expect_error(check_source_availability("hoge", "TMP_mea", "2023-01-23", FALSE))

  # daily
  # wrong element
  expect_error(check_source_availability("daily", "TMP", "2022-01-05", .clim = FALSE))
  expect_error(check_source_availability("daily", c("TMP_mea", "TMP"), "2022-01-05", .clim = FALSE))
  # wrong time
  expect_error(check_source_availability("daily", "TMP_mea", "2122-01-05", .clim = FALSE))
  expect_error(check_source_availability("daily", "TMP_mea", "2022-01-40", .clim = FALSE))
  expect_error(check_source_availability("daily", "TMP_mea", "1990-01-05", .clim = TRUE))

  # hourly
  # wrong element
  expect_error(check_source_availability("hourly", "TMP_mea", "2022-01-05", .clim = FALSE))
  expect_error(check_source_availability("hourly", c("TMP", "APCP"), "2022-01-05", .clim = FALSE))
  # wrong time
  expect_error(check_source_availability("hourly", "RH", "1990-01-01 01", .clim = FALSE))
  expect_error(check_source_availability("hourly", "TMP", "2024-01-40", .clim = FALSE))
  expect_error(check_source_availability("hourly", c("TMP", "RH"), "1990-01-01 01", .clim = FALSE))

})


# point2code
test_that("conversion from site lat/lon to site mesh code", {
  expect_error(point2code(43:45, 141.4))
  expect_error(point2code(50, 140)) # out of bound
})

# area2code


# code2point


# find_location
