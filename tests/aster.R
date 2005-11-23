
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
 
 out0 <- aster(x, root, pred, fam, modmat, type = "unco", method = "trust")
 out1 <- aster(x, root, pred, fam, modmat, type = "unco", method = "nlm")
 out2 <- aster(x, root, pred, fam, modmat, type = "unco", method = "CG")
 out3 <- aster(x, root, pred, fam, modmat, type = "unco", method = "L-B")

 all.equal(out0$coefficients, out1$coefficients)
 all.equal(out1$coefficients, out2$coefficients)
 all.equal(out2$coefficients, out3$coefficients)
 all.equal(out3$coefficients, out0$coefficients)

 print(out0$coefficients)

 out0 <- aster(x, root, pred, fam, modmat, type = "cond", method = "trust")
 out1 <- aster(x, root, pred, fam, modmat, type = "cond", method = "nlm")
 out2 <- aster(x, root, pred, fam, modmat, type = "cond", method = "CG")
 out3 <- aster(x, root, pred, fam, modmat, type = "cond", method = "L-B")

 all.equal(out0$coefficients, out1$coefficients)
 all.equal(out1$coefficients, out2$coefficients)
 all.equal(out2$coefficients, out3$coefficients)
 all.equal(out3$coefficients, out0$coefficients)

 print(out0$coefficients)

