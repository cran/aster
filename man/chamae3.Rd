\name{chamae3}
\docType{data}
\alias{chamae3}
\title{Life History Data on Chamaecrista fasciculata}
\description{
  Data on life history traits for the partridge pea
  \emph{Chamaecrista fasciculata}
}
\usage{chamae3}
\format{
  A data frame with records for 2239 plants.
  Data are already in \dQuote{long} format; no need to reshape.
   \describe{
    \item{resp}{Response vector.}
    \item{varb}{Categorical.  Gives node of graphical model corresponding
      to each component of \code{resp}.  See details below.}
    \item{root}{All ones.  Root variables for graphical model.}
    \item{id}{Categorical.  Indicates individual plants.}
    \item{fit}{Zero-or-one-valued.  Indicates \dQuote{fitness} nodes of the
      graph.}
    \item{SIRE}{Categorical.  Sire.}
    \item{DAM}{Categorical.  Dam.}
    \item{SITE}{Categorical.  Experiment site.}
    \item{POP}{Categorical.  Population of sire and dam.}
    \item{ROW}{Numerical.  Row.  Position in site.}
    \item{BLK}{Categorical.  Block within site.}
  }
}
\details{
The levels of \code{varb} indicate nodes of the graphical model to which
the corresponding elements of the response vector \code{resp} belong.
This is the typical \dQuote{long} format produced by the R \code{reshape}
function.  For each individual, there are several response variables.
All response variables are combined in one vector \code{resp}.
The variable \code{varb} indicates which \dQuote{original} variable
the number was for.  The variable \code{id} indicates which individual
the number was for.  The levels of \code{varb}, which are the names
of the \dQuote{original} variables are
\describe{
  \item{fecund}{Fecundity.  Bernoulli, One if any fruit, zero if no fruit.}
  \item{fruit}{Integer.  Number of fruits observed.}
}
}
\source{
Julie Etterson
\url{https://scse.d.umn.edu/biology-department/faculty-staff/dr-julie-etterson}
}
\references{
These data are a subset of data previously analyzed by non-aster methods in the following.

Etterson, J. R. (2004).
Evolutionary potential of \emph{Chamaecrista fasciculata} in
    relation to climate change.  II. Genetic architecture of three
    populations reciprocally planted along an environmental gradient in the
    great plains.
\emph{Evolution}, \bold{58}, 1459--1471.
}
\examples{
data(chamae3)
### wide version
\dontrun{
### CRAN policy says examples must take < 5 sec.  This doesn't.
foo <- chamae3
### delete fit because it makes no sense in wide version
foo$fit <- NULL
chamae3w <- reshape(foo, direction = "wide", timevar = "varb",
    v.names = "resp", varying = list(levels(chamae3$varb)))
}
}
\keyword{datasets}

