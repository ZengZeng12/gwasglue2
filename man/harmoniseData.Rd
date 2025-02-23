% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/harmonise_method.R
\name{harmoniseData}
\alias{harmoniseData}
\title{Harmonise the alleles and effects between two summary sets}
\usage{
harmoniseData(object, tolerance, action)
}
\arguments{
\item{object}{The DataSet object}

\item{tolerance}{Tolerance value (default 0.08).}

\item{action}{Level of strictness in dealing with SNPs.
\itemize{
\item \code{action = 1}: Assume all alleles are coded on the forward strand, i.e. do not attempt to flip alleles
\item \code{action = 2}: Try to infer positive strand alleles, using allele frequencies for palindromes (default, conservative);
\item \code{action = 3}: Correct strand for non-palindromic SNPs, and drop all palindromic SNPs from the analysis (more conservative).
}}
}
\description{
Harmonise the alleles and effects between two summary sets
}
