
mlogl <- function(parm, pred, fam, x, root, modmat, deriv = 0,
    type = c("unconditional", "conditional"))
{
    type <- match.arg(type)

    stopifnot(is.numeric(x))
    stopifnot(is.numeric(root))
    stopifnot(is.numeric(modmat))
    stopifnot(is.numeric(parm))
    stopifnot(is.numeric(pred))
    stopifnot(is.numeric(fam))
    stopifnot(is.numeric(deriv))

    stopifnot(all(pred == as.integer(pred)))
    stopifnot(all(fam == as.integer(fam)))
    stopifnot(all(deriv == as.integer(deriv)))

    stopifnot(is.element(fam, seq(along = families())))
    stopifnot(all(pred < seq(along = pred)))
    stopifnot(is.element(deriv, 0:2))
    stopifnot(length(deriv) == 1)

    ncoef <- length(parm)
    nnode <- length(pred)

    foo <- dim(modmat)
    if (ncoef != foo[length(foo)])
        stop("last dimension of modmat not length(parm)")
    if (length(x) != prod(foo[- length(foo)]))
        stop("product of all but last dimension of modmat not length(x)")
    stopifnot(length(x) == length(root))
    stopifnot(length(pred) == length(fam))

    nind <- length(x) / nnode
    if(nind != as.integer(nind))
        stop("length(x) not multiple of length(pred)")

    if (type == "unconditional") {
        out <- .C("aster_mlogl_unco",
            nind = as.integer(nind),
            nnode = as.integer(nnode),
            ncoef = as.integer(ncoef),
            pred = as.integer(pred),
            fam = as.integer(fam),
            deriv = as.integer(deriv),
            beta = as.double(parm),
            root = as.double(root),
            x = as.double(x),
            modmat = as.double(modmat),
            value = double(1),
            gradient = double(ncoef),
            hessian = matrix(as.double(0), ncoef, ncoef),
            PACKAGE = "aster")
    } else {
        out <- .C("aster_mlogl_cond",
            nind = as.integer(nind),
            nnode = as.integer(nnode),
            ncoef = as.integer(ncoef),
            pred = as.integer(pred),
            fam = as.integer(fam),
            deriv = as.integer(deriv),
            beta = as.double(parm),
            root = as.double(root),
            x = as.double(x),
            modmat = as.double(modmat),
            value = double(1),
            gradient = double(ncoef),
            hessian = matrix(as.double(0), ncoef, ncoef),
            PACKAGE = "aster")
    }

    if (deriv == 0)
        return(list(value = out$value))
    if (deriv == 1)
        return(list(value = out$value, gradient = out$gradient))
    if (deriv == 2)
        return(list(value = out$value, gradient = out$gradient,
            hessian = out$hessian))
}
