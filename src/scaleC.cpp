#include <Rcpp.h>
using namespace Rcpp;

//' Scale a Matrix
//'
//' This function centers and scales a numeric matrix.
//' @param x A numeric matrix.
//' @return A scaled numeric matrix.
//' @export
//' @examples
//' scaleC(matrix(1:4, nrow = 2))
// [[Rcpp::export]]
NumericMatrix scaleC(NumericMatrix x) {
  int n = x.nrow(), p = x.ncol();
  NumericMatrix res(clone(x));

  for (int j = 0; j < p; j++) {
    double mean = std::accumulate(res.begin() + j * n, res.begin() + (j + 1) * n, 0.0) / n;
    for (int i = 0; i < n; i++) {
      res(i, j) -= mean;
    }
  }

  return res;
}
