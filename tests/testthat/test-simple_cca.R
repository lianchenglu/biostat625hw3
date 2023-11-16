library(testthat)
test_that('stop function',){
  x <- matrix(rnorm(20), 10, 2)
  y <- matrix(rnorm(200), 40, 5)
  expect_error(covarianceMatrix(x, y), "Number of rows of matrices must match!")
  expect_error(matrixMultiply(x, y), "Incompatible matrix dimensions")
}

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

  # Check if the result is a list
  expect_type(result, "list")

  # Check if the list contains specific elements
  expect_true("cor" %in% names(result))
  expect_true("xcoef" %in% names(result))
  expect_true("ycoef" %in% names(result))

  # Check the types of the elements
  expect_type(result$cor, "double")
  expect_type(result$xcoef, "double")
  expect_type(result$ycoef, "double")

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

# Test for unequal input rows
test_that("test for unequal input rows", {
  x <- matrix(rnorm(20), nrow = 10)
  y <- matrix(rnorm(30), nrow = 15)  # Different number of rows

  expect_equal(cca_simple(x, y), 'Unequal input row!')
})

# Test for 0 dimension in x or y
test_that("test for 0 dimension in x or y", {
  x <- matrix(NA, nrow = 10, ncol = 2)
  y <- matrix(rnorm(20), nrow = 10)

  expect_equal(cca_simple(x, y), '0 dimension in x or y')
})

test_that("cca_simple_cpp function", {
  # Create a multivariable data set
  set.seed(123)
  x <- matrix(rnorm(20000), 10000, 2)
  y <- matrix(rnorm(20000), 10000, 2)

  # Using R's built-in cancor function to get the baseline results,
  # only the corrected correlations, x and y coefficients are obtained
  benchmark <- cancor(x, y)[1:3]
  # Get test results using the cca_simple_cpp to be tested
  result <- cca_simple_cpp(x, y)

  # Check if the result is a list
  expect_type(result, "list")

  # Check if the list contains specific elements
  expect_true("cor" %in% names(result))
  expect_true("xcoef" %in% names(result))
  expect_true("ycoef" %in% names(result))

  # Check the types of the elements
  expect_type(result$cor, "double")
  expect_type(result$xcoef, "double")
  expect_type(result$ycoef, "double")

  # Test to match benchmark results to test results
  expect_equal(result$cor, benchmark$cor, tolerance = 0.0001)
  expect_equal(result$xcoef, benchmark$xcoef, tolerance = 0.0001)
  expect_equal(result$ycoef, benchmark$ycoef, tolerance = 0.0001)

  # Time test the function using system time
  start.time <- Sys.time()
  result <- cca_simple_cpp(x, y)
  end.time <- Sys.time()
  cat('Time for cca_simple_cpp: ', end.time - start.time, '\n')

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
  # Get test results using the cca_simple_cpp to be tested
  result <- cca_simple_cpp(x, y)

  # Test to match benchmark results to test results
  expect_equal(result$cor, benchmark$cor, tolerance = 0.0001)
  expect_equal(abs(result$xcoef), abs(benchmark$xcoef), tolerance = 0.0001)
  expect_equal(abs(result$ycoef), abs(benchmark$ycoef), tolerance = 0.0001)

  # Time test the function using system time
  start.time <- Sys.time()
  result <- cca_simple_cpp(x, y)
  end.time <- Sys.time()
  cat('Time for cca_simple_cpp: ', end.time - start.time, '\n')

  # Time test R's built-in cancor function using system time
  start.time <- Sys.time()
  benchmark <- cancor(x, y)[1:3]
  end.time <- Sys.time()
  cat('Time for cancor: ', end.time - start.time, '\n')
})

# Test for unequal input rows
test_that("test for unequal input rows", {
  x <- matrix(rnorm(20), nrow = 10)
  y <- matrix(rnorm(30), nrow = 15)  # Different number of rows

  expect_equal(cca_simple_cpp(x, y), 'Unequal input row!')
})

# Test for 0 dimension in x or y
test_that("test for 0 dimension in x or y", {
  x <- matrix(NA, nrow = 10, ncol = 2)
  y <- matrix(rnorm(20), nrow = 10)

  expect_equal(cca_simple_cpp(x, y), '0 dimension in x or y')
})
