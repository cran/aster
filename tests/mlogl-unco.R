
 library(aster)

 set.seed(42)
 nind <- 25
 nnode <- 5
 ncoef <- nnode + 1

 famnam <- families()
 fam <- c(1, 1, 2, 3, 3)
 print(famnam[fam])

 pred <- c(0, 1, 1, 2, 3)
 print(pred)

 modmat <- array(0, c(nind, nnode, ncoef))
 modmat[ , , 1] <- 1
 for (i in 2:nnode)
     modmat[ , i, i] <- 1
 modmat[ , , ncoef] <- rnorm(nind * nnode)

 beta <- rnorm(ncoef) / 10

 phi <- matrix(modmat, ncol = ncoef) %*% beta
 phi <- matrix(phi, ncol = nnode)

 theta <- .C("aster_phi2theta",
     nind = as.integer(nind),
     nnode = as.integer(nnode),
     pred = as.integer(pred),
     fam = as.integer(fam),
     phi = as.double(phi),
     theta = matrix(as.double(0), nind, nnode))$theta

 root <- sample(1:3, nind * nnode, replace = TRUE)
 root <- matrix(root, nind, nnode)

 x <- raster(theta, pred, fam, root)
 
 out <- mlogl(beta, pred, fam, x, root, modmat, deriv = 2,
     type = "unco")
 print(out)

 my.value <- 0
 for (j in 1:nnode) {
     k <- pred[j]
     if (k > 0)
         xpred <- x[ , k]
     else
         xpred <- root[ , j]
     for (i in 1:nind)
         my.value <- my.value -
             sum(x[i, j] * theta[i, j] -
             xpred[i] * famfun(fam[j], 0, theta[i, j]))
 }
 all.equal(out$value, my.value)

 my.grad <- NaN * out$gradient
 epsilon <- 1e-9
 for (i in 1:ncoef) {
     beta.eps <- beta
     beta.eps[i] <- beta[i] + epsilon
     out.eps <- mlogl(beta.eps, pred, fam, x, root, modmat, deriv = 0,
         type = "unco")
     my.grad[i] <- (out.eps$value - out$value) / epsilon
 }

 all.equal(out$gradient, my.grad, tolerance = sqrt(epsilon))

 ##########

 objfun <- function(beta) {
     out <- mlogl(beta, pred, fam, x, root, modmat, deriv = 1,
         type = "unco")
     result <- out$value
     attr(result, "gradient") <- out$gradient
     return(result)
 }
 nout <- nlm(objfun, beta, fscale = nind)
 print(nout)
 nout <- nlm(objfun, nout$estimate, fscale = nind)
 print(nout)

 ##########

 my.hess <- matrix(NaN, ncoef, ncoef)
 for (i in 1:ncoef) {
     beta.eps <- beta
     beta.eps[i] <- beta[i] + epsilon
     out.eps <- mlogl(beta.eps, pred, fam, x, root, modmat, deriv = 1,
         type = "unco")
     my.hess[ , i] <- (out.eps$gradient - out$gradient) / epsilon
 }

 all.equal(out$hessian, my.hess, tolerance = sqrt(epsilon))

 ##########

 objfun <- function(beta) {
     out <- mlogl(beta, pred, fam, x, root, modmat, deriv = 2,
         type = "unco")
     result <- out$value
     attr(result, "gradient") <- out$gradient
     attr(result, "hessian") <- out$hessian
     return(result)
 }
 nout <- try(nlm(objfun, beta, fscale = nind))
 print(nout)
 nout <- nlm(objfun, nout$estimate, fscale = nind, iterlim = 1000)
 print(nout)

 ##########

 objfun <- function(beta)
     mlogl(beta, pred, fam, x, root, modmat, deriv = 0, type = "unco")$value
 gradfun <- function(beta)
     mlogl(beta, pred, fam, x, root, modmat, deriv = 1, type = "unco")$gradient
 oout <- optim(beta, objfun, gradfun, method = "L-BFGS-B")
 print(oout)

