
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sgejobs

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Codecov test
coverage](https://codecov.io/gh/LieberInstitute/sgejobs/branch/devel/graph/badge.svg)](https://codecov.io/gh/LieberInstitute/sgejobs?branch=devel)
[![R build
status](https://github.com/LieberInstitute/sgejobs/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/LieberInstitute/sgejobs/actions)
[![GitHub
issues](https://img.shields.io/github/issues/LieberInstitute/sgejobs)](https://github.com/LieberInstitute/sgejobs/issues)
[![GitHub
pulls](https://img.shields.io/github/issues-pr/LieberInstitute/sgejobs)](https://github.com/LieberInstitute/sgejobs/pulls)<!-- badges: end -->

This package contains helper functions for [Son of Grid
Engine](https://arc.liv.ac.uk/trac/SGE) (SGE) cluster jobs, mostly with
usage at the Joint High Performance Computing Exchange
([JHPCE](https://jhpce.jhu.edu/)) cluster in mind. Please check the
package [documentation
website](http://LieberInstitute.github.io/sgejobs) for more information
about how to use `sgejobs`.

## Installation instructions

Get the latest stable `R` release from
[CRAN](http://cran.r-project.org/). Then install `sgejobs` from
[GitHub](https://github.com/LieberInstitute/sgejobs) with:

``` r
BiocManager::install("LieberInstitute/sgejobs")
```

## Citation

Below is the citation output from using `citation('sgejobs')` in R.
Please run this yourself to check for any updates on how to cite
**sgejobs**.

``` r
print(citation("sgejobs"), bibtex = TRUE)
#> To cite package 'sgejobs' in publications use:
#> 
#>   Collado-Torres L (2023). _sgejobs: Helper functions for SGE jobs at
#>   JHPCE_. R package version 0.99.2,
#>   <https://github.com/LieberInstitute/sgejobs>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {sgejobs: Helper functions for SGE jobs at JHPCE},
#>     author = {Leonardo Collado-Torres},
#>     year = {2023},
#>     note = {R package version 0.99.2},
#>     url = {https://github.com/LieberInstitute/sgejobs},
#>   }
```

Please note that the `sgejobs` was only made possible thanks to many
other R and bioinformatics software authors, which are cited either in
the vignettes and/or the paper(s) describing this package.

## Code of Conduct

Please note that the `sgejobs` project is released with a [Contributor
Code of Conduct](http://bioconductor.org/about/code-of-conduct/). By
contributing to this project, you agree to abide by its terms.

## Development tools

- Continuous code testing is possible thanks to [GitHub
  actions](https://www.tidyverse.org/blog/2020/04/usethis-1-6-0/)
  through *[usethis](https://CRAN.R-project.org/package=usethis)*,
  *[remotes](https://CRAN.R-project.org/package=remotes)*, and
  *[rcmdcheck](https://CRAN.R-project.org/package=rcmdcheck)* customized
  to use [Bioconductor’s docker
  containers](https://www.bioconductor.org/help/docker/) and
  *[BiocCheck](https://bioconductor.org/packages/3.17/BiocCheck)*.
- Code coverage assessment is possible thanks to
  [codecov](https://codecov.io/gh) and
  *[covr](https://CRAN.R-project.org/package=covr)*.
- The [documentation website](http://LieberInstitute.github.io/sgejobs)
  is automatically updated thanks to
  *[pkgdown](https://CRAN.R-project.org/package=pkgdown)*.
- The code is styled automatically thanks to
  *[styler](https://CRAN.R-project.org/package=styler)*.
- The documentation is formatted thanks to
  *[devtools](https://CRAN.R-project.org/package=devtools)* and
  *[roxygen2](https://CRAN.R-project.org/package=roxygen2)*.

For more details, check the `dev` directory.

This package was developed using
*[biocthis](https://bioconductor.org/packages/3.17/biocthis)*.
