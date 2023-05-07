## Choose a script name
job_name <- paste0("array_submit_num_test_", Sys.Date())


run_test <- function(restore, array_num) {
    ## Delete it in case it exists
    unlink(file.path(tempdir(), paste0(job_name, ".sh")))

    ## Create an array job on the temporary directory
    with_wd(tempdir(), {
        ## Create an array job script to use for this example
        job_single(
            name = job_name,
            create_shell = TRUE,
            task_num = 1
        )

        original <- readLines(paste0(job_name, ".sh"))

        ## Now we can submit the SGE job for a set of task IDs
        array_submit_num(
            job_bash = paste0(job_name, ".sh"),
            array_num = array_num,
            submit = FALSE,
            restore = restore
        )

        final <- readLines(paste0(job_name, ".sh"))
        NULL
    })

    return(list("original" = original, "final" = final))
}

test1 <- run_test(restore = FALSE, array_num = 75000)
test2 <- run_test(restore = FALSE, array_num = 75001)
t_line <- which(grepl("#\\$ -t ", test2$original))


test_that("array_submit_num", {
    expect_equal(test1$final[t_line], "#$ -t 1-75000")
    expect_equal(test2$final[t_line], "#$ -t 75001-75001")
    expect_error(task_ids_num(0), "should be at least 1")
    expect_equal(task_ids_num(1.6), "1-1")
    expect_error(task_ids_num("a"), "integer of length 1")
    expect_equal(task_ids_num(75000), "1-75000")
    expect_equal(task_ids_num(75001), c("1-75000", "75001-75001"))
})
