# sgejobs 0.99.1

* Add the `accounting_files` parameter to the `accounting()` family of
functions now that archive files have been created at JHPCE for this type of
SGE job information.

# sgejobs 0.99.0

* Added a `NEWS.md` file to track changes to the package.
* Added the functions `parse_task_ids()` and `parse_task_ids_builder()` for
parsing SGE task IDs.
* Added the function `array_submit()` for submitting an SGE array job for
a given set of input task IDs.
* Added the function `job_single()` for creating a shell file for a new job
that can be submitted using `qsub`.
* Added the function `job_loop()` for creating a function that loops through
a bash variable(s) to create shell scripts that are then submitted to SGE using
`qsub`.
* Added the functions `log_date()` and `log_jobid()` to find the start/end
date from an SGE log file as well as the job id.
* Added the function `array_submit_num()` for submitting an array job given a
maximum task number. This function deals with the array task maximum imposed by
JHPCE of 75000 tasks per array job.
* Added the function `accounting()` with helper functions `accounting_read()`
and `accounting_parse()` which read and parse the `qacct` information from SGE
on a set of SGE job IDs and ultimately return a `data.frame` with the job
summary information.
