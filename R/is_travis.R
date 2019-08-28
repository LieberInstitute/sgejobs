#' Check if on Travis CI
#'
#' Simple check for Travis CI for examples
#'
#' @return Logical if user is named travis
#' @export
#'
#' @references
#' John Muschelli (2019). gcite: Google Citation Parser.
#' R package version 0.10.1. <https://CRAN.R-project.org/package=gcite>
#' @examples
#'
#' is_travis()
#'
is_travis <- function () {
    ## Taken from gcite::is_travis
    users <- Sys.getenv("USER")
    users <- trimws(users)
    any(grepl("travis", users))
}
