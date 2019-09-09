#' From a SGE log file, find the SGE start and end times
#'
#' This function searches a log file, such as those created with [job_single()],
#' for the start and end dates for the SGE job. This information can then be
#' used to find the `qacct` file to retrieve information about the job at hand.
#'
#' Only the first occurrenses of the start and end time line identifiers
#' defined by `date_lines` will be retrieved.
#'
#' @param log_file The path to a SGE log file.
#' @param tz Time zone for your SGE cluster. Defaults to `EST` for JHPCE.
#' @param date_lines A `character(2)` vector with the start and end text lines
#' used for detecting the start and end times of the job.
#'
#' @return A vector of length 2 with the start and end times
#' @import lubridate purrr
#' @export
#' @author Leonardo Collado-Torres
#' @seealso [log_jobid()]
#'
#' @examples
#'
#' ## Example log file
#' bsp2_log <- system.file('extdata', 'logs', 'delete_bsp2.txt', package = 'sgejobs')
#'
#' ## Find start/end dates
#' log_date(bsp2_log)
#'
#' ## Another example log file
#' twas_gene_HIPPO <- system.file('extdata', 'logs',
#'     'compute_weights_full_HIPPO_gene.1.txt', package = 'sgejobs')
#' log_date(twas_gene_HIPPO)
#'
log_date <- function(log_file, tz = 'EST', date_lines = c('Job starts', 'Job ends')) {
    if(!file.exists(log_file)) {
        stop("The 'log_file' ", log_file, ' does not exist.', call. = FALSE)
    }
    if(length(date_lines) != 2) {
        stop("'date_lines' should be a character vector of length 2, with the text used to identify the start and end of the job.", call. = FALSE)
    }
    log <- readLines(log_file)

    dates <- purrr::map(date_lines,
        ~ lubridate::parse_date_time(
            ## Keep only the first match
            log[grep(.x, log)[1] + 1], orders = 'a b! d! h!:M!:S! Y!', tz = tz
        )
    )
    has_date <- purrr::map_lgl(dates, ~ length(.x) > 0)
    dates[!has_date] <- NA

    result <- do.call(c, dates)
    names(result) <- c('start', 'end')
    return(result)

}
