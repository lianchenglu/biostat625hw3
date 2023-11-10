library(testthat)
test_that("cca_simple function", {
  # Create a multivariable data set
  set.seed(123)
  x <- matrix(rnorm(2000), 1000, 2)
  y <- matrix(rnorm(2000), 1000, 2)

  # Using R's built-in cancor function to get the baseline results,
  # only the corrected correlations, x and y coefficients are obtained
  benchmark <- cancor(x, y)[1:3]
  # Get test results using the cca_simple to be tested
  result <- cca_simple(x, y)

  # Test to match benchmark results to test results
  expect_equal(result$cor, benchmark$cor, tolerance = 0.0001)
  expect_equal(result$xcoef, benchmark$xcoef, tolerance = 0.0001)
  expect_equal(result$ycoef, benchmark$ycoef, tolerance = 0.0001)

  # Test for errors and exceptions, such as dimensions of x and y that do not match
  x_mismatched_dim = matrix(rnorm(500), ncol = 5)
  expect_error(cca_simple(x_mismatched_dim, y))

  # Test the case where x and y are empty matrices
  x_null = matrix(ncol=10)
  y_null = matrix(ncol=10)
  expect_error(cca_simple(x_null, y_null))

  # Time test the function using system time
  start.time <- Sys.time()
  result <- cca_simple(x, y)
  end.time <- Sys.time()
  cat('Time for cca_simple: ', end.time - start.time, '\n')

  # Time test R's built-in cancor function using system time
  start.time <- Sys.time()
  benchmark <- cancor(x, y)[1:3]
  end.time <- Sys.time()
  cat('Time for cancor: ', end.time - start.time, '\n')
})