# sgejobs 0.99.0

* Added a `NEWS.md` file to track changes to the package.
* Added the functions `parse_task_ids()` and `parse_task_ids_builder()` for
parsing SGE task IDs.
* Added the function `resubmit_array()` for re-submitting an SGE array job for
a given set of input task IDs.
* Added the function `job_single()` for creating a shell file for a new job
that can be submitted using `qsub`.
* Added the function `job_loop()` for creating a function that loops through
a bash variable(s) to create shell scripts that are then submitted to SGE using
`qsub`.
