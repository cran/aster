\name{reaster}
\alias{reaster}
\alias{reaster.default}
\alias{reaster.formula}
\title{Aster Models with Random Effects}
\concept{regression}
\concept{exponential family}
\concept{graphical model}
\description{
  Fits Aster Models with Random Effects using Laplace Approximation.
}
\usage{
reaster(fixed, random, pred, fam, varvar, idvar, root,
    famlist = fam.default(), origin, data, effects, sigma, response)
}
\arguments{

  \item{fixed}{either a model matrix or a formula specifying response
    and model matrix.  The model matrix for fixed effects.}

  \item{random}{either a model matrix or list of model matrices or
    a formula or a list of formulas specifying a model matrix or matrices.
    The model matrix or matrices for random effects.  Each model matrix
    specifies the random effects for one variance component.}

  \item{pred}{an integer vector of length \code{nnode} determining
    the dependence graph of the aster model.  \code{pred[j]} is
    the index of the predecessor of
    the node with index \code{j} unless the predecessor is a root
    node, in which case \code{pred[j] == 0}.  See details section
    of \code{\link{aster}} for further requirements.}

  \item{fam}{an integer vector of length \code{nnode} determining
    the exponential family structure of the aster model.  Each element
    is an index into the vector of family specifications given by
    the argument \code{famlist}.}

  \item{varvar}{a variable whose length is the row dimension of all model
    matrices that is a factor whose levels are character strings
    treated as variable names.  The number of variable names is \code{nnode}.
    Must be of the form \code{rep(vars, each = nind)} where \code{vars} is
    a vector of variable names.  Usually found in the data frame \code{data}
    when this is produced by the \code{\link{reshape}} function.}

  \item{idvar}{a variable whose length is the row dimension of all model
    matrices.  The number of individuals is \code{nind}.
    Must be of the form \code{rep(inds, times = nnode)} where \code{inds} is
    a vector of labels for individuals.  Usually found in the data frame
    \code{data} when this is produced by the \code{\link{reshape}} function.}

  \item{root}{a vector whose length is the row dimension of all model
    matrices.  For nodes whose predicessors are root nodes specifies the
    value of the constant at that root node.  Typically the vector having
    all components equal to one.}

  \item{famlist}{a list of family specifications (see \code{\link{families}}).}

  \item{origin}{a vector whose length is the row dimension of all model
    matrices.  Distinguished point in parameter space.  May be missing,
    in which case an unspecified default is provided.  See details of
    \code{\link{aster}} for further explanation.}

  \item{data}{an optional data frame containing the variables
    in the model.  If not found in \code{data}, the variables are taken
    from \code{environment(fixed)}, typically the environment from
    which \code{reaster} is called.  Usually produced by
    the \code{\link{reshape}} function.  Not needed when model matrixes
    rather than formulas are supplied in \code{fixed} and \code{random}.}

  \item{effects}{if not missing, a vector specifying starting values for
    all effects, fixed and random.  Length is the sum of the column dimensions
    of all model matrices.  If supplied, the random effects part should be
    standardized (random effects divided by their standard deviations, like
    the component \code{c} of the output of this function).}

  \item{sigma}{if not missing, a vector specifying starting values for
    the square roots of the variance components.  Length is the number
    of model matrices for
    random effects (the length of the list \code{random} if a list and one
    if \code{random} is not a list.}

  \item{response}{if not missing, a vector specifying the response.  Length
    is the row dimension of all model matrices.  If missing, the response
    is determined by the response in the formula \code{fixed}.}

}
\details{
  See the help page for the function \code{\link{aster}} for specification
  of aster models.  This function only fits unconditional aster models
  (those with default values of the \code{aster} function arguments
  \code{type} and \code{origin.type}.

  The only difference between this function and the \code{aster} function is
  that some effects are treated as random.  The unconditional canonical
  parameter vector of the aster model is treated as an affine function of
  fixed and random effects
  \deqn{\varphi = M \beta + \sum_{i = 1}^k \sigma^2_i Z_i b_i}{phi = M beta
  + sigma[1]^2 Z[1] b[1] + \dots + sigma[k]^2 Z[k] b[k]}
  where \eqn{M} and the \eqn{Z_i}{Z[i]} are model matrices specifed by
  the arguments \code{fixed} and \code{random}, where \eqn{\beta}{beta}
  is a vector of
  fixed effects and each \eqn{b_i}{b[i]} is a vector of random
  effects that are assumed to be (marginally) normally distributed with
  mean vector zero and variance matrix \eqn{\sigma_i^2}{sigma[i]^2} times
  the identity matrix.
  The vectors of random effects \eqn{b_i}{b[i]} are not parameters, rather
  they are latent (unobservable, hypothetical) variables.  The square roots
  of the variance components \eqn{\sigma_i}{sigma[i]} are parameters as
  are the components of \eqn{\beta}{beta}.
}
\section{NA Values}{
It was almost always wrong for an aster model to have \code{NA} values.
Although theoretically possible for the R formula mini-language to do the
right thing for an aster model with NA values in the data, usually it does
some wrong thing.  Thus, since version 0.8-20.  The this function and
the \code{\link{aster}} function give errors when used with data having
\code{NA} values.  Users must remove all \code{NA} values (or replace them
with what they should be, perhaps zero values) \dQuote{by hand}.
}
\value{
  \code{reaster} returns an object of class inheriting from \code{"reaster"}.
  An object of class \code{"reaster"} is a list containing at least the
  following components:

  \item{obj}{The aster object returned by a call to the \code{\link{aster}}
     function to fit the fixed effects model.}
  \item{fixed}{the model matrix for fixed effects.}
  \item{random}{the model matrix or matrices for random effects.}
  \item{dropped}{names of columns dropped from the fixed effects matrix.}
  \item{sigma}{approximate MLE for square roots of variance components.}
  \item{nu}{approximate MLE for variance components.}
  \item{c}{penalized likelihood estimates for the \eqn{c}'s,
    which are rescaled random effects.}
  \item{b}{penalized likelihood estimates for the random effects.}
  \item{alpha}{approximate MLE for fixed effects.}
  \item{zwz}{\eqn{Z W Z^T}{Z \%*\% W \%*\% t(Z)} where \eqn{Z} is
    the model matrix for random effects and \eqn{W} is the Hessian matrix
    of minus the complete data log likelihood with respect to random effects
    with MLE values of the parameters plugged in.}
  \item{response}{the response vector.}
  \item{origin}{the origin (offset) vector.}
  \item{iterations}{number of iterations of trust region algorithm in
    each iteration of re-estimating \code{zwz} and re-fitting.}
  \item{counts}{number of iterations of Nelder-Mead in initial optimization
    of approximate missing data log likelihood.}

  Calls to \code{reaster.formula} return a list also containing:

  \item{call}{the matched call.}
  \item{formula}{the formulas supplied.}
}
\references{
Geyer, Charles J., Ridley, Caroline E., Latta, Robert G., Etterson, Julie R.
    and Shaw, Ruth G. (2012)
Aster Models with Random Effects via Penalized Likelihood.
Technical Report 692, School of Statistics, University of Minnesota.
\url{http://purl.umn.edu/135870}.
}
\examples{
library(aster)
data(radish)
pred <- c(0,1,2)
fam <- c(1,3,2)
rout <- reaster(resp ~ varb + fit : (Site * Region),
    list(block = ~ 0 + fit : Block, pop = ~ 0 + fit : Pop),
    pred, fam, varb, id, root, data = radish)
summary(rout)
summary(rout, stand = FALSE, random = TRUE)
}
\keyword{models}
\keyword{regression}