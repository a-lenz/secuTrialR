% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/labels_secuTrial.R
\name{labels_secuTrial}
\alias{labels_secuTrial}
\alias{label_secuTrial}
\alias{label}
\title{Get variable labels for secuTrialdata objects}
\usage{
labels_secuTrial(object, form = NULL)

label_secuTrial(object, ...)

label(x)
}
\arguments{
\item{object}{\code{secuTrialdata} object}

\item{form}{which form (string)}

\item{x}{any object}
}
\value{
\code{labels_secuTrial} returns a named vector
\code{label_secuTrial} returns the same object as \code{object}, but with labels added to variables and data.frames
\code{label} and \code{units} return strings with the appropriate labels
}
\description{
Variable labels are important for understanding the contents of a variable. \code{secuTrialR} offers two main methods to get those labels. \code{labels_secuTrial} returns a named list of labels. \code{label_secuTrial} adds labels and units to variables (and data.frames) which can then be queried via \code{label} or \code{units}.
}
\details{
For \code{labels_secuTrial}, regular expressions are used with \code{form} (specifically, it is inserted between \code{(} and \code{)$} to identify the form). Consequently, if \code{form} matches multiple forms (because the beginning is different), multiple forms may be returned. You could be more specific with the regular expression, remembering that it is inserted between \code{(} and \code{)$}.
}
\note{
The \code{label_secuTrial}/\code{label} syntax is similar to that used in Hmisc, with the advantage that it does not change data types (Hmisc coerces everything to labelled integer). Similar to Hmisc, however, most operations will remove the labels.
}
\examples{
# APPROACH 1: labels_secuTrial
# ex. 1
# prepare path to example export
export_location <- system.file("extdata", "s_export_CSV-xls_BMD.zip",
                               package = "secuTrialR")
# load all export data
sT_export <- read_secuTrial_export(data_dir = export_location)
# get all labels
labels <- labels_secuTrial(sT_export)
labels[["age"]]

# ex. 2
# load export
sT_export <- read_secuTrial_export(system.file("extdata",
                                               "s_export_CSV-xls_CTU05_longnames.zip",
                                               package = "secuTrialR"))

# get labels for sae, treatment and surgeries forms
labels <- labels_secuTrial(sT_export, form = c("sae", "treatment", "surgeries"))


# APPROACH 2: label_secuTrial
# load secuTrial export with separate reference table
sT_export <- read_secuTrial_export(system.file("extdata",
                                               "s_export_CSV-xls_CTU05_longnames_sep_ref.zip",
                                               package = "secuTrialR"))
# label the secuTrialdata object
sT_export_labelled <- label_secuTrial(sT_export)
# form label
label(sT_export_labelled$ctu05baseline)
# variable label
label(sT_export_labelled$ctu05baseline$visit_date)
# sampling units
units(sT_export_labelled$ctu05baseline$height)
}
