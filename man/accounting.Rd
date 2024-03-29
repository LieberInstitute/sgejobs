% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/accounting.R
\name{accounting}
\alias{accounting}
\alias{accounting_read}
\alias{accounting_parse}
\title{Extract and parse the SGE job accounting information}
\usage{
accounting(
  job_ids,
  accounting_files = "/cm/shared/apps/sge/sge-8.1.9/default/common/accounting",
  tz = "EST"
)

accounting_read(
  job_ids,
  accounting_files = "/cm/shared/apps/sge/sge-8.1.9/default/common/accounting"
)

accounting_parse(accounting_info, tz = "EST")
}
\arguments{
\item{job_ids}{A \code{character} vector of SGE job IDs to inspect.}

\item{accounting_files}{A \code{character} vector with the paths to the SGE
accounting files.}

\item{tz}{Time zone for your SGE cluster. Defaults to \code{EST} for JHPCE.}

\item{accounting_info}{A named list where each element contains the output
from \code{qacct} for a given job and the names of the list are the SGE job IDs.
This can be produced using \code{\link[=accounting_read]{accounting_read()}}.}
}
\value{
\code{accounting_read}: A list with the output from \code{qacct} by SGE for
each of the SGE job IDs.

\code{accounting_parse} and \code{accounting}: a \code{data.frame} with the SGE
accounting information parsed.
}
\description{
For a given set of SGE job IDs, these functions extract the data from SGE
using \code{qacct} and then parse it to produce a data.frame with the summary
information recorded by SGE on the performance of these SGE jobs.
}
\examples{

## Requires JHPCE to run
accounting_file <- "/cm/shared/apps/sge/sge-8.1.9/default/common/accounting_20191007_0300.txt"
if (file.exists(accounting_file)) {
    head(
        accounting(
            c("92500", "77672"),
            accounting_file
        )
    )
}
## Example for a single job
acc_info <- list("92500" = readLines(
    system.file("extdata", "accounting", "92500.txt",
        package = "sgejobs"
    )
))
acc_info

## Requires JHPCE access
accounting_file <- "/cm/shared/apps/sge/sge-8.1.9/default/common/accounting_20191007_0300.txt"
if (file.exists(accounting_file)) {
    acc_info_jhpce <- accounting_read("92500", accounting_file)
    identical(acc_info_jhpce, acc_info)
}

## The example file has been subset to just the first two tasks
acc_info_array <- list("77672" = readLines(
    system.file("extdata", "accounting", "77672.txt",
        package = "sgejobs"
    )
))

## Requires JHPCE access
#' ## Example for an array job
if (file.exists(accounting_file)) {
    acc_info_jhpce_array <- accounting_read("77672", accounting_file)
}

## Requires JHPCE access
accounting_file <- "/cm/shared/apps/sge/sge-8.1.9/default/common/accounting_20191007_0300.txt"
if (file.exists(accounting_file)) {
    accounting_info_jhpce <- accounting_read(
        c("92500", "77672"),
        accounting_file
    )
}

## Here we use the data included in the package to avoid depending on JHPCE
## where the data for job 77672 has been subset for the first two tasks.
accounting_info <- list(
    "92500" = readLines(system.file("extdata", "accounting", "92500.txt",
        package = "sgejobs"
    )),
    "77672" = readLines(system.file("extdata", "accounting", "77672.txt",
        package = "sgejobs"
    ))
)

## Here we parse the data from `qacct` into a data.frame
res <- accounting_parse(accounting_info)
res

## Check the maximum memory use
as.numeric(res$maxvmem)

## And the absolute maximum
pryr:::show_bytes(max(res$maxvmem))
}
\references{
\subsection{For the ss function used by accounting_parse():}{

Leonardo Collado-Torres, Andrew E. Jaffe and Emily E. Burke (2019). jaffelab:
Commonly used functions by the Jaffe lab. R package version 0.99.27.
https://github.com/LieberInstitute/jaffelab
}
}
\author{
Leonardo Collado-Torres
}
