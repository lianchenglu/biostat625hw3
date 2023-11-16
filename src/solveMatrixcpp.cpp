#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
using namespace Rcpp;
using namespace arma;
//' @title Compute the Inverse of a Matrix
//' @description
//' This function computes the inverse of a given numeric matrix using the Armadillo library.
//' @param x A numeric matrix (NumericMatrix).
//' @return A numeric matrix (NumericMatrix) that is the inverse of the input matrix.
//' @examples
//' mat <- matrix(c(4, 7, 2, 6), nrow = 2)
//' solveMatrixcpp(mat)
//' @export
// [[Rcpp::export]]
NumericMatrix solveMatrixcpp(NumericMatrix x) {
  arma::mat X(x.begin(), x.nrow(), x.ncol(), false); // Create the Armadillo matrix
  arma::mat Y = inv(X); // Computed inverse matrix
  return wrap(Y); // Convert the Armadillo matrix back to the NumericMatrix of the Rcpp
}
