#' Simple Canonical Correlation Analysis
#'
#' This function conducts the simple Canonical Correlation Analysis (CCA) between two sets of variables.
#'
#' @importFrom stats cov
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
#' res <- cca_simple(x, y)
#' print(res)
#'
#' test_data <- hw3cca::data
#' test_data <- scale(test_data)
#' cca_simple(test_data[,1:4],test_data[,5:8])
#' cancor(test_data[,1:4],test_data[,5:8])[1:3]
#'
#' system.time(cca_simple(x,y)) # Time of my function
#' system.time(cancor(x,y)[1:3]) # Time of the R build-in cca function
#' @export

cca_simple <- function(x, y) {
  # check whether they have the same row
  if (nrow(x) != nrow(y)){
    return('Unequal input row!')
  }

  # check dimension
  if (sum(is.na(x)) == nrow(x)*ncol(x) || sum(is.na(y)) == nrow(y)*ncol(y)) {
    return('0 dimension in x or y')
  }

  # centralizer the data
  x <- scale(x, center = TRUE, scale = FALSE)
  y <- scale(y, center = TRUE, scale = FALSE)

  # Calculate the covariance matrix
  cov_xy <- t(x) %*% y / (nrow(x))
  cov_x <- cov(x)
  cov_y <- cov(y)

  # Calculate the inverse matrix of the square root
  cov_x_inv_sqrt <- solve(matrixsqrt(cov_x))
  cov_y_inv_sqrt <- solve(matrixsqrt(cov_y))

  # Calculate the best linear combination to maximize the correlation between the two sets of variables
  P <- cov_x_inv_sqrt %*% cov_xy %*% cov_y_inv_sqrt
  svd_decomposition <- svd(P)  # Singular value decomposition

  # Calculate canonical vector and standardized
  x_coef <-
    cov_x_inv_sqrt %*% svd_decomposition$u / sqrt(nrow(x) - 1)
  y_coef <-
    cov_y_inv_sqrt %*% svd_decomposition$v / sqrt(nrow(y) - 1)

  # Calculate canonical correlation coefficients
  cov_xy <- cov(x, y)
  A_star <-
    cov_x_inv_sqrt %*% cov_xy %*% solve(cov_y) %*% t(cov_xy) %*% cov_x_inv_sqrt
  A <- eigen(A_star)
  can_cor <- sqrt(A$values)

  # Remove any NaN values from the canonical correlations
  can_cor <- can_cor[!is.nan(can_cor)]

  return(list(
    cor = can_cor,
    xcoef = x_coef,
    ycoef = y_coef
  ))
}



