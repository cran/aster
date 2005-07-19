famfun <- function(index, deriv, theta)
    .C("aster_family",
        index = as.integer(index),
        deriv = as.integer(deriv),
        theta = as.double(theta),
        value = double(1),
        PACKAGE = "aster")$value
