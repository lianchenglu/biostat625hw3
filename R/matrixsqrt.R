#' Matrix Square Root
#'
#' This function calculates the square root of a matrix.
#'
#' @param m A matrix which we want to find the square root of.
#'
#' @return The square root of the input matrix m.
#'
#' @examples
#' x <- cov(matrix(rnorm(2000), 1000, 2))
#' matrixsqrt(x)
#'
#' @export

# Matrix Square Root
matrixsqrt <- function(m) {
  eig <- eigen(m)
  Q <- eig$vectors
  rsqrtD <- sqrt(eig$values)
  return(Q %*% diag(rsqrtD) %*% t(Q))
}
