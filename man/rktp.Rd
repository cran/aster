\name{rktp}
\alias{rktp}
\title{The K-Truncated Poisson Distribution}
\description{
  Random generation for the Poisson distribution with parameter \code{mu}
  conditioned on being strictly greater than \code{k}.  If \code{xpred} is not one, then
  random variate is the sum of \code{xpred} such random variates.
}
\usage{
rktp(n, k, mu, xpred = 1)
}
\arguments{
  \item{n}{number of random values to return.  If \code{length(n) > 1},
    the length is taken to be the number required.}
  \item{k}{truncation limit.}
  \item{xpred}{number of trials.}
  \item{mu}{vector of positive means.}
}
\value{
  a vector of random deviates.
}
\examples{
rktp(10, 2, 0.75)
}
\keyword{distribution}
