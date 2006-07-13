
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

double my_ppois(double x, double lambda, int lower_tail, int log_p)
{
    return ppois(x, lambda, lower_tail, log_p);
}

double my_dpois(double x, double lambda, int give_log)
{
    return dpois(x, lambda, give_log);
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

double my_rktp(int k, double mu)
{
    int m;
    double mdoub;

    if (mu <= 0.0)
        die("non-positive mu in k-truncated-poisson simulator\n");
    if (k <= 0)
        die("negative k in k-truncated-poisson simulator\n");

    mdoub = k + 1 - mu;
    if (mdoub < 0.0)
        mdoub = 0.0;
    m = mdoub;
    if (m < mdoub)
        m = m + 1;
    /* since mu > 0.0 we have 0.0 <= mdoub < k + 1 hence 0 <= m <= k + 1 */

    for (;;) {
        double x = rpois(mu) + m;
        double u = unif_rand();
        double a = 1.0;
        int j;
        for (j = 0; j < m; ++j)
            a *= (k + 1 - j) / (x - j);
        if (u < a && x > k)
            return x;
    }
}

void aster_rktp(int *nin, int *len_xpred_in, int *len_mu_in, int *len_k_in,
    double *xpred_in, double *mu_in, int *k_in, double *result)
{
    int n = nin[0];
    int len_xpred = len_xpred_in[0];
    int len_mu = len_mu_in[0];
    int len_k = len_k_in[0];
    int i, j;

    GetRNGstate();
    for (i = 0; i < n; ++i) {
        double xpred = xpred_in[i % len_xpred];
        double mu = mu_in[i % len_mu];
        int k = k_in[i % len_k];
        double foo = 0.0;
        for (j = 0; j < xpred; ++j)
            foo += my_rktp(k, mu);
        result[i] = foo;
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

