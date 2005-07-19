\name{anova.aster}
\title{Analysis of Deviance for Aster Model Fits}
\usage{
\method{anova}{aster}(object, \dots)
}
\alias{anova.aster}
\alias{anova.asterlist}
\description{
  Compute an analysis of deviance table for two or more aster model
  fits.
}
\arguments{
  \item{object, \dots}{objects of class \code{"aster"}, typically
    the result of a call to \code{\link{aster}}, or a list of
    \code{objects} of class \code{"aster"} for the \code{"asterlist"} method.}
}
\details{
  Constructs a table having a row for the
  degrees of freedom and deviance for each model.
  For all but the first model, the change in degrees of freedom and
  deviance is also given, as is the corresponding asymptotic P value.
}
\value{
  An object of class \code{"anova"} inheriting from class \code{"data.frame"}.
}
\section{Warning}{
  The comparison between two or more models by \code{anova} or
  \code{anova.asterlist} will only be valid if they
  are (1) fitted to the same dataset, 
  (2) models are nested, (3) models are of the same type
  (all conditional or all unconditional), (4) have the same
  dependence graph and exponential families.
  None of this is currently checked.
}
\seealso{
  \code{\link{aster}}, \code{\link{anova}}.
}
\keyword{models}
\keyword{regression}

