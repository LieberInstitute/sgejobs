
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sgejobs

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/LieberInstitute/sgejobs.svg?branch=master)](https://travis-ci.org/LieberInstitute/sgejobs)
[![Codecov test
coverage](https://codecov.io/gh/LieberInstitute/sgejobs/branch/master/graph/badge.svg)](https://codecov.io/gh/LieberInstitute/sgejobs?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

This package contains helper functions for [Son Grid
Engine](https://arc.liv.ac.uk/trac/SGE) (SGE) cluster jobs, mostly with
usage at the Joint High Performance Computing Exchange
([JHPCE](https://jhpce.jhu.edu/)) cluster in mind. Please check the
package [documentation
website](http://LieberInstitute.github.io/sgejobs) for more information
about how to use `sgejobs`.

# Installation instructions

Get the latest stable `R` release from
[CRAN](http://cran.r-project.org/). Then install `sgejobs` using the
following code:

``` r
## If needed:
if (!requireNamespace("remotes", quietly = TRUE))
   install.packages("remotes")

## Install with:
remotes::install_github('LieberInstitute/sgejobs')
```

# Citation

Below is the citation output from using `citation('sgejobs')` in R.
Please run this yourself to check for any updates on how to cite
**sgejobs**.

``` r
citation('sgejobs')
#> 
#> To cite package 'sgejobs' in publications use:
#> 
#>   Leonardo Collado-Torres (2019). sgejobs: Helper functions for
#>   SGE jobs at JHPCE. R package version 0.99.0.
#>   https://github.com/LieberInstitute/sgejobs
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {sgejobs: Helper functions for SGE jobs at JHPCE},
#>     author = {Leonardo Collado-Torres},
#>     year = {2019},
#>     note = {R package version 0.99.0},
#>     url = {https://github.com/LieberInstitute/sgejobs},
#>   }
```

# Testing

Testing on Bioc-devel is feasible thanks to [R
Travis](http://docs.travis-ci.com/user/languages/r/).
