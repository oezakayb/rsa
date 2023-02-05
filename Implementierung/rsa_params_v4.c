#include "rsa_params_v4.h"

void get_rsa_params_v4(unsigned long *e, unsigned long *d, unsigned long *N, unsigned int* seed){
    unsigned int p = find_prime(random32bit(seed), seed);
    unsigned int q = find_prime(random32bit(seed), seed);
    *N = (unsigned long) p * (unsigned long) q;
    unsigned long lambdaN = (p - 1) * (q - 1) / gcd(p - 1, q - 1);
    *e = calculateE(lambdaN);
    signed long *t = malloc(sizeof *t);
    signed long *s = malloc(sizeof *s);

    if(t == NULL || s == NULL){
        printf("No memory!\n");
        *d=0;
        return;
    }
    compute_d(lambdaN, *e, s, t);
    *d = *t;
    free(t);
    free(s);
}
