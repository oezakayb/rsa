#include "rsa_params_v2.h"

unsigned int find_prime_sqrt(unsigned int n, unsigned int* seed){
    if (n <= 1) return find_prime_sqrt(random32bit(seed), seed);
    if (n <= 3) return n;
    if (n % 2 == 0) return find_prime_sqrt(n/2, seed);
    if (n % 3 == 0) return find_prime_sqrt(n/3, seed);
    unsigned int sqr = (unsigned int)sqrt((double)n);

    for (unsigned int i = 5; i <= sqr; i += 4) {
        if (n % i == 0) return find_prime_sqrt(n/i, seed);
        i += 2;
        if (n % i == 0) return find_prime_sqrt(n/i, seed);
    }
    return n;
}

void get_rsa_params_v2(unsigned long *e, unsigned long *d, unsigned long *N, unsigned int* seed){
    unsigned int p = find_prime_sqrt(random32bit(seed), seed);
    unsigned int q = find_prime_sqrt(random32bit(seed), seed);
    *N = (unsigned long) p * (unsigned long) q;
    unsigned long phiN = (unsigned long) (p - 1) * (unsigned long) (q - 1);
    *e = calculateE(phiN);
    signed long *t = malloc(sizeof *t);
    signed long *s = malloc(sizeof *s);

    if(t == NULL || s == NULL){
        printf("No memory!\n");
        *d=0;
        return;
    }
    compute_d(phiN, *e, s, t);
    *d = *t;
    free(t);
    free(s);
}