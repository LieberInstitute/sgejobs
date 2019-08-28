## Choose a script name
job_name <- paste0('resubmit_array_test_', Sys.Date())


run_test <- function(restore) {
    ## Delete it in case it exists
    unlink(file.path(tempdir(), paste0(job_name, '.sh')))

    ## Create an array job on the temporary directory
    with_wd(tempdir(), {
        ## Create an array job script to use for this example
        job_single(
            name = job_name,
            create_shell = TRUE,
            task_num = 100
        )

        original <- readLines(paste0(job_name, '.sh'))

        ## Now we can re-submit the SGE job for a set of task IDs
        resubmit_array(
            job_bash = paste0(job_name, '.sh'),
            task_ids = '225019-225038:1,225040,225043',
            submit = !restore,
            restore = restore
        )

        final <- readLines(paste0(job_name, '.sh'))
        NULL
    })

    return(list('original' = original, 'final' = final))
}

test1 <- run_test(restore = TRUE)
test2 <- run_test(restore = FALSE)
t_line <- which(grepl('#\\$ -t ', test2$original))

test_that('resubmitt_array', {
    expect_equal(test1$original, test1$final)
    expect_equal(test2$original[-t_line], test2$final[-t_line])
    expect_equal(test2$final[t_line], '#$ -t 225043-225043')
})
