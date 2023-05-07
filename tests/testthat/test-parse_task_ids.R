test_that("parsing task ids", {
    expect_equal(
        parse_task_ids("225001-225007:1,225009-225017:2,225019-225038:1,225040,225043,225047,225049"),
        parse_task_ids(
            c(
                "225001-225007:1,225009-225017:2",
                "225019-225038:1,225040,225043,225047,225049"
            )
        )
    )
    expect_equal(
        parse_task_ids_builder(c("1", "2-10:2")),
        c("1-1", "2-10:2")
    )
    expect_equal(
        parse_task_ids(1:2),
        c("1-1", "2-2")
    )
})
