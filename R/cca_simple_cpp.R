#' Simple Canonical Correlation Analysis via Rcpp
#'
#' This function conducts the simple Canonical Correlation Analysis (CCA) between two sets of variables.
#'
#' @param x is a matrix/dataframe where each column is a variable and each row is an observation.
#' @param y is another matrix/dataframe where each column is a variable and each row is an observation.
#'
#' @return A list containing:
#' \itemize{
#'   \item{"cor":}{The canonical correlation coefficients.}
#'   \item{"xcoef":}{The canonical vector of x standardized.}
#'   \item{"ycoef":}{The canonical vector of y standardized.}
#' }
#'
#' @examples
#' x <- matrix(rnorm(2000), 1000, 2)
#' y <- matrix(rnorm(2000), 1000, 2)
#' res <- cca_simple_cpp(x, y)
#' print(res)
#'
#' test_data <- hw3cca::data
#' test_data <- scale(test_data)
#' cca_simple_cpp(test_data[,1:4],test_data[,5:8])
#' cancor(test_data[,1:4],test_data[,5:8])[1:3]
#'
#' system.time(cca_simple_cpp(x,y)) # Time of my rcpp function
#' system.time(cancor(x,y)[1:3]) # Time of the R build-in cca function
#' @export

cca_simple_cpp <- function(x, y) {
  # check whether they have the same row
  if (nrow(x) != nrow(y)) {
    return('Unequal input row!')
  }

  # check dimension
  if (sum(is.na(x)) == nrow(x) * ncol(x) ||
      sum(is.na(y)) == nrow(y) * ncol(y)) {
    return('0 dimension in x or y')
  }

  # centralize the data using Rcpp function
  x <- scaleC(as.matrix(x))
  y <- scaleC(as.matrix(y))

  # Calculate the covariance matrix using Rcpp functions
  cov_xy <- matrixMultiply(t(x), y) / nrow(x)
  cov_x <- covarianceMatrix(x)
  cov_y <- covarianceMatrix(y)

  # Calculate the inverse matrix of the square root using Rcpp functions
  cov_x_inv_sqrt <- solveMatrixcpp(matrixSqrtcpp(cov_x))
  cov_y_inv_sqrt <- solveMatrixcpp(matrixSqrtcpp(cov_y))

  # Calculate the best linear combination to maximize the correlation between the two sets of variables
  P <-
    matrixMultiply(matrixMultiply(cov_x_inv_sqrt, cov_xy), cov_y_inv_sqrt)
  svd_decomposition <-
    svdDecomposition(P)  # Singular value decomposition using Rcpp

  # Calculate canonical vector and standardized using Rcpp functions
  x_coef <-
    matrixMultiply(cov_x_inv_sqrt, svd_decomposition$U) / sqrt(nrow(x) - 1)
  y_coef <-
    matrixMultiply(cov_y_inv_sqrt, svd_decomposition$V) / sqrt(nrow(y) - 1)

  # Calculate canonical correlation coefficients using Rcpp functions
  cov_xy <- covarianceMatrix(x, y)
  A_star <-
    matrixMultiply(matrixMultiply(matrixMultiply(cov_x_inv_sqrt, cov_xy), solve(cov_y)), t(cov_xy))
  A_star <- matrixMultiply(A_star, cov_x_inv_sqrt)
  A <- eigenValues(A_star)
  can_cor <- sqrt(A)

  # Remove any NaN values from the canonical correlations
  can_cor <- can_cor[!is.nan(can_cor)]

  return(list(
    cor = can_cor,
    xcoef = x_coef,
    ycoef = y_coef
  ))
}


