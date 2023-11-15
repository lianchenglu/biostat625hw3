#include <Rcpp.h>
using namespace Rcpp;
//' Compute Covariance Matrix
//'
//' This function computes the covariance matrix. It can compute the covariance matrix of a single matrix or the covariance between two matrices.
//' @param x A numeric matrix.
//' @param y An optional second numeric matrix to compute the covariance with. If not provided, the function computes the covariance of `x`.
//' @return A numeric matrix representing the covariance matrix.
//' @examples
//' mat1 <- matrix(1:4, nrow = 2)
//' mat2 <- matrix(1:6, nrow = 2)
//' covarianceMatrix(mat1)
//' covarianceMatrix(mat1, mat2)
//' @export
// [[Rcpp::export]]
NumericMatrix covarianceMatrix(NumericMatrix x, Nullable<NumericMatrix> y = R_NilValue) {
  int n = x.nrow(), k = x.ncol();
  NumericMatrix covMat;

  if (y.isNull()) {
    // Calculate the covariance matrix for a single matrix x
    covMat = NumericMatrix(k, k);
    NumericVector means = colMeans(x);

    for (int i = 0; i < k; i++) {
      for (int j = i; j < k; j++) {
        double sum = 0;
        for (int l = 0; l < n; l++) {
          sum += (x(l, i) - means[i]) * (x(l, j) - means[j]);
        }
        covMat(i, j) = sum / (n - 1);
        covMat(j, i) = covMat(i, j); // The covariance matrix is symmetric
      }
    }
  } else {
    // Calculate the covariance matrix between two matrices x and y
    NumericMatrix matY = as<NumericMatrix>(y);
    if (n != matY.nrow()) {
      stop("Number of rows of matrices must match!");
    }
    int ky = matY.ncol();
    covMat = NumericMatrix(k, ky);
    NumericVector meansX = colMeans(x);
    NumericVector meansY = colMeans(matY);

    for (int i = 0; i < k; i++) {
      for (int j = 0; j < ky; j++) {
        double sum = 0;
        for (int l = 0; l < n; l++) {
          sum += (x(l, i) - meansX[i]) * (matY(l, j) - meansY[j]);
        }
        covMat(i, j) = sum / (n - 1);
      }
    }
  }

  return covMat;
}
