
#ifndef ASTER_R_ASTER_H
#define ASTER_R_ASTER_H

#include <stdarg.h>
#include <stdlib.h>

#ifndef __GNUC__
void die(const char *format, ...);
#else
void die(const char *format, ...) __attribute__ ((__noreturn__));
#endif /* __GNUC__ */

double my_expm1(double x);

double my_log1p(double x);

double my_round(double x);

double my_rbinom(double n, double p);

double my_rpois(double mu);

double my_ppois(double x, double lambda, int lower_tail, int log_p);

double my_dpois(double x, double lambda, int give_log);

double my_rnzp(double mu);

double my_rktp(int k, double mu);

void my_GetRNGstate(void);

void my_PutRNGstate(void);

void *my_malloc(size_t size);

void my_free(void *ptr);

#endif /* ASTER_R_ASTER_H */

