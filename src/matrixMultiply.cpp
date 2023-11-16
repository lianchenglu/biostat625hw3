#include <Rcpp.h>
using namespace Rcpp;
//' @title Matrix Multiplication
//' @description
//' Multiplies two matrices. The number of columns in the first matrix must match the number of rows in the second matrix.
//' @param mat1 A numeric matrix.
//' @param mat2 A numeric matrix.
//' @return A numeric matrix that is the result of multiplying `mat1` by `mat2`.
//' @examples
//' mat1 <- matrix(1:4, nrow = 2)
//' mat2 <- matrix(1:6, nrow = 2)
//' matrixMultiply(mat1, mat2)
//' @export
// [[Rcpp::export]]
NumericMatrix matrixMultiply(NumericMatrix mat1, NumericMatrix mat2) {
  if (mat1.ncol() != mat2.nrow()) {
    stop("Incompatible matrix dimensions");
  }

  int n = mat1.nrow(), k = mat2.ncol(), m = mat1.ncol();
  NumericMatrix prod(n, k);

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < k; j++) {
      double sum = 0;
      for (int l = 0; l < m; l++) {
        sum += mat1(i, l) * mat2(l, j);
      }
      prod(i, j) = sum;
    }
  }

  return prod;
}
