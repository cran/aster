\name{aster}
\alias{aster}
\alias{aster.default}
\alias{aster.formula}
\title{Aster Models}
\concept{regression}
\concept{exponential family}
\concept{graphical model}
\description{
  Fits Aster Models.
}
\usage{
aster(x, \dots)

\method{aster}{default}(x, root, pred, fam, modmat, parm,
    type = c("unconditional", "conditional"),
    method = c("nlm", "CG", "L-BFGS-B"), fscale, maxiter = 1000,
    nowarn = TRUE, newton = TRUE, coef.names, \dots)

\method{aster}{formula}(formula, pred, fam, varvar, idvar, root,
    data, parm, type = c("unconditional", "conditional"),
    method = c("nlm", "CG", "L-BFGS-B"), fscale, maxiter = 1000,
    nowarn = TRUE, newton = TRUE, \dots)
}
\arguments{

  \item{x}{an \code{nind} by \code{nnode} matrix, the data for an
    aster model.  The rows are independent and identically modeled
    random vectors.  See details below for further requirements.

    \code{aster.formula} constructs such an \code{x} from the response
    in its formula.  Hence data for \code{aster.formula} must have
    \code{nind * nnode} rows.}

  \item{root}{an object of the same shape as \code{x}, the root data.
    For \code{aster.default} an \code{nind} by \code{nnode} matrix,
    For \code{aster.formula} an \code{nind * nnode} vector.}

  \item{pred}{an integer vector of length \code{nnode} determining
    the dependence
    graph of the aster model.  \code{pred[j]} is
    the index of the predecessor of
    the node with index \code{j} unless the predecessor is a root
    node, in which case \code{pred[j] == 0}.  See details below for
    further requirements.}

  \item{fam}{an integer vector of length \code{nnode} determining
    the exponential family structure of the aster model.
    \code{fam} is an index into the vector of family names returned by
    \code{\link{families}}, so \code{families()[fam]} gives the
    one-parameter exponential families associated with each node
    of the graph.}

  \item{modmat}{an \code{nind} by \code{nnode} by \code{ncoef}
    three-dimensional array, the model matrix.

    \code{aster.formula} constructs such a \code{modmat} from 
    its formula, the data frame \verb@data@, and the variables
    in the environment of the formula.}

  \item{parm}{usually missing.  Otherwise a vector of length \code{ncoef}
    giving a starting point for the optimization.}

  \item{type}{type of model.
    The value of this argument can be abbreviated.}

  \item{method}{optimization method.  If \code{"nlm"} then the
    \code{\link{nlm}} function is used.  Otherwise the
    \code{\link{optim}} function is used with the specified \code{method}
    supplied to it.
    The value of this argument can be abbreviated.}

  \item{fscale}{an estimate of the size of the log likelihood at the maximum.
    Defaults to \code{nind}.}

  \item{maxiter}{maximum number of iterations.  Defaults to '1000'.}

  \item{nowarn}{if \code{TRUE} (the default), suppress warnings from
    the optimization routine.}

  \item{newton}{if \code{TRUE} (the default), do one Newton iteration
    on the result produced by the optimization routine.}

  \item{coef.names}{names of the regression coefficients.  If missing,
    \code{dimnames(modmat)[[3]]} is used.  In \verb@aster.formula@ these
    are produced automatically by the R formula machinery.}

  \item{\ldots}{other arguments passed to the optimization method.}

  \item{formula}{a symbolic description of the model to be fit.  See
    \code{\link{lm}}, \code{\link{glm}}, and 
    \code{\link{formula}} for discussions of the R formula mini-language.}

  \item{varvar}{a variable of the same length as the response in
    the formula that is a factor whose levels are character strings
    treated as variable names.  The number of variable names is \code{nnode}.
    Must be of the form \code{rep(vars, each = nind)} where \code{vars} is
    a vector of variable names.  Usually found in the data frame \code{data}
    when this is produced by the \code{\link{reshape}} function.}

  \item{idvar}{a variable of the same length as the response in
    the formula that indexes individuals.  The number
    of individuals is \code{nind}.
    Must be of the form \code{rep(inds, times = nnode)} where \code{inds} is
    a vector of labels for individuals.  Usually found in the data frame
    \code{data} when this is produced by the \code{\link{reshape}} function.}

  \item{data}{an optional data frame containing the variables
    in the model.  If not found in \code{data}, the variables are taken
    from \code{environment(formula)}, typically the environment from
    which \code{aster} is called.  Usually produced by
    the \code{\link{reshape}} function.}
}
\details{
The vector \code{pred} must satisfy \code{all(pred < seq(along = pred))},
that is, each predecessor must precede in the order given in pred.
The vector \code{pred} defines a function \eqn{p}.

The joint distribution of the data matrix \code{x} is a product of conditionals
\deqn{\prod_{i \in I} \prod_{j \in J} \Pr \{ X_{i j} | X_{i p(j)} \}}{prod[i] prod[j] Pr(x[i, j], x[i, p(j)])}
When \eqn{p(j) = 0}, the notation \eqn{X_{i p(j)}}{x[i, p(j)]}
means \code{root[i, j]}.  Other elements of the matrix \code{root} are
not used.

The conditional distribution
\eqn{\Pr \{ X_{i j} | X_{i p(j)} \}}{Pr(x[i, j], x[i, p(j)])}
is the \eqn{X_{i p(j)}}{x[i, p(j)]}-fold convolution of the \eqn{j}-th family
in the vector \code{fam}, a one-parameter exponential family
(i.e., the sum of \eqn{X_{i p(j)}}{x[i, p(j)]} i.i.d. terms having
this one-parameter exponential family distribution).

For \code{type == "conditional"} the canonical parameter vector
\eqn{\theta_{i j}}{theta[i, j]} is modeled in GLM fashion as
\eqn{\theta = M \beta}{theta = M beta} where \eqn{M} is the model
matrix \code{modmat}.  Since the \dQuote{vector} \eqn{\theta}{theta} is
actually a matrix, the \dQuote{matrix} \eqn{M} must correspondingly
be a three-dimensional array.  So \eqn{\theta = M \beta}{theta = M beta}
written out in full is
\deqn{\theta_{i j} = \sum_{k \in K} m_{i j k} \beta_k}{theta[i, j] = sum[k] m[i, j, k] beta[k]}
This specifies the log likelihood.

For \code{type == "unconditional"} the canonical parameter vector
for an unconditional model is modeled in GLM fashion as
\eqn{\varphi = M \beta}{phi = M beta} (where the notation is as above).
The unconditional canonical parameters are then specified in terms of
the conditional ones by
\deqn{\varphi_{i j} = \theta_{i j} - \sum_{k \in S(j)} \psi_k(\theta_{i k})}{phi[i, j] = theta[i, j] - sum[k in S(j)] psi[k](theta[i, k])}
where \eqn{S(j)} denotes the set of successors of \eqn{j},
the \eqn{k} such that \eqn{p(k) = j}, and \eqn{\psi_k}{psi[k]} is the
cumulant function for the \eqn{k}-th exponential family.
This rather crazy looking formulation is an invertible change of parameter
and makes \eqn{\varphi}{phi}
the canonical parameter and \eqn{x} the canonical statistic of a full
flat unconditional exponential family.
Again, this specifies the log likelihood.

In order to use the R model formula mini-language we must flatten
the dimensionality, making the model matrix \code{modmat} two-dimensional
(a true matrix).  This must be done as if by
\code{matrix(modmat, ncol = ncoef)},
which imposes the requirements on \code{varvar} and \code{idvar}
given in the arguments section: they must look like \code{row(x)} and
\code{col(x)} modulo relabeling.
Then \code{x} and \code{root}
become one-dimensional, done as if by \code{as.numeric(x)}
and \code{as.numeric(root)}.

The standard way to do this in R is to use the \code{\link{reshape}}
function on a data frame in which the columns of the \code{x} matrix
are variables in the data frame.  \code{reshape} automatically puts
things in the right order and creates \code{varvar} and \code{idvar}.
}
\value{
  \code{aster} returns an object of class inheriting from \code{"aster"}.
  \code{aster.formula}, returns an object of class \code{"aster"} and
  subclass \code{"aster.formula"}.

  The function \code{\link{summary}} (i.e., \code{\link{summary.aster}}) can
  be used to obtain or print a summary of the results, the function
  \code{\link{anova}} (i.e., \code{\link{anova.aster}})
  to produce an analysis of deviance table, and the function
  \code{\link{predict}} (i.e., \code{\link{predict.aster}})
  to produce predicted values and standard errors.

  An object of class \code{"aster"} is a list containing at least the
  following components:

  \item{coefficients}{a named vector of coefficients.}
  \item{rank}{the numeric rank of the fitted generalized linear model
      part of the aster model (i.e., the rank of \code{modmat}).}
  \item{deviance}{up to a constant, minus twice the maximized
    log-likelihood.}
  \item{iter}{the number of iterations used by the optimization method.}
  \item{converged}{logical. Was the optimization algorithm judged to have
     converged?}
  \item{code}{integer.  The convergence code returned by the optimization
     method.}
  \item{gradient}{The gradient vector of minus the log likelihood at the
      fitted \code{coefficients} vector.}
  \item{hessian}{The Hessian matrix of minus the log likelihood
      (i.e., the observed Fisher information) at the
      fitted \code{coefficients} vector.
      This is also the expected Fisher information when
      \code{type == "unconditional"}.}
  \item{fisher}{Expected Fisher information at the fitted \code{coefficients}
      vector.}

  Calls to \code{aster.formula} return a list also containing:

  \item{call}{the matched call.}
  \item{formula}{the formula supplied.}
  \item{terms}{the \code{\link{terms}} object used.}
  \item{data}{the \code{data argument}.}
}
\seealso{
\code{\link{anova.aster}},
\code{\link{summary.aster}},
and
\code{\link{predict.aster}}
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
hdct <- grep("hdct", as.character(redata$varb))
hdct <- is.element(seq(along = redata$varb), hdct)
redata <- data.frame(redata, hdct = as.integer(hdct))
aout4 <- aster(resp ~ varb + nsloc + ewloc + pop * hdct - pop,
    pred, fam, varb, id, root, data = redata)
summary(aout4, show.graph = TRUE)
}
\keyword{models}
\keyword{regression}
