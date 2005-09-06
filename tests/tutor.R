
 library(aster)

 data(echinacea)
 names(echinacea)
 sapply(echinacea, class)

 vars <- c("ld02", "ld03", "ld04", "fl02", "fl03", "fl04",
     "hdct02", "hdct03", "hdct04")
 redata <- reshape(echinacea, varying = list(vars),
      direction = "long", timevar = "varb", times = as.factor(vars),
      v.names = "resp")
 names(redata)

 redata <- data.frame(redata, root = 1)
 names(redata)

 pred <- c(0, 1, 2, 1, 2, 3, 4, 5, 6)
 fam <- c(1, 1, 1, 1, 1, 1, 3, 3, 3)

 hdct <- grep("hdct", as.character(redata$varb))
 hdct <- is.element(seq(along = redata$varb), hdct)
 redata <- data.frame(redata, hdct = as.integer(hdct))
 names(redata)

###################################################
### chunk number 16: fit-4
###################################################
 aout4 <- aster(resp ~ varb + nsloc + ewloc + pop * hdct - pop,
     pred, fam, varb, id, root, data = redata)
 summary(aout4, show.graph = TRUE)


###################################################
### chunk number 18: conf-level
###################################################
 conf.level <- 0.95
 crit <- qnorm((1 + conf.level) / 2)


###################################################
### chunk number 22: predict-newdata
###################################################
 newdata <- data.frame(pop = levels(echinacea$pop))
 for (v in vars)
     newdata[[v]] <- 1
 newdata$root <- 1
 newdata$ewloc <- 0
 newdata$nsloc <- 0


###################################################
### chunk number 23: predict-newdata-reshape
###################################################
 renewdata <- reshape(newdata, varying = list(vars),
      direction = "long", timevar = "varb", times = as.factor(vars),
      v.names = "resp")
 hdct <- grep("hdct", as.character(renewdata$varb))
 hdct <- is.element(seq(along = renewdata$varb), hdct)
 renewdata <- data.frame(renewdata, hdct = as.integer(hdct))
 names(redata)
 names(renewdata)


###################################################
### chunk number 24: make-amat
###################################################
 nind <- nrow(newdata)
 nnode <- length(vars)
 amat <- array(0, c(nind, nnode, nind))
 for (i in 1:nind)
     amat[i , grep("hdct", vars), i] <- 1


###################################################
### chunk number 30: tau-4-amat
###################################################
 pout4 <- predict(aout4, varvar = varb, idvar = id, root = root,
     newdata = renewdata, se.fit = TRUE, amat = amat)


###################################################
### chunk number 36: make-theta
###################################################
 theta.hat <- predict(aout4, model.type = "cond", parm.type = "canon")
 theta.hat <- matrix(theta.hat, nrow = nrow(aout4$x), ncol = ncol(aout4$x))
 fit.hat <- pout4$fit
 beta.hat <- aout4$coefficients


###################################################
### chunk number 37: make-root-etc
###################################################
 root <- aout4$root
 modmat <- aout4$modmat
 modmat.pred <- pout4$modmat
 x.pred <- matrix(1, nrow = dim(modmat.pred)[1], ncol = dim(modmat.pred)[2])
 root.pred <- x.pred


###################################################
### save and restore
###################################################

 quux <- list(fit.hat = fit.hat, theta.hat = theta.hat,
     pred.orig = pred, fam.orig = fam, root.orig = root,
     modmat.orig = modmat, beta.hat = beta.hat,
     x.pred = x.pred, root.pred = root.pred, modmat.pred = modmat.pred,
     amat.orig = amat, crit.orig = crit)
 save(quux, file = "tutor.save.bork.bork.bork.RData")
 rm(list = ls(all.names = TRUE))
 load(file = "tutor.save.bork.bork.bork.RData")
 unlink("tutor.save.bork.bork.bork.RData")
 attach(quux)
 ls(pos = 2)

###################################################
### chunk number 38: doit
###################################################

 set.seed(42)
 nboot <- 5
 cover <- matrix(0, nboot, length(fit.hat))
 for (iboot in 1:nboot) {
     xstar <- raster(theta.hat, pred.orig, fam.orig, root.orig)
     aout4star <- aster(xstar, root.orig, pred.orig, fam.orig,
         modmat.orig, beta.hat, check.analyticals = FALSE)
     pout4star <- predict(aout4star, x.pred, root.pred, modmat.pred,
         amat.orig, se.fit = TRUE)
     upper <- pout4star$fit + crit.orig * pout4star$se.fit
     lower <- pout4star$fit - crit.orig * pout4star$se.fit
     cover[iboot, ] <- as.numeric(lower <= fit.hat & fit.hat <= upper)
 }
 pboot <- apply(cover, 2, mean)
 pboot.se <- sqrt(pboot * (1 - pboot) / nboot)
 print(cbind(pboot, pboot.se))


###################################################
### chunk number 38: doit (again)
###################################################

 set.seed(42)
 nboot <- 5
 cover <- matrix(0, nboot, length(fit.hat))
 for (iboot in 1:nboot) {
     xstar <- raster(theta.hat, pred.orig, fam.orig, root.orig)
     aout4star <- aster(xstar, root.orig, pred.orig, fam.orig,
         modmat.orig, beta.hat, method = "CG")
     pout4star <- predict(aout4star, x.pred, root.pred, modmat.pred,
         amat.orig, se.fit = TRUE)
     upper <- pout4star$fit + crit.orig * pout4star$se.fit
     lower <- pout4star$fit - crit.orig * pout4star$se.fit
     cover[iboot, ] <- as.numeric(lower <= fit.hat & fit.hat <= upper)
 }
 pboot <- apply(cover, 2, mean)
 pboot.se <- sqrt(pboot * (1 - pboot) / nboot)
 print(cbind(pboot, pboot.se))


###################################################
### chunk number 38: doit (yet again)
###################################################

 set.seed(42)
 nboot <- 5
 cover <- matrix(0, nboot, length(fit.hat))
 for (iboot in 1:nboot) {
     xstar <- raster(theta.hat, pred.orig, fam.orig, root.orig)
     aout4star <- aster(xstar, root.orig, pred.orig, fam.orig,
         modmat.orig, beta.hat, method = "L-B")
     pout4star <- predict(aout4star, x.pred, root.pred, modmat.pred,
         amat.orig, se.fit = TRUE)
     upper <- pout4star$fit + crit.orig * pout4star$se.fit
     lower <- pout4star$fit - crit.orig * pout4star$se.fit
     cover[iboot, ] <- as.numeric(lower <= fit.hat & fit.hat <= upper)
 }
 pboot <- apply(cover, 2, mean)
 pboot.se <- sqrt(pboot * (1 - pboot) / nboot)
 print(cbind(pboot, pboot.se))


