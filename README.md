
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

Similarly, you can use the real-world dataset and find their correlation.

``` r
test_data <- hw3cca::data
test_data <- scale(test_data)
cca_simple(test_data[,1:4],test_data[,5:8])
cancor(test_data[,1:4],test_data[,5:8])[1:3]
#> $cor
#> [1] 0.7630518 0.4355692 0.3078966 0.1737088
#> 
#> $xcoef
#>          [,1]       [,2]        [,3]       [,4]
#> X1 -0.4668262  0.2154764 -0.34902573  0.1258576
#> X2 -0.2615724 -0.1252786 -0.06176509 -0.1893822
#> X3  0.4112870 -0.1923069  0.36057361  0.3507187
#> X4  0.0650801  0.1088261  0.21773128 -0.3388761
#> 
#> $ycoef
#>           [,1]        [,2]       [,3]        [,4]
#> Y1  0.05635204 -0.16392596 -0.1686144  0.03154977
#> Y2 -0.06564686 -0.02114819  0.1039148  0.21842781
#> Y3 -0.05949765 -0.27090910  0.1553569 -0.01063178
#> Y4  0.17942088 -0.14349242  0.1837260 -0.02334318
``` 

The linear combination of the first canonical variables could be written as

$U=-0.467X_{1}-0.262X_{2}+0.411X_{3}+0.065X_{4}$

$V=0.056Y_{1}-0.066Y_{2}-0.059Y_{3}+0.179Y_{4}$


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
