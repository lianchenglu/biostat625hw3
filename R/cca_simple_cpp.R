library(Rcpp)
library(RcppArmadillo)

# matrix Multiply
cppFunction(
  '
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
'
)

# covariance Matrix
cppFunction(
  '
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
')

# eigenValues
cppFunction(
  depends = "RcppArmadillo",
  '
arma::vec eigenValues(arma::mat mat) {
    arma::vec eigval = eig_sym(mat);
    return reverse(eigval); // Inverts the order of the eigenvalues
}
')

# svd
cppFunction(
  depends = "RcppArmadillo",
  '
  List svdDecomposition(arma::mat X) {
    arma::mat U;
    arma::vec s;
    arma::mat V;

    arma::svd(U, s, V, X);

    return List::create(Named("U") = U,
                        Named("s") = s,
                        Named("V") = V);
  }
'
)

# Matrix Square Root
cppFunction(
  depends = "RcppArmadillo",
  '
  arma::mat matrixSqrtcpp(arma::mat m) {
    arma::vec eigval;
    arma::mat eigvec;

    arma::eig_sym(eigval, eigvec, m);
    arma::mat D = arma::diagmat(arma::sqrt(eigval));

    return eigvec * D * eigvec.t();
  }
'
)

# scale data
cppFunction(
  '
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
')

# solve Matrix
cppFunction(
  depends = "RcppArmadillo",
  '
NumericMatrix solveMatrixcpp(NumericMatrix x) {
    arma::mat X(x.begin(), x.nrow(), x.ncol(), false); // Create the Armadillo matrix
    arma::mat Y = inv(X); // Computed inverse matrix
    return wrap(Y); // Convert the Armadillo matrix back to the NumericMatrix of the Rcpp
}
            ')

#' Simple Canonical Correlation Analysis via Rcpp
#'
#' This function conducts the simple Canonical Correlation Analysis (CCA) between two sets of variables.
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
#' res <- cca_simple_cpp(x, y)
#' print(res)
#'
#' test_data <- hw3cca::data
#' test_data <- scale(test_data)
#' cca_simple_cpp(test_data[,1:4],test_data[,5:8])
#' cancor(test_data[,1:4],test_data[,5:8])[1:3]
#'
#' system.time(cca_simple_cpp(x,y)) # Time of my rcpp function
#' system.time(cancor(x,y)[1:3]) # Time of the R build-in cca function
#' @export

cca_simple_cpp <- function(x, y) {
  # check whether they have the same row
  if (nrow(x) != nrow(y)) {
    return('Unequal input row!')
  }

  # check dimension
  if (sum(is.na(x)) == nrow(x) * ncol(x) ||
      sum(is.na(y)) == nrow(y) * ncol(y)) {
    return('0 dimension in x or y')
  }

  # centralize the data using Rcpp function
  x <- scaleC(as.matrix(x))
  y <- scaleC(as.matrix(y))

  # Calculate the covariance matrix using Rcpp functions
  cov_xy <- matrixMultiply(t(x), y) / nrow(x)
  cov_x <- covarianceMatrix(x)
  cov_y <- covarianceMatrix(y)

  # Calculate the inverse matrix of the square root using Rcpp functions
  cov_x_inv_sqrt <- solveMatrixcpp(matrixSqrtcpp(cov_x))
  cov_y_inv_sqrt <- solveMatrixcpp(matrixSqrtcpp(cov_y))

  # Calculate the best linear combination to maximize the correlation between the two sets of variables
  P <-
    matrixMultiply(matrixMultiply(cov_x_inv_sqrt, cov_xy), cov_y_inv_sqrt)
  svd_decomposition <-
    svdDecomposition(P)  # Singular value decomposition using Rcpp

  # Calculate canonical vector and standardized using Rcpp functions
  x_coef <-
    matrixMultiply(cov_x_inv_sqrt, svd_decomposition$U) / sqrt(nrow(x) - 1)
  y_coef <-
    matrixMultiply(cov_y_inv_sqrt, svd_decomposition$V) / sqrt(nrow(y) - 1)

  # Calculate canonical correlation coefficients using Rcpp functions
  cov_xy <- covarianceMatrix(x, y)
  A_star <-
    matrixMultiply(matrixMultiply(matrixMultiply(cov_x_inv_sqrt, cov_xy), solve(cov_y)), t(cov_xy))
  A_star <- matrixMultiply(A_star, cov_x_inv_sqrt)
  A <- eigenValues(A_star)
  can_cor <- sqrt(A)

  # Remove any NaN values from the canonical correlations
  can_cor <- can_cor[!is.nan(can_cor)]

  return(list(
    cor = can_cor,
    xcoef = x_coef,
    ycoef = y_coef
  ))
}


