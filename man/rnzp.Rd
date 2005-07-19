\name{rnzp}
\alias{rnzp}
\title{The Non-Zero Poisson Distribution}
\description{
  Random generation for the Poisson distribution with parameter \code{mu}
  conditioned on being non-zero.  If \code{xpred} is not one, then
  random variate is the sum of \code{xpred} such random variates.
}
\usage{
function(n, mu, xpred = 1)
}
\arguments{
  \item{n}{number of random values to return.  If \code{length(n) > 1},
    the length is taken to be the number required.}
  \item{xpred}{number of trials.}
  \item{mu}{vector of positive means.}
}
\value{
  a vector of random deviates.
}
\keyword{distribution}
