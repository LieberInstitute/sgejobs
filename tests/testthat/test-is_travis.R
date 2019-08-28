test_that("are we on Travis?", {
    expect_equal(is_travis(), grepl('travis', Sys.getenv("USER")))
})
