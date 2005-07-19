\name{summary.aster}
\alias{summary.aster}
\alias{print.summary.aster}
\title{Summarizing Aster Model Fits}
\usage{
\method{summary}{aster}(object, info = c("expected", "observed"),
    info.tol = sqrt(.Machine$double.eps),  show.graph = FALSE, \dots)

\method{print}{summary.aster}(x, digits = max(3, getOption("digits") - 3),
      signif.stars = getOption("show.signif.stars"), \dots)
}
\arguments{
  \item{object}{an object of class \code{"aster"}, usually, a result of a
    call to \code{\link{aster}}.}
  \item{info}{the type of Fisher information use to compute standard errors.}
  \item{info.tol}{tolerance for eigenvalues of Fisher information.
    If \code{eval} is the vector of eigenvalues of the information matrix,
    then \code{eval < cond.tol * max(eval)} are considered zero.  Hence the
    corresponding eigenvectors are directions of constancy or recession of
    the log likelihood.}
  \item{show.graph}{if \code{TRUE}, show the graphical model.}
  \item{x}{an object of class \code{"summary.aster"}, usually, a result of a
    call to \code{summary.aster}.}
  \item{digits}{the number of significant digits to use when printing.}
  \item{signif.stars}{logical. If \code{TRUE}, \dQuote{significance stars}
    are printed for each coefficient.}
  \item{\dots}{further arguments passed to or from other methods.}
}
\description{
  These functions are all \code{\link{methods}} for class \code{aster} or
  \code{summary.aster} objects.
}
\value{
  \code{summary.aster} returns an object of class \code{"summary.aster"}
  list with the same components as \code{object}, which is of class
  \code{"aster"}.
}
\seealso{
  \code{\link{aster}}, \code{\link{summary}}.
}
\keyword{models}
