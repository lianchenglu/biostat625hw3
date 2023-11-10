
# hw3cca

<!-- badges: start -->
[![R-CMD-check](https://github.com/lianchenglu/biostat625hw3/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/lianchenglu/biostat625hw3/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/lianchenglu/biostat625hw3/branch/main/graph/badge.svg)](https://app.codecov.io/gh/lianchenglu/biostat625hw3?branch=main)
<!-- badges: end -->

## Overview

The goal of hw3cca is to replicate some of the functionality of the existing R package. 
This is a simple method to calculate CCA. It is designed to calculate the CCA when the number of input X and Y columns is the same. The correlation generated is correct when the number of columns is different, but the number of rows or columns for the correlation coefficient will be different.

* `cca_simple()` calculate the simple Canonical Correlation.
* `cancor()` is R-build-in function to test whether the result is the same.
## Installation

You can install the development version of hw3cca from [GitHub](https://github.com/) with:

``` r
# You can install it with vignettes
# devtools::install_github("lianchenglu/biostat625hw3")
devtools::install_github('lianchenglu/biostat625hw3',build_vignettes =T)
```

## Usage

In general, there are 4 steps to perform CCA by R

1.  Load the raw data

2.  Scale original data

3.  Canonical correlation analysis `simple_cca` (or `cancor`)

4.  Correlation coefficient significance test

Here, I generate data randomly. The result of `cca_simple` and `cancor` is the same.  There are two canonical correlation coefficients. `xcoef` is coefficient for x variables so this is linear combination coefficients. `ycoef` is coefficient for y variables so this is linear combination coefficients.

``` r
library(hw3cca)
## basic example code
set.seed(123)
x1 <- matrix(rnorm(20000), 10000, 2)
y1 <- matrix(rnorm(20000), 10000, 2)
cca_simple(x1, y1)
#> $cor
#> [1] 0.026811015 0.007223339
#> 
#> $xcoef
#>               [,1]          [,2]
#> [1,] -0.0099710852 -0.0009297077
#> [2,] -0.0008671031  0.0099473100
#> 
#> $ycoef
#>              [,1]         [,2]
#> [1,] -0.007201230 -0.006935035
#> [2,]  0.006809384 -0.007337660
cancor(x1, y1)[1:3]
#> $cor
#> [1] 0.026811015 0.007223339
#> 
#> $xcoef
#>               [,1]          [,2]
#> [1,] -0.0099710852 -0.0009297077
#> [2,] -0.0008671031  0.0099473100
#> 
#> $ycoef
#>              [,1]         [,2]
#> [1,] -0.007201230 -0.006935035
#> [2,]  0.006809384 -0.007337660
```

Similarly, you can gernerate a bigger dataset.

``` r
x2 <- matrix(rnorm(2000000), 400000, 5)
y2 <- matrix(rnorm(2000000), 400000, 5)
cca_simple(x2, y2)[1]
#> $cor
#> [1] 0.0038819746 0.0026011925 0.0024372356 0.0012142998 0.0004935721
cancor(x2, y2)[1]
#> $cor
#> [1] 0.0038819746 0.0026011925 0.0024372356 0.0012142998 0.0004935721
``` 

## Test
Comparison against the original R functions on simulated datasets to demonstrate both the correctness.

``` r
library(testthat)
test_that("cca_simple function", {
  # Test to match benchmark results to test results
  library(testthat)
  test_that("cca_simple function", {
  expect_equal(cca_simple(x1, y1), cancor(x1, y1)[1:3], tolerance = 0.0001)
})
#> Test passed 🌈
```

The efficiency of the implemented functions.

``` r
bench::mark(
  cca_simple(x1, y1),
  cancor(x1,y1)[1:3],
  iterations = 10,
  check = TRUE
)
#> # A tibble: 2 × 6
#>   expression               min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>          <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 cca_simple(x1, y1)    1.98ms   2.05ms      487.   784.3KB        0
#> 2 cancor(x1, y1)[1:3] 968.55µs   1.19ms      762.    2.44MB        0
```
