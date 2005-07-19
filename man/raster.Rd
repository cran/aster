\name{raster}
\alias{raster}
\title{Aster Model Simulation}
\description{
  Random generation of data for Aster models.
}
\usage{
raster(theta, pred, fam, root)
}
\arguments{
  \item{theta}{canonical parameter of the conditional model.
      A matrix, rows represent individuals and columns represent
      nodes in the graphical model.}
  \item{pred}{integer vector of length \code{ncol(theta)} determining
      the graph.  \code{pred[j]} is the index of the predecessor of
      the node with index \code{j} unless the predecessor is a root
      node, in which case \code{pred[j] == 0}.}
  \item{fam}{integer vector of length \code{ncol(theta)} determining
      the one-parameter exponential family associated with each node
      of the graph.  An integer vector of length \code{ncol(theta)}
      which is an index into the vector of family names returned by
      \code{\link{families}}.}
  \item{root}{A matrix of the same dimensions as \code{theta}.
      Data \code{root[i, j]} is the data for the founder that is
      the predecessor of the \code{[i, j]} node.}
}
\value{
  A matrix of the same dimensions as \code{theta}.  The random data
  for an aster model with the specified graph, parameters, and root
  data.
}
\seealso{\code{\link{aster}}}
\keyword{distribution}
