library(testthat)
test_that("cca_simple function", {
  # Create a multivariable data set
  set.seed(123)
  x <- matrix(rnorm(20000), 10000, 2)
  y <- matrix(rnorm(20000), 10000, 2)

  # Using R's built-in cancor function to get the baseline results,
  # only the corrected correlations, x and y coefficients are obtained
  benchmark <- cancor(x, y)[1:3]
  # Get test results using the cca_simple to be tested
  result <- cca_simple(x, y)

  # Test to match benchmark results to test results
  expect_equal(result$cor, benchmark$cor, tolerance = 0.0001)
  expect_equal(result$xcoef, benchmark$xcoef, tolerance = 0.0001)
  expect_equal(result$ycoef, benchmark$ycoef, tolerance = 0.0001)

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

  x <- matrix(rnorm(2000000), 400000, 5)
  y <- matrix(rnorm(2000000), 400000, 5)

  # Using R's built-in cancor function to get the baseline results,
  # only the corrected correlations, x and y coefficients are obtained
  benchmark <- cancor(x, y)[1:3]
  # Get test results using the cca_simple to be tested
  result <- cca_simple(x, y)

  # Test to match benchmark results to test results
  expect_equal(result$cor, benchmark$cor, tolerance = 0.0001)
  expect_equal(abs(result$xcoef), abs(benchmark$xcoef), tolerance = 0.0001)
  expect_equal(abs(result$ycoef), abs(benchmark$ycoef), tolerance = 0.0001)

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
