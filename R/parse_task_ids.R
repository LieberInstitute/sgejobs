#' Parse array task IDs
#'
#' This function takes either a character vector or a numeric one as input.
#' It can be used with the list of jobs that failed from `qstat` (like those
#' in `Eqw` status) to find which tasks IDs need to be re-submitted for a
#' given array job.
#'
#' @param task_ids Either a character vector taken from the `qstat` output
#' or with a numeric input.
#'
#' @return A character vector with SGE-ready task ids to submit using
#' [array_submit].
#' @author Leonardo Collado-Torres
#' @export
#'
#' @examples
#'
#' ## This is an example true output from "qstat | grep Eqw"
#' ## 7770638 0.50105 compute_we lcollado     Eqw   08/16/2019 14:57:25                                    1 225001-225007:1,225009-225017:2,225019-225038:1,225040,225043,225047,225049
#' ## parse_task_ids() can then take as input the list of task ids that failed
#' parse_task_ids('225001-225007:1,225009-225017:2,225019-225038:1,225040,225043,225047,225049')
#'
#' ## Or it could be split across two, though the result will be identical
#' parse_task_ids(c('225001-225007:1,225009-225017:2', '225019-225038:1,225040,225043,225047,225049'))
#'
#' ## While this works
#' parse_task_ids(1:10)
#'
#' ## it's better for SGE if you specify the range
#' parse_task_ids('1-10')
#'
parse_task_ids <- function(task_ids) {
    if(is.integer(task_ids) || is.numeric(task_ids)) {
        result <- parse_task_ids_builder(as.character(task_ids))
    } else {
        result <- unlist(purrr::map(strsplit(task_ids, ','), parse_task_ids_builder))
    }
    return(result)
}

#' @param task_ids_char A character vector of task IDs that is not SGE-ready
#' yet.
#' @rdname parse_task_ids
#' @export
#' @examples
#'
#' ## Adds the dash (-) to specify a start and end for the array job
#' ## for those elements that are missing it
#' parse_task_ids_builder(c('1', '2-10:2'))
parse_task_ids_builder <- function(task_ids_char) {
    ## Find those that are not already in SGE-ready format
    idx <- !grepl('-', task_ids_char)
    if(any(idx)) {
        ## Make them into a format that tc will accept
        task_ids_char[idx] <- paste0(task_ids_char[idx], '-', task_ids_char[idx])
    }
    return(task_ids_char)
}
