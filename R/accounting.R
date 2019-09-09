#' Extract and parse the SGE job accounting information
#'
#' For a given set of SGE job IDs, these functions extract the data from SGE
#' using `qacct` and then parse it to produce a data.frame with the summary
#' information recorded by SGE on the performance of these SGE jobs.
#'
#' @inheritParams accounting_read
#' @inheritParams accounting_parse
#'
#' @export
#'
#' @examples
#'
#' ## Requires JHPCE to run
#' if(!is.travis()) accounting(c('92500', '77672'))
#'
#'

accounting <- function(job_ids, tz = 'EST') {
    accounting_info <- accounting_read(job_ids = job_ids)
    accounting_parse(accounting_info, tz = tz)
}

#' @param job_ids A `character` vector of SGE job IDs to inspect.
#' @return `accounting_read`: A list with the output from `qacct` by SGE for
#' each of the SGE job IDs.
#' @export
#' @import purrr
#'
#' @rdname accounting
#' @examples
#'
#' ## Requires JHPCE access
#' if(!is_travis()) acc_info_jhpce <- accounting_read('92500')
#'
#' ## The above is identical
#' acc_info <- list('92500' = readLines(
#'     system.file('extdata', 'accounting', '92500.txt',
#'     package = 'sgejobs')))
#' acc_info
#'
#' if(!is.travis()) identical(acc_info_jhpce, acc_info)
#'
#'
#' ## Example for an array job
#' if(!is_travis()) acc_info_jhpce_array <- accounting_read('77672')
#'
#' ## The example file has been subset to just the first two tasks
#' acc_info_array <- list('77672' = readLines(
#'     system.file('extdata', 'accounting', '77672.txt',
#'     package = 'sgejobs')))
#'

accounting_read <- function(job_ids) {
    accounting_info <- purrr::map(
        job_ids,
        function(id) {
            message(paste(Sys.time(), 'reading job', id))
            x <- system(paste('qacct -j', id), intern = TRUE)
            if(length(x) == 0) return(NULL)
            return(x)
        }
    )
    names(accounting_info) <- job_ids
    return(accounting_info)
}


#' @param accounting_info A named list where each element contains the output
#' from `qacct` for a given job and the names of the list are the SGE job IDs.
#' This can be produced using [accounting_read()].
#' @inheritParams log_date
#'
#' @return `accounting_parse` and `accounting`: a `data.frame` with the SGE
#' accounting information parsed.
#' @export
#' @import tidyr lubridate purrr
#' @importFrom pryr bytes
#'
#' @rdname accounting
#' @examples
#'
#' ## Requires JHPCE access
#' if(!is_travis()) accounting_info_jhpce <- accounting_read(c('92500', '77672'))
#'
#' ## Here we use the data included in the package to avoid depending on JHPCE
#' ## where the data for job 77672 has been subset for the first two tasks.
#' accounting_info <- list(
#'     '92500' = readLines(system.file('extdata', 'accounting', '92500.txt',
#'         package = 'sgejobs')),
#'     '77672' = readLines(system.file('extdata', 'accounting', '77672.txt',
#'         package = 'sgejobs'))
#' )
#'
#' ## Here we parse the data from `qacct` into a data.frame
#' res <- accounting_parse(accounting_info)
#'
#' ## Check the maximum memory use
#' res$maxvmem
#'
#' ## And the absolute maximum
#' pryr:::show_bytes(max(res$maxvmem))
#'

accounting_parse <- function(accounting_info, tz = 'EST') {
    ids <- names(accounting_info)

    res <- purrr::map2_dfr(accounting_info, ids, function(x, i) {
        message(paste(Sys.time(), 'processing job', i))

        ## For jobs that have more than one task (array jobs)
        starts <- grep('=======', x)
        ends <- c(starts[-1]-1, length(x))

        split_info <- rep(
            seq_len(length(starts)),
            ends - starts + 1
        )
        x_list <- split(x, split_info)

        ## from jaffelab (to avoid that dependency tree)
        ss <- function(x, pattern, slot = 1) {
            sapply(strsplit(x = x, split = pattern), "[", slot)
        }

        res_int <- purrr::map(
            x_list,
            ~ data.frame(
                variable = ss(.x[-1], '[[:space:]]+', 1),
                value = purrr::map_chr(ss(.x[-1], '[[:space:]]+', -1), paste,
                    collapse = ' '),
                stringsAsFactors = FALSE
            )
        )

        ## Deal with job ids
        res_int <- purrr::map_dfr(res_int, function(x) {
            task <- x$value[x$variable == 'taskid']
            if(task != 'undefined') {
                x$input_id <- paste0(i, '.', task)
            } else {
                x$input_id <- as.character(i)
            }
            return(x)

        })
        return(res_int)
    })
    res2 <- tidyr::spread(res, variable, value)


    ## Deal with the time variables
    format_time <- function(x) {
        lubridate::parse_date_time(x, orders = 'a b! d! h!:M!:S! Y!', tz = tz)
    }
    res2$end_time <- format_time(res2$end_time)
    res2$qsub_time <- format_time(res2$qsub_time)
    res2$start_time <- format_time(res2$start_time)

    ## Deal with the memory variables
    format_mem <- function(mem) {
        power <- rep(0, length(mem))
        mem <- tolower(mem)
        power[grepl('tb', mem)] <- 4
        power[grepl('gb', mem)] <- 3
        power[grepl('mb', mem)] <- 2
        power[grepl('kb', mem)] <- 1
        mem_num <- as.numeric(gsub('[[:alpha:]]', '', mem))

        structure(mem_num * (1000^power), class = 'bytes')
    }
    res2$io <- format_mem(res2$io)
    res2$maxvmem <- format_mem(res2$maxvmem)
    message("Note: the column 'mem' was original in memory/second.")
    res2$mem <- format_mem(res2$mem)
    res2$ru_idrss <- format_mem(res2$ru_idrss)
    res2$ru_isrss <- format_mem(res2$ru_isrss)
    res2$ru_ismrss <- format_mem(res2$ru_ismrss)
    res2$ru_ixrss <- format_mem(res2$ru_ixrss)
    res2$ru_maxrss <- format_mem(res2$ru_maxrss)

    ## Guess the format again
    res2 <- readr::type_convert(res2)

    ## Done
    return(res2)
}

# https://github.com/hadley/pryr/blob/5b11749d9168cc1cf7840b0a921adc24efe790a9/R/mem.R
# print.bytes <- pryr:::print.bytes