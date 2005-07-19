\name{predict.aster}
\alias{predict.aster}
\alias{predict.aster.formula}
\concept{regression}
\concept{exponential family}
\concept{graphical model}
\title{Predict Method for Aster Model Fits}
\usage{
\method{predict}{aster}(object, x, root, modmat, amat,
    parm.type = c("mean.value", "canonical"),
    model.type = c("unconditional", "conditional"),
    se.fit = FALSE, info = c("expected", "observed"),
    info.tol = sqrt(.Machine$double.eps), \ldots)


\method{predict}{aster.formula}(object, newdata, varvar, idvar, root, amat,
    parm.type = c("mean.value", "canonical"),
    model.type = c("unconditional", "conditional"),
    se.fit = FALSE, info = c("expected", "observed"),
    info.tol = sqrt(.Machine$double.eps), \ldots)
}
\arguments{
  \item{object}{a fitted object of class inheriting from \code{"aster"}
    or \code{"aster.formula"}.}

  \item{modmat}{a model matrix to use instead of \code{object$modmat}.
    Must have the same structure (three-dimensional array, first index runs
    over individuals, second over nodes of the graphical model, third over
    covariates.  Must have the same second and third dimensions as
    \code{object$modmat}.  The second and third components of
    \code{dimnames(modmat)} and \code{dimnames(object$modmat)} must also be
    the same.

    May be missing, in which case \code{object$modmat} is used.

    \code{predict.aster.formula} constructs such a \code{modmat} from
    \code{object$formula}, the data frame \code{newdata}, and the variables
    in the environment of the formula.  When \code{newdata} is missing, then
    \code{object$modmat} is used.}

  \item{x}{response.  Ignored and may be missing unless
    \code{parm.type == "mean.value" && model.type == "conditional"}.
    Even then may be missing when \code{modmat} is missing,
    in which case \code{object$x} is used.  A matrix whose first and
    second dimensions and the corresponding dimnames agrees with
    those of \code{modmat} and \code{object$modmat}.

    \code{predict.aster.formula} constructs such an \code{x} from
    the response variable name in \code{object$formula},
    the data frame \code{newdata},
    and the variables in the environment of the formula.  When \code{newdata}
    is missing, then \code{object$x} is used.}

  \item{root}{root data.  Ignored and may be missing unless
    \code{parm.type == "mean.value"}.
    Even then may be missing when \code{modmat} is missing,
    in which case \code{object$root} is used.  A matrix of the
    same form as \code{x}.

    \code{predict.aster.formula} looks up the variable supplied as
    the argument \code{root} in the data frame \code{newdata} or in
    the variables in the environment of the formula and makes it a matrix
    of the same form as \code{x}.  When \code{newdata}
    is missing, then \code{object$root} is used.}

  \item{amat}{if \code{zeta} is the requested prediction (mean value
    or canonical, unconditional or conditional, depending on \code{parm.type}
    and \code{model.type}), then we predict the linear function
    \code{t(amat) \%*\% zeta}.  May be missing, in which case the identity
    linear function is used.

    For \code{predict.aster}, a three-dimensional
    array with \code{dim(amat)[1:2] == dim(modmat)[1:2]}.

    For \code{predict.aster.formula}, a matrix with
    \code{nrow(amat) == nrow(newdata)}.}

  \item{parm.type}{the type of parameter to predict.  The default is
    mean value parameters (the opposite of the default
    for \code{\link{predict.glm}}), the expected value of a linear function
    of the response under the MLE probability model (also called the
    MLE of the mean value parameter).  The expectation is unconditional
    or conditional depending on \code{parm.type}.

    The alternative \code{"canonical"} is the value of a linear function
    of the MLE of canonical parameters under the MLE probability model.
    The canonical parameter is unconditional
    or conditional depending on \code{parm.type}.

    The value of this argument can be abbreviated.
  }

  \item{model.type}{the type of model in which to predict.  The default is
    \code{"unconditional"} in which case the parameters (either mean value
    or canonical, depending on the value of \code{parm.type}) are those
    of an unconditional model.
    The alternative is \code{"conditional"} in which case the parameters
    are those of a conditional model.

    The value of this argument can be abbreviated.
  }

  \item{se.fit}{logical switch indicating if standard errors are required.}

  \item{info}{the type of Fisher information use to compute standard errors.}

  \item{info.tol}{tolerance for eigenvalues of Fisher information.
    If \code{eval} is the vector of eigenvalues of the information matrix,
    then \code{eval < cond.tol * max(eval)} are considered zero.  Hence the
    corresponding eigenvectors are directions of constancy or recession of
    the log likelihood.}

  \item{newdata}{optionally, a data frame in which to look for variables with
    which to predict.  If omitted, see \code{modmat} above.  See also details
    section below.}

  \item{varvar}{a variable of length \code{nrow(newdata)}, typically a
    variable in \code{newdata}
    that is a factor whose levels are character strings
    treated as variable names.  The number of variable names is \code{nnode}.
    Must be of the form \code{rep(vars, each = nind)} where \code{vars} is
    a vector of variable names.  Not used if \code{newdata} is missing.}

  \item{idvar}{a variable of length \code{nrow(newdata)}, typically a
    variable in \code{newdata}
    that indexes individuals.  The number
    of individuals is \code{nind}.
    Must be of the form \code{rep(inds, times = nnode)} where \code{inds} is
    a vector of labels for individuals.  Not used if \code{newdata} is missing.}

  \item{\dots}{further arguments passed to or from other methods.}
}
\description{
  Obtains predictions and optionally estimates standard errors of those
  predictions from a fitted Aster model object.
}
\details{
Note that \code{model.type} need have nothing to do with the type
of the fitted aster model, which is \code{object$type}.

Whether the
fitted model is conditional or unconditional, one typically wants
\emph{unconditional} mean value parameters, because conditional mean
value parameters for hypothetical individuals depend on the hypothetical
data \code{x}, which usually makes no scientific sense.

If one does ask for \emph{conditional} mean value parameters, generally
the \dQuote{data} should satisfy \code{all(x == 1)} and \code{all(root == 1)},
so that the mean value parameters
are \dQuote{per unit of predecessor variable}, that is we \dQuote{predict}
\eqn{\psi''(\theta_{i j})}{psi''(theta[i, j])} rather than this multiplied
by \eqn{X_{i p(j)}}{x[i, p(j)]}.

Similarly, if \code{object$type == "conditional"}, then the conditional
canonical parameters are a linear function of the regression coefficients
\eqn{\theta = M \beta}{theta = M beta}, where \eqn{M} is the model matrix,
but one can predict either \eqn{\theta}{theta} or the unconditional
canonical parameters \eqn{\varphi}{phi},
as selected by \code{model.type}.
Similarly, if \code{object$type == "unconditional"},
so \eqn{\varphi = M \beta}{phi = M beta}, one can predict either
\eqn{\theta}{theta} or \eqn{\varphi}{phi}
as selected by \code{model.type}.

The specification of the prediction model is confusing because there
are so many possibilities.  First the \dQuote{usual} case.
The fit was done using a formula, found in \code{object$formula}.
A data frame \code{newdata} that has the same variables as \code{object$data},
the data frame used in the fit, but may have different rows (representing
hypothetical individuals) is supplied.
But \code{newdata} must specify \emph{all nodes}
of the graphical model for each (hypothetical, new) individual,
just like \code{object$data} did for real observed individuals.
Hence \code{newdata} is typically constructed using \code{\link{reshape}}.
See also the details section of \code{\link{aster}}.

In this \dQuote{usual} case we need \code{varvar} and \code{idvar} to
tell us what rows of \code{newdata} correspond to which individuals and
nodes (the same role they played in the original fit by \code{\link{aster}}).
If we are predicting canonical parameters, then we do not need \code{root} or
\code{x}.
If we are predicting unconditional mean value parameters, then
we also need \code{root} but not \code{x}.
If we are predicting conditional mean value parameters, then
we also need both \code{root} and \code{x}.
In the \dQuote{usual} case, these are found in \code{newdata} and
not supplied as arguments to \code{predict}.  Moreover, \code{x}
is not named \code{"x"} but is the response in \code{out$formula}.

The next case, \code{predict(object)} with no other arguments,
is often used with linear models (\code{\link{predict.lm}}),
but we expect will be little used for aster models.  As for linear
models, this \dQuote{predicts} the observed data.  In this case
\code{modmat}, \code{x}, and \code{root} are found in \code{object}
and nothing is supplied as an argument to \code{predict.aster}, except
perhaps \code{amat} if one wants a function of predictions for the observed
data.

The final case, also perhaps little used, is a fail-safe mode for problems
in which the R formula language just cannot be bludgeoned into doing what
you want.  This is the same reason \code{\link{aster.default}} exists.
Then a model matrix can be constructed \dQuote{by hand}, and the function
\code{predict.aster} is used instead of \code{predict.aster.formula}.

Note that it is possible to use a \dQuote{constructed by hand}
model matrix even if \code{object} was produced by \code{\link{aster.formula}}.
Simply explicitly call \code{predict.aster} rather than \code{predict}
to override the R method dispatch (which would
call \code{predict.aster.formula} in this case).
}
\value{
  If \code{se.fit = FALSE}, a vector of predictions.
  If \code{se.fit = TRUE}, a list with components
  \item{fit}{Predictions}
  \item{se.fit}{Estimated standard errors}
}
\keyword{models}
\keyword{regression}
