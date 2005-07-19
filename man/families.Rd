\name{families}
\alias{families}
\alias{famfun}
\title{Families for Aster Models}
\usage{
families()
famfun(index, deriv, theta)
}
\description{
Families (response models) known to the package.  In all functions
families are specified by an integer index.  \code{families()} returns
names (as character strings) corresponding to valid index values.
For each family three functions are defined: the cumulant function for
the one-parameter exponential family, its first derivative (which maps
canonical parameter to mean value parameter), and its second derivative
(which maps canonical parameter to Fisher information).
}
\arguments{
  \item{index}{integer index of the family.}
  \item{deriv}{derivative wanted: 0, 1, or 2.}
  \item{theta}{value of the canonical parameter.}
}
\details{
Currently implemented families are
  \describe{
    \item{\code{"bernoulli"}}{Bernoulli.  The mean value parameter
      \eqn{\mu}{mu} is the success probability.  The canonical parameter is
      \eqn{\theta = \log(\mu) - \log(1 - \mu)}{theta = log(mu) - log(1 - mu)},
      also called logit of \eqn{\mu}{mu}.  The first derivative function
      has the value
      \eqn{\mu}{mu} and the second derivative the value
      \eqn{\mu (1 - \mu)}{mu (1 - mu)}.}
    \item{\code{"poisson"}}{Poisson.  The mean value parameter
      \eqn{\mu}{mu} is the mean of the Poisson distribution.
      The canonical parameter is \eqn{\theta = \log(\mu)}{theta = log(mu)}.
      The first and second derivative functions both have the value
      \eqn{\mu}{mu}.}
    \item{\code{"non.zero.poisson"}}{Poisson conditioned on being non-zero.
      Let \eqn{\mu}{mu} be the mean of the unconditional Poisson distribution.
      The canonical parameter is \eqn{\theta = \log(\mu)}{theta = log(mu)}.
      The mean value parameter is
      \deqn{\tau = \frac{\mu}{1 - \exp(- \mu)}}{tau = mu / (1 - exp(- mu)}
      The first derivative function has the value \eqn{\tau}{tau} and
      the second derivative function has the value
      \eqn{\tau [1 - \tau \exp(- \mu)]}{tau [1 - tau * exp(- mu)]}.}
  }
}
\value{
  For \code{families} a vector of character strings, each a family name.
  For \code{famfun} a scalar double, the value.
}
\keyword{misc}
