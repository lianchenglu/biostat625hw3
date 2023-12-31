// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// covarianceMatrix
NumericMatrix covarianceMatrix(NumericMatrix x, Nullable<NumericMatrix> y);
RcppExport SEXP _hw3cca_covarianceMatrix(SEXP xSEXP, SEXP ySEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type x(xSEXP);
    Rcpp::traits::input_parameter< Nullable<NumericMatrix> >::type y(ySEXP);
    rcpp_result_gen = Rcpp::wrap(covarianceMatrix(x, y));
    return rcpp_result_gen;
END_RCPP
}
// eigenValues
arma::vec eigenValues(arma::mat mat);
RcppExport SEXP _hw3cca_eigenValues(SEXP matSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::mat >::type mat(matSEXP);
    rcpp_result_gen = Rcpp::wrap(eigenValues(mat));
    return rcpp_result_gen;
END_RCPP
}
// matrixMultiply
NumericMatrix matrixMultiply(NumericMatrix mat1, NumericMatrix mat2);
RcppExport SEXP _hw3cca_matrixMultiply(SEXP mat1SEXP, SEXP mat2SEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type mat1(mat1SEXP);
    Rcpp::traits::input_parameter< NumericMatrix >::type mat2(mat2SEXP);
    rcpp_result_gen = Rcpp::wrap(matrixMultiply(mat1, mat2));
    return rcpp_result_gen;
END_RCPP
}
// matrixSqrtcpp
arma::mat matrixSqrtcpp(arma::mat m);
RcppExport SEXP _hw3cca_matrixSqrtcpp(SEXP mSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::mat >::type m(mSEXP);
    rcpp_result_gen = Rcpp::wrap(matrixSqrtcpp(m));
    return rcpp_result_gen;
END_RCPP
}
// scaleC
NumericMatrix scaleC(NumericMatrix x);
RcppExport SEXP _hw3cca_scaleC(SEXP xSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type x(xSEXP);
    rcpp_result_gen = Rcpp::wrap(scaleC(x));
    return rcpp_result_gen;
END_RCPP
}
// solveMatrixcpp
NumericMatrix solveMatrixcpp(NumericMatrix x);
RcppExport SEXP _hw3cca_solveMatrixcpp(SEXP xSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type x(xSEXP);
    rcpp_result_gen = Rcpp::wrap(solveMatrixcpp(x));
    return rcpp_result_gen;
END_RCPP
}
// svdDecomposition
List svdDecomposition(arma::mat X);
RcppExport SEXP _hw3cca_svdDecomposition(SEXP XSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::mat >::type X(XSEXP);
    rcpp_result_gen = Rcpp::wrap(svdDecomposition(X));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_hw3cca_covarianceMatrix", (DL_FUNC) &_hw3cca_covarianceMatrix, 2},
    {"_hw3cca_eigenValues", (DL_FUNC) &_hw3cca_eigenValues, 1},
    {"_hw3cca_matrixMultiply", (DL_FUNC) &_hw3cca_matrixMultiply, 2},
    {"_hw3cca_matrixSqrtcpp", (DL_FUNC) &_hw3cca_matrixSqrtcpp, 1},
    {"_hw3cca_scaleC", (DL_FUNC) &_hw3cca_scaleC, 1},
    {"_hw3cca_solveMatrixcpp", (DL_FUNC) &_hw3cca_solveMatrixcpp, 1},
    {"_hw3cca_svdDecomposition", (DL_FUNC) &_hw3cca_svdDecomposition, 1},
    {NULL, NULL, 0}
};

RcppExport void R_init_hw3cca(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
