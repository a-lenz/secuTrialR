context("load export options testing")

# shorten table names
export_options_regular_short <- read_export_options(data_dir = system.file("extdata",
                                                                           "s_export_CSV-xls_BMD.zip",
                                                                           package = "secuTrialR"))
# long table names
export_options_regular_long <- read_export_options(data_dir = system.file("extdata",
                                                                          "s_export_CSV-xls_longnames_BMD.zip",
                                                                          package = "secuTrialR"))
# rectangular shorten table names
export_options_rect_short <- read_export_options(data_dir = system.file("extdata",
                                                                        "s_export_rt-CSV-xls_BMD.zip",
                                                                        package = "secuTrialR"))
# rectangular long table names
export_options_rect_long <- read_export_options(data_dir = system.file("extdata",
                                                                       "s_export_rt-CSV-xls_longnames_BMD.zip",
                                                                       package = "secuTrialR"))
# unzipped
bmd_unzipped <- read_export_options(data_dir = system.file("extdata",
                                                           "s_export_CSV-xls_BMD",
                                                           package = "secuTrialR"))

# test shortened table names
test_that("Shorten names identified.", {
  expect_true(bmd_unzipped$short_names)
  expect_true(export_options_regular_short$short_names)
  expect_false(export_options_regular_long$short_names)
  expect_true(export_options_rect_short$short_names)
  expect_false(export_options_rect_long$short_names)
})

# test zip
test_that("zip archive ending identified.", {
  expect_false(bmd_unzipped$is_zip)
  expect_true(export_options_regular_short$is_zip)
  expect_true(export_options_regular_long$is_zip)
  expect_true(export_options_rect_short$is_zip)
  expect_true(export_options_rect_long$is_zip)
})

# test rectangular identification
test_that("Rectangular/regular export identified.", {
  expect_true(export_options_rect_short$is_rectangular)
  expect_true(export_options_rect_long$is_rectangular)
  expect_false(export_options_regular_short$is_rectangular)
  expect_false(bmd_unzipped$is_rectangular)
  expect_false(export_options_regular_long$is_rectangular)
})

# test meta names
test_that("Meta names available.", {
  expect_equal(as.vector(unlist(export_options_regular_short$meta_names)), c("fs", "cn", "ctr", "is",
                                                                             "qs", "qac",  "vp", "vpfs",
                                                                             "atcn", "atcvp", "cts", "miv", "cl"))
  expect_equal(as.vector(unlist(export_options_regular_long$meta_names)), c("forms", "casenodes",
                                                                            "centres", "items",
                                                                            "questions", "queries",
                                                                            "visitplan", "visitplanforms",
                                                                            "atcasenodes", "atcasevisitplans",
                                                                            "comments", "miv", "cl"))
})

# prepare path to example export
export_location <- system.file("extdata", "s_export_CSV-xls_BMD.zip",
                               package = "secuTrialR")
# load all export data
sT_export <- read_secuTrial_export(data_dir = export_location)

# capture the print
captured_print <- capture.output(print(sT_export$export_options))

# test print.secutrialoptions
test_that("Print export options working.", {
  expect_equal(length(captured_print), 23)
  expect_equal(captured_print[1], "SecuTrial version: 5.3.4.6 ")
  expect_equal(captured_print[5], "Seperator: '\t'")
  expect_equal(captured_print[6], "14 files exported")
  expect_equal(captured_print[8], "Reference values not exported - factorize not possible")
})


sT_export2 <- read_secuTrial_export(data_dir = system.file("extdata",
                                                           "s_export_CSV-xls_CTU05_shortnames.zip",
                                                           package = "secuTrialR"))
# project version
test_that("Project version parsing", {
  expect_equal(sT_export$export_options$project.version, "25.02.2019 - 13:13:44 (CET)")
  expect_equal(export_options_regular_short$project.version, "25.02.2019 - 13:13:44 (CET)")
  expect_equal(export_options_regular_long$project.version, "25.02.2019 - 13:13:44 (CET)")
  expect_equal(sT_export2$export_options$project.version, "30.04.2019 - 13:40:52 (CEST)")
  expect_equal(bmd_unzipped$project.version, "25.02.2019 - 13:13:44 (CET)")
})
