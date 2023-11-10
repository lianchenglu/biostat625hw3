
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

### Example 1

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

### Example 2

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

`cor` are typical correlation coefficients between two sets of variables, which measure the degree of association between each pair of typical variables. The first coefficient, 0.76, indicates a high positive correlation between the first pair of typical variables. The subsequent coefficient decreases gradually, indicating that the degree of correlation decreases gradually.

`xcoef` Each column of this matrix represents a set of typical coefficients used to construct the portion of the first set of variables in each pair of typical variables. For example, the first column [-0.4668262, -0.2615724, 0.4112870, 0.0650801] represents the linear combination coefficients of the first set of variables in the first pair of typical variables.

`ycoef` Similarly, each column of this matrix represents another set of typical coefficients used to construct the portion of the second set of variables in each pair of typical variables. For example, the first column [0.05635204, -0.06564686, -0.05949765, 0.17942088] represents the linear combination coefficients of the second set of variables in the first pair of typical variables.

The canonical correlation coefficient shows the degree of maximum possible correlation between two sets of variables. The first pair of typical variables has the highest correlation, followed by the second, and so on. The canonical coefficients reveal the specific contributions of the original variables that make up each pair of canonical variables. A positive coefficient means a positive correlation between variables, and a negative coefficient means a negative correlation. These results can help to understand the pattern of association between the two sets of variables. For example, the first pair of typical variables captures the most significant association patterns, and subsequent pairs capture the remaining, relatively small association patterns.

The linear combination of the first canonical variables could be written as

$U=-0.467X_{1}-0.262X_{2}+0.411X_{3}+0.065X_{4}$

$V=0.056Y_{1}-0.066Y_{2}-0.059Y_{3}+0.179Y_{4}$

### Example 3

Here is another real-world data

```r
pop <- LifeCycleSavings[, 2:3]
oec <- LifeCycleSavings[, -(2:3)]
cancor(pop, oec)[1]
#> $cor
#> [1] 0.8247966 0.3652762
cca_simple(pop, oec)[1]
#> $cor
#> [1] 0.8247966 0.3652762
```

`pop` contains population-related data from the `LifeCycleSavings` dataset. `oec` is an economic indicator.

The high correlation coefficient (0.82) of the first pair of canonical variables means that there is a strong linear relationship between the variables in the `pop` group (population data) and the variables in the `oec` group (economic indicators).

By looking at the canonical coefficients, we can understand the specific variables that make up this relationship and the extent to which they contribute. A positive coefficient means a positive correlation between variables, and a negative coefficient means a negative correlation between variables.

The weak correlation of the second pair of canonical variables (0.37) suggests that in these particular linear combinations, the relationship between the two sets of variables is not as strong as the relationship in the first pair of canonical variables.

## Test
Comparison against the original R functions on simulated datasets to demonstrate both the correctness.

``` r
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
