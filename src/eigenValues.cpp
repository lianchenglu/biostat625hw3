#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
using namespace Rcpp;
using namespace arma;
//' Compute Eigenvalues
//'
//' This function computes the eigenvalues of a given matrix. It returns the eigenvalues in descending order.
//' @param mat A numeric matrix (arma::mat) for which to compute the eigenvalues.
//' @return A numeric vector (arma::vec) containing the eigenvalues in descending order.
//' @examples
//' mat <- matrix(c(2, -1, -1, 2), nrow = 2)
//' eigenValues(mat)
//' @export
// [[Rcpp::export]]
arma::vec eigenValues(arma::mat mat) {
  arma::vec eigval = eig_sym(mat);
  return reverse(eigval); // Inverts the order of the eigenvalues
}
