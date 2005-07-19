
 library(aster)

 set.seed(42)

 nind <- 25

 vars <- c("l2", "l3", "f2", "f3", "h2", "h3")
 pred <- c(0, 1, 1, 2, 3, 4)
 fam <- c(1, 1, 1, 1, 3, 3)
 length(pred) == length(fam)
 nnode <- length(pred)

 famnam <- families()
 print(famnam[fam])

 theta <- matrix(0, nind, nnode)
 root <- matrix(1, nind, nnode)
 x <- raster(theta, pred, fam, root)
 dimnames(x) <- list(NULL, vars)

 data <- as.data.frame(x)
 site <- factor(sample(LETTERS[1:4], nind, replace = TRUE))
 foo <- rnorm(nind)
 data <- data.frame(x, site = site, foo = foo, root = 1)

 redata <- reshape(data, varying = list(vars),
     direction = "long", timevar = "varb", times = as.factor(vars),
     v.names = "resp")

 out <- aster(resp ~ foo + site, pred, fam, varb, id, root, data = redata)
 summary(out, show.graph = TRUE)

 out <- aster(resp ~ foo + site + varb, pred, fam, varb, id, root,
     data = redata)
 summary(out)

