context('accounting')

## Can't really test these functions on Travis since it depends on `qacct`
test_that('accouting_read', {
    expect_error(accounting_read('92500'), 'error in running command')
    expect_error(accounting('92500'), 'error in running command')
})

accounting_info <- list(
    '92500' = readLines(system.file('extdata', 'accounting', '92500.txt',
        package = 'sgejobs')),
    '77672' = readLines(system.file('extdata', 'accounting', '77672.txt',
        package = 'sgejobs'))
)
res <- accounting_parse(accounting_info)

test_that('accounting_parse', {
    expect_equal(res$input_id, c(77672.1, 77672.2, 92500))
    expect_equal(res$exit_status, c(0, 0, 0))
    expect_equal(res$taskid, c(1, 2, 'undefined'))
    expect_true(all(res$end_time > res$start_time))
    expect_equal(
        as.integer(res$end_time - res$start_time),
        as.integer(gsub('s', '', res$ru_wallclock))
    )
    expect_equal(res$jobnumber, c(77672, 77672, 92500))
})
