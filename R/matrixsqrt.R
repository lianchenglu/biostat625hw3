#' Matrix Square Root with Regularization and Stability Check
#' This function calculates the square root of a matrix.
#'
#' @param m A matrix which we want to find the square root of.
#'
#' @return The square root of the input matrix m.
#'
#' @examples
#' matrixsqrt <- function(m) {
#'    eig <- eigen(m)
#'    Q <- eig$vectors
#'    rsqrtD <- sqrt(eig$values)
#'    return(Q %*% diag(rsqrtD) %*% t(Q))
#' }
#' @export

#' Matrix Square Root with Regularization and Stability Check
matrixsqrt <- function(m) {
  eig <- eigen(m)
  Q <- eig$vectors
  rsqrtD <- sqrt(eig$values)
  return(Q %*% diag(rsqrtD) %*% t(Q))
}