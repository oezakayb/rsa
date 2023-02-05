#include "rsa_params_v6.h"

unsigned int find_prime_2(unsigned int n){
    if (n <= 1) return 0;
    if (n <= 3) return n;
    if (n % 2 == 0) return find_prime_2(n/2);
    if (n % 3 == 0) return find_prime_2(n/3);
    //unsigned int sqr = sqrt(n);
    for (int i = 5; i < 23 ; i += 4) {
        if (n % i == 0) return find_prime_2(n/i);
        i += 2;
        if (n % i == 0) return find_prime_2(n/i);
    }
    for (unsigned int i = 5; i*i <= n; i += 4) {
        if (n % i == 0) return find_prime_2(n/i);
        i += 2;
        if (n % i == 0) return find_prime_2(n/i);
    }
    return n;
}

void get_rsa_params_v6(unsigned long *e, unsigned long *d, unsigned long *N){
    unsigned int p = find_prime_2(0xfffffffe);
    unsigned int q = find_prime_2(0xfffffffd);
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