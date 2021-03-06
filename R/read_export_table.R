# Load an individual file/table from a secuTrial export archive
#
# @description
# This function can load individual tables from a secuTrial data
# export. If id translations for data tables shall be performed, the casenodes/cn,
# centres/ctr and visitplan/vp meta tables need to be loaded with this function first.
# Also export options need to be generated with read_export_options beforehand.
#
# This is an internal function which is wrapped by read_secuTrial_export
#
# @param data_dir string The data_dir specifies the path to the secuTrial data export.
# @param file_name string The file_name specifies which file to load.
# @param export_options list This can be generated with read_export_options.
# @param add_pat_id boolean If TRUE this will add the pat_id to the table.
# @param add_centre boolean If TRUE this will add the centre name to the table.
# @param add_visitname boolean If TRUE this will add visit names to the table.
# @param casenodes_table data.frame This data.frame must be created with this function
#                      before any secuTrial data tables are read.
#                      Is obsolete if is_meta_table == FALSE. (see examples)
# @param centre_table data.frame This data.frame must be created with this function
#                      before any other secuTrial data tables are read.
#                      Is obsolete if is_meta_table == FALSE. (see examples)
# @param visitplan_table data.frame This data.frame must be created with this function
#                      before any other secuTrial data tables are read.
#                      Is obsolete if is_meta_table == FALSE. (see examples)
# @param is_meta_table boolean If TRUE the table is treated as a meta data table (e.g. id translations are ignored).
#
# @return The function returns a data.frame for the data in file_name.
#
# @seealso read_export_options
#
# @examples
# \donttest{
# nolint start
# # load casenodes (casenodes/cn) table
# casenodes <- secuTrialR:::read_export_table(data_dir = system.file("extdata",
#                                                                  "s_export_CSV-xls_BMD.zip",
#                                                                  package = "secuTrialR"),
#                                           file_name = "cn.xls",
#                                           export_options = export_options,
#                                           is_meta_table = TRUE)
#
# # load centre (centres/ctr) table
# centre <- secuTrialR:::read_export_table(data_dir = system.file("extdata",
#                                                                 "s_export_CSV-xls_BMD.zip",
#                                                                 package = "secuTrialR"),
#                                          file_name = "ctr.xls",
#                                          export_options = export_options,
#                                          is_meta_table = TRUE)
#
# # load visitplan (visitplan/vp) table
# visitplan <- secuTrialR:::read_export_table(data_dir = system.file("extdata",
#                                                                    "s_export_CSV-xls_BMD.zip",
#                                                                    package = "secuTrialR"),
#                                             file_name = "vp.xls",
#                                             export_options = export_options,
#                                             is_meta_table = TRUE)
#
# # load bone mineral denisty form data
# bmd <- secuTrialR:::read_export_table(data_dir = system.file("extdata",
#                                                              "s_export_CSV-xls_BMD.zip",
#                                                              package = "secuTrialR"),
#                                       file_name = "bmd.xls",
#                                       export_options = export_options,
#                                       casenodes_table = casenodes,
#                                       centre_table = centre,
#                                       visitplan_table = visitplan)
# }
# nolint end
#
read_export_table <- function(data_dir, file_name, export_options,
                              add_pat_id = TRUE, add_centre = TRUE, add_visitname = TRUE,
                              casenodes_table, centre_table, visitplan_table,
                              is_meta_table = FALSE) {

  if (export_options$is_zip) {
    archive_con <- unz(data_dir, file_name)
    loaded_table <- read.table(file = archive_con,
                               header = TRUE,
                               na.strings = export_options$na.strings,
                               sep = export_options$sep,
                               fill = TRUE)
  } else if (export_options$is_zip == FALSE) {
    loaded_table <- read.table(file = paste0(data_dir, "/", file_name),
                               header = TRUE,
                               na.strings = export_options$na.strings,
                               sep = export_options$sep,
                               fill = TRUE)
  } else {
    stop(paste0("Could not load table ", file_name))
  }

  # in earlier secuTrial exports there was
  # a last/empty column "X" which can be removed
  if ("X" %in% names(loaded_table)) {
    loaded_table <- loaded_table[, -ncol(loaded_table)]
  }

  # do not manipulate meta tables
  if (is_meta_table) {
    return(loaded_table)
  }

  # adding pat_id
  if (add_pat_id & ("mnppid" %in% names(loaded_table))) {
    loaded_table <- add_pat_id_col(table = loaded_table,
                                   id = "pat_id",
                                   casenodes_table = casenodes_table)
  }

  # adding centres
  if (add_centre & "mnppid" %in% names(loaded_table))  {
    loaded_table <- add_centre_col(table = loaded_table, id = "centre",
                                   remove_ctag = FALSE, casenodes_table = casenodes_table,
                                   centre_table = centre_table)
  }

  # adding visit names
  if (add_visitname & "mnpvisid" %in% names(loaded_table))  {
    loaded_table <- add_visitname_col(table = loaded_table, id = "visit_name",
                                      visitplan_table = visitplan_table)
  }

  return(loaded_table)
}
