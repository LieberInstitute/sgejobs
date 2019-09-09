context('log functions')

bsp2_log <- system.file('inst', 'logs', 'delete_bsp2.txt', package = 'sgejobs')
twas_gene_HIPPO <- system.file('inst', 'logs',
    'compute_weights_full_HIPPO_gene.1.txt', package = 'sgejobs')


nas <- as.POSIXlt(c(start = NA, end = NA), tz = 'EST')
names(nas) <- c('start', 'end')

test_that('log_date', {
    expect_error(log_date(paste0(bsp2_log, 'hello')), 'does not exist')
    expect_error(log_date(bsp2_log, date_lines = 1), 'length 2')
    expect_equal(log_date(bsp2_log, date_lines = c('hello', 'bye')), nas)
    expect_equal(date(log_date(bsp2_log))[1], as.Date('2019-09-07'))
    expect_equal(date(log_date(twas_gene_HIPPO))[1], as.Date('2019-08-12'))
})


test_that('log_jobid', {
    expect_error(log_jobid(paste0(bsp2_log, 'hello')), 'does not exist')
    expect_error(log_jobid(bsp2_log, jobid_header = c('a', 'b')), 'length 1')
    expect_equal(log_jobid(bsp2_log), '92500')
    expect_equal(log_jobid(twas_gene_HIPPO), '7751602')
})
