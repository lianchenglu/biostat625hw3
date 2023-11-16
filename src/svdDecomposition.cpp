#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
using namespace Rcpp;
using namespace arma;
//' @title Singular Value Decomposition
//' @description
//' This function performs a singular value decomposition on a given numeric matrix using the Armadillo library.
//' @param X A numeric matrix (arma::mat) for which the SVD is to be computed.
//' @return A list containing the matrices U, S, and V from the SVD.
//' @examples
//' mat <- matrix(c(1, 2, 3, 4), nrow = 2)
//' svdDecomposition(mat)
//' @export
// [[Rcpp::export]]
List svdDecomposition(arma::mat X) {
  arma::mat U;
  arma::vec s;
  arma::mat V;

  arma::svd(U, s, V, X);

  return List::create(Named("U") = U,
                      Named("s") = s,
                      Named("V") = V);
}
