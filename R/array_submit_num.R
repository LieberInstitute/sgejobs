#' Submit an array job for a given number of tasks
#'
#' SGE limits the number of tasks an array job can have when you submit it. At
#' JHPCE that limit is 75000, which means that if you want to submit an array
#' job for 75001 tasks, you first need to submit the job for task IDs 1 till
#' 75000, and then for 75001 by itself. This function simplifies that process
#' for you.
#'
#' @inheritParams array_submit
#' @param array_num An `integer(1)` number of tasks to submit for the given
#' job. The function will deal with the case where `array_num` is greater
#' than `array_max`.
#' @param array_max A maximum number of task per SGE array job. At JHPCE, that
#' is 75000.
#'
#' @return `array_submit_num`: Uses [array_submit()] to submit an array job for
#' a given number of tasks as determined by [task_ids_num()].
#' @export
#' @author Leonardo Collado-Torres
#'
#' @examples
#'
#' ## Choose a script name
#' job_name <- paste0("array_submit_num_example_", Sys.Date())
#'
#' ## Create an array job on the temporary directory
#' with_wd(tempdir(), {
#'     ## Create an array job script to use for this example
#'     job_single(
#'         name = job_name,
#'         create_shell = TRUE,
#'         task_num = 1
#'     )
#'
#'     ## Now we can submit the SGE job for a given number of tasks
#'     array_submit_num(
#'         job_bash = paste0(job_name, ".sh"),
#'         array_num = 75001,
#'         submit = FALSE
#'     )
#' })
#'
array_submit_num <- function(
        job_bash, array_num, submit = file.exists("/cm/shared/apps/sge/sge-8.1.9/default/common/accounting_20191007_0300.txt"),
        restore = TRUE, array_max = 75000L) {
    ## Get the sequence of task ids
    task_ids <- task_ids_num(array_num = array_num, array_max = array_max)
    array_submit(
        job_bash = job_bash, task_ids = task_ids, submit = submit,
        restore = restore
    )
}

#' @inheritParams array_submit_num
#' @rdname array_submit_num
#' @export
#' @return `task_ids_num`: A character vector of SGE task IDs compliant with
#' `array_max`.
#'
#'
#' @examples
#'
#' ## Get the list of task IDs for a different set of task numbers
#' task_ids_num(1)
#' task_ids_num(75000)
#' task_ids_num(75001)
#' task_ids_num(150001)
#'
task_ids_num <- function(array_num, array_max = 75000L) {
    ## Check input
    if (array_num < 1) {
        stop("'array_num' should be at least 1.", call. = FALSE)
    }

    if (is.numeric(array_num)) array_num <- as.integer(array_num)
    if (!all(is.integer(array_num))) {
        stop("'array_num' should be a integer of length 1.", call. = FALSE)
    }

    ## Define starts and ends of the sequence
    starts <- seq(1, array_num, by = array_max)
    ends <- seq(min(array_max, array_num), array_num, by = array_max)

    ## Make sure they are the same length.
    if (length(ends) < length(starts)) ends <- c(ends, array_num)
    task_ids <- paste0(starts, "-", ends)
    task_ids
}
