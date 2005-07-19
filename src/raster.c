
#include <stdio.h>
#include <stdlib.h>
#include <R.h>
#include <Rmath.h>
#include <Rinternals.h>
#include "aster.h"
#include "raster.h"
#include "rraster.h"

#define BUFSIZE 1024

void die(const char *format, ...)
{
    char buf[BUFSIZE];
    va_list arg;

    va_start(arg, format);
    vsnprintf(buf, BUFSIZE, format, arg);
    va_end(arg);
    buf[BUFSIZE - 1] = '\0';
    error(buf);
    exit(1); /* never get here, just to shut up gcc -Wall -W */
}

SEXP aster_families(void)
{
    SEXP result;
    int nfam = 0;
    int i;

    for (i = 0; ; ++i) {
        /* family index is 1-origin */
        char *name = aster_family_name(i + 1);
        if (name == NULL)
            break;
        else
            ++nfam;
    }

    PROTECT(result = allocVector(STRSXP, nfam));
    for (i = 0; i < nfam; ++i)
        /* family index is 1-origin */
        SET_STRING_ELT(result, i, mkChar(aster_family_name(i + 1)));
    UNPROTECT(1);
    return result;
}

double my_expm1(double x)
{
    return expm1(x);
}

double my_log1p(double x)
{
    return log1p(x);
}

double my_round(double x)
{
    return rint(x);
}

double my_rbinom(double n, double p)
{
    return rbinom(n, p);
}

double my_rpois(double mu)
{
    return rpois(mu);
}

double my_rnzp(double mu)
{
    if (mu <= 0.0)
        die("non-positive mu in non-zero-poisson simulator\n");
    if (mu >= 1.0) {
        /* case 1 in sim.Rnw write-up */
        for (;;) {
            double x = rpois(mu);
            if (x >= 1.0)
                return x;
        }
    } else /* mu < 1.0 */ {
        /* case 2 in sim.Rnw write-up */
        double tau;
        if (1.0 - mu == 1.0)
            return 1.0;
        tau = mu / (- my_expm1(- mu));
        for (;;) {
            double x = rpois(mu) + 1.0;
            double u = unif_rand();
            if (u < 1.0 / x)
                return x;
        }
    }
}

void aster_rnzp(int *nin, int *len_xpred_in, int *len_mu_in,
    double *xpred, double *mu, double *result)
{
    int n = nin[0];
    int len_xpred = len_xpred_in[0];
    int len_mu = len_mu_in[0];
    int i, j;

    GetRNGstate();
    for (i = 0; i < n; ++i) {
        double foo = xpred[i % len_xpred];
        double bar = 0.0;
        double qux = mu[i % len_mu];
        for (j = 0; j < foo; ++j)
            bar += my_rnzp(qux);
        result[i] = bar;
    }
    PutRNGstate();
}

void my_GetRNGstate(void)
{
    GetRNGstate();
}

void my_PutRNGstate(void)
{
    PutRNGstate();
}

void *my_malloc(size_t size)
{
    void *foo = malloc(size);
    if (foo == NULL)
        die("malloc returned null\n");
    return foo;
}

void my_free(void *ptr)
{
    free(ptr);
}
