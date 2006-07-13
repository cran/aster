
#include <math.h>
#include <stddef.h>
#include "aster.h"
#include "raster.h"

static int bernoulli_validate(double x, double xpred)
{
    int foo = 1;
    foo = foo && (xpred == my_round(xpred));
    foo = foo && (x == my_round(x));
    foo = foo && (xpred >= 0.0);
    foo = foo && (x >= 0.0);
    foo = foo && (x <= xpred);
    return foo;
}

static double bernoulli(int deriv, double theta)
{
    double foo, bar;

    switch (deriv) {
    case 0:
        if (theta <= 0)
            return my_log1p(exp(theta));
        else
            return theta + my_log1p(exp(- theta));
    case 1:
        return 1.0 / (1.0 + exp(- theta));
    case 2:
        theta = fabs(theta);
        foo = exp(- theta);
        bar = 1.0 + foo;
        return (foo / bar) / bar;
    default:
        die("deriv %d not valid", deriv);
    }
}

static double bernoulli_simulate(double xpred, double theta)
{
    if (xpred == 0.0) {
        return 0.0;
    } else {
        double p = 1.0 / (1.0 + exp(- theta));
        return my_rbinom(xpred, p);
    }
}

static int poisson_validate(double x, double xpred)
{
    int foo = 1;
    foo = foo && (xpred == my_round(xpred));
    foo = foo && (x == my_round(x));
    foo = foo && (xpred >= 0.0);
    foo = foo && (x >= 0.0);
    foo = foo && (xpred > 0.0 || x == 0.0);
    return foo;
}

static double poisson(int deriv, double theta)
{
    switch (deriv) {
    case 0:
    case 1:
    case 2:
        return exp(theta);
    default:
        die("deriv %d not valid", deriv);
    }
}

static double poisson_simulate(double xpred, double theta)
{
    double mu = xpred * exp(theta);
    if (mu == 0.0)
        return 0.0;
    return my_rpois(mu);
}

static int non_zero_poisson_validate(double x, double xpred)
{
    int foo = 1;
    foo = foo && (xpred == my_round(xpred));
    foo = foo && (x == my_round(x));
    foo = foo && (xpred >= 0.0);
    foo = foo && (x >= 0.0);
    foo = foo && (xpred > 0.0 || x == 0.0);
    foo = foo && (xpred == 0.0 || x > 0.0);
    return foo;
}

static double non_zero_poisson(int deriv, double theta)
{
    double mu = exp(theta);
    double tau;
    if (1.0 - mu == 1.0)
        tau = 1.0;
    else
        tau = mu / (- my_expm1(- mu));
    switch (deriv) {
    case 0:
        return mu + my_log1p(- exp(- mu));
    case 1:
        return tau;
    case 2:
        return tau * (1.0 - tau * exp(- mu));
    default:
        die("deriv %d not valid", deriv);
    }
}

static double non_zero_poisson_simulate(double xpred, double theta)
{
    double mu = exp(theta);
    double result = 0.0;
    int i;

    for (i = 0; i < xpred; ++i)
        result += my_rnzp(mu);
    return result;
}

static int two_trunc_poisson_validate(double x, double xpred)
{
    int foo = 1;
    foo = foo && (xpred == my_round(xpred));
    foo = foo && (x == my_round(x));
    foo = foo && (xpred >= 0.0);
    foo = foo && (x >= 0.0);
    foo = foo && (xpred > 0.0 || x == 0.0);
    foo = foo && (xpred == 0.0 || x > 2.0);
    return foo;
}

static double two_trunc_poisson(int deriv, double theta)
{
    int k = 2;
    double mu = exp(theta);
    double foo, bar, baz, qux, alpha;

    switch (deriv) {
    case 0:
        return mu + my_ppois(k, mu, 0, 1);
    case 1:
        foo = my_ppois(k + 1, mu, 0, 0);
        if (foo == 0.0) {
            return mu + k + 1;
        } else {
            bar = my_dpois(k + 1, mu, 0);
            return mu + (k + 1) / (1.0 + foo / bar);
        }
    case 2:
        foo = my_ppois(k + 1, mu, 0, 0);
        if (foo == 0.0) {
            qux = 0.0;
        } else {
            bar = my_dpois(k + 1, mu, 0);
            qux = foo / bar;
        }
        alpha = (k + 1) / (1.0 + qux);
        if (qux < 1.0) {
            baz = qux / (1.0 + qux);
        } else {
            baz = 1.0 / (1.0 / qux + 1.0);
        }
        return mu * (1.0 - alpha * (1.0 - (k + 1) * baz / mu));
    default:
        die("deriv %d not valid", deriv);
    }
}

static double two_trunc_poisson_simulate(double xpred, double theta)
{
    double mu = exp(theta);
    double result = 0.0;
    int i;

    for (i = 0; i < xpred; ++i)
        result += my_rktp(2, mu);
    return result;
}

typedef double (*famfun_ptr)(int deriv, double theta);
typedef int (*famval_ptr)(double x, double xpred);
typedef double (*famsim_ptr)(double xpred, double theta);

struct funtab {
    char *name;
    famfun_ptr fun;
    famval_ptr validate;
    famsim_ptr simulate;
};

static struct funtab myfuntab[] =
{
    {"bernoulli", bernoulli, bernoulli_validate, bernoulli_simulate},
    {"poisson", poisson, poisson_validate, poisson_simulate},
    {"non.zero.poisson", non_zero_poisson, non_zero_poisson_validate,
        non_zero_poisson_simulate},
    {"two.trunc.poisson", two_trunc_poisson, two_trunc_poisson_validate,
        two_trunc_poisson_simulate},
    {NULL, NULL, NULL, NULL},
};

void aster_family(int *famin, int *derivin, double *thetain, double *value)
{
    int fam = famin[0];
    int deriv = derivin[0];
    double theta = thetain[0];

    int i;
    for (i = 0; myfuntab[i].fun != NULL; ++i)
        if (i == (fam - 1)) /* fam is 1-origin index */ {
            value[0] = myfuntab[i].fun(deriv, theta);
            return;
        }
    die("family %d not valid", fam);
}

int aster_family_validate(int fam, double x, double xpred)
{
    int i;
    for (i = 0; myfuntab[i].validate != NULL; ++i)
        if (i == (fam - 1)) /* fam is 1-origin index */
            return myfuntab[i].validate(x, xpred);
    die("family %d not valid", fam);
}

char *aster_family_name(int fam)
{
    int i;
    for (i = 0; myfuntab[i].name != NULL; ++i)
        if (i == (fam - 1)) /* fam is 1-origin index */
            return myfuntab[i].name;
    return NULL;
}

double aster_family_simulate(int fam, double xpred, double theta)
{
    int i;
    for (i = 0; myfuntab[i].simulate != NULL; ++i)
        if (i == (fam - 1)) /* fam is 1-origin index */
            return myfuntab[i].simulate(xpred, theta);
    die("family %d not valid", fam);
}

