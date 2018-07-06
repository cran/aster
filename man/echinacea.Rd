
\name{echinacea}
\docType{data}
\alias{echinacea}
\title{Life History Data on Echinacea angustifolia}
\description{
  Data on life history traits for the narrow-leaved purple coneflower
  \emph{Echinacea angustifolia}
}
\usage{echinacea}
\format{
  A data frame with records for 570 plants observed over three years.
   \describe{
    \item{ld02}{Indicator of being alive in 2002.}
    \item{ld03}{Ditto for 2003.}
    \item{ld04}{Ditto for 2004.}
    \item{fl02}{Indicator of flowering 2002.}
    \item{fl03}{Ditto for 2003.}
    \item{fl04}{Ditto for 2004.}
    \item{hdct02}{Count of number of flower heads in 2002.}
    \item{hdct03}{Ditto for 2003.}
    \item{hdct04}{Ditto for 2004.}
    \item{pop}{the remnant population of origin of the plant
       (all plants were grown together, \code{pop} encodes ancestry).}
    \item{ewloc}{east-west location in plot.}
    \item{nsloc}{north-south location in plot.}
  }
}
\source{
Stuart Wagenius,
\url{http://www.chicagobotanic.org/research/staff/wagenius}
}
\examples{
library(aster)
data(echinacea)
vars <- c("ld02", "ld03", "ld04", "fl02", "fl03", "fl04",
    "hdct02", "hdct03", "hdct04")
redata <- reshape(echinacea, varying = list(vars), direction = "long",
    timevar = "varb", times = as.factor(vars), v.names = "resp")
names(echinacea)
dim(echinacea)
names(redata)
dim(redata)
}
\keyword{datasets}

