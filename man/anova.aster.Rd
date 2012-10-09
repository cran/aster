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
\examples{
### see package vignette for explanation ###
library(aster)
data(echinacea)
vars <- c("ld02", "ld03", "ld04", "fl02", "fl03", "fl04",
    "hdct02", "hdct03", "hdct04")
redata <- reshape(echinacea, varying = list(vars), direction = "long",
    timevar = "varb", times = as.factor(vars), v.names = "resp")
redata <- data.frame(redata, root = 1)
pred <- c(0, 1, 2, 1, 2, 3, 4, 5, 6)
fam <- c(1, 1, 1, 1, 1, 1, 3, 3, 3)
hdct <- grepl("hdct", as.character(redata$varb))
redata <- data.frame(redata, hdct = as.integer(hdct))
level <- gsub("[0-9]", "", as.character(redata$varb))
redata <- data.frame(redata, level = as.factor(level))
aout1 <- aster(resp ~ varb + hdct : (nsloc + ewloc + pop),
    pred, fam, varb, id, root, data = redata)
aout2 <- aster(resp ~ varb + level : (nsloc + ewloc) + hdct : pop,
    pred, fam, varb, id, root, data = redata)
anova(aout1, aout2)
}
\keyword{models}
\keyword{regression}

