#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
using namespace Rcpp;
using namespace arma;
//' @title Compute the Square Root of a Matrix
//' @description
//' This function computes the square root of a given square matrix using eigenvalue decomposition.
//' @param m A square numeric matrix (arma::mat).
//' @return A numeric matrix (arma::mat) that is the square root of the input matrix.
//' @examples
//' mat <- matrix(c(4, 0, 0, 4), nrow = 2)
//' matrixSqrtcpp(mat)
//' @export
// [[Rcpp::export]]
arma::mat matrixSqrtcpp(arma::mat m) {
  arma::vec eigval;
  arma::mat eigvec;

  arma::eig_sym(eigval, eigvec, m);
  arma::mat D = arma::diagmat(arma::sqrt(eigval));

  return eigvec * D * eigvec.t();
}
