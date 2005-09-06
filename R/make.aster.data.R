
make.aster.data <- function(data, vars, pred, pseudos, varvar = "varb",
    idvar = "id", respvar = "resp", rootvar = "root",
    varvals = as.factor(vars), idvals = 1:nrow(data),
    root.is.one = FALSE)
{
    return(structure(list(), class = "aster.data"))
}

