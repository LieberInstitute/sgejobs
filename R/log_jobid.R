#' From a SGE log file, find the job id
#'
#' This function searches a log file, such as those created with [job_single()],
#' for SGE job identifier.
#'
#' @inheritParams log_date
#' @param jobid_header A `character(1)` vector with the line header that
#' specifies the SGE ID.
#'
#' @return A `character(1)` vector with the job id (first one found in the log
#' file).
#' @export
#' @seealso [log_date()]
#'
#' @examples
#'
#' ## Example log file
#' bsp2_log <- system.file('extdata', 'logs', 'delete_bsp2.txt', package = 'sgejobs')
#'
#' ## Find the job id
#' log_jobid(bsp2_log)
#'
#' ## Another example log file
#' twas_gene_HIPPO <- system.file('extdata', 'logs',
#'     'compute_weights_full_HIPPO_gene.1.txt', package = 'sgejobs')
#'
#' ## Id for the second example
#' log_jobid(twas_gene_HIPPO)
#'
log_jobid <- function(log_file, jobid_header = 'Job id:') {
    if(!file.exists(log_file)) {
        stop("The 'log_file' ", log_file, ' does not exist.', call. = FALSE)
    }
    if(length(jobid_header) != 1) {
        stop("'job_id_header' should be a character vector of length 1, with the text used to identify the SGE job id.", call. = FALSE)
    }
    log <- readLines(log_file)
    trimws(gsub(jobid_header, '', log[grep(jobid_header, log)[1]]))
}
