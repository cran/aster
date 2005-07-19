
rnzp <- function(n, mu, xpred = 1) {

    if (length(n) > 1)
        n <- length(n)
    stopifnot(n == as.integer(n))
    stopifnot(n > 0)

    stopifnot(is.numeric(xpred))
    stopifnot(length(xpred) > 0)
    stopifnot(all(xpred == as.integer(xpred)))

    stopifnot(is.numeric(mu))
    stopifnot(length(mu) > 0)
    stopifnot(all(mu > 0))

    .C("aster_rnzp",
        n = as.integer(n),
        lenxp = length(xpred),
        lenmu = length(mu),
        xpred = as.double(xpred),
        mu = as.double(mu),
        result = double(n), PACKAGE = "aster")$result
}

