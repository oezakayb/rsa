#include "rsa_params_v1.h"

unsigned int mul = 1664525;
unsigned int inc = 1013904223;

unsigned long gcd(unsigned long a, unsigned long b) {
    if (b == 0) {
        return a;
    }

    if(b > a){
        gcd(b, a);
    }

    return gcd(b, a % b);
}

void compute_d(unsigned long N, unsigned long e, signed long* s, signed long* t) {
    if (e == 0) {
        *s = 1;
        *t = 0;
    } else {
        compute_d(e, N % e, s, t);
        signed long temp = *s;
        *s = *t;
        *t = temp - (N / e) * *t;
    }
}

unsigned int random32bit(unsigned int* seed){
    *seed = (*seed * mul + inc) % ((unsigned long)2 << 32);
    return *seed;
}

unsigned int find_prime(unsigned int n, unsigned int* seed){
    if (n <= 1) return find_prime(random32bit(seed), seed);
    if (n <= 3) return n;
    if (n % 2 == 0) return find_prime(n/2, seed);
    if (n % 3 == 0) return find_prime(n/3, seed);
    //unsigned int sqr = sqrt(n);
    for (int i = 5; i < 23 ; i += 4) {
        if (n % i == 0) return find_prime(n/i, seed);
        i += 2;
        if (n % i == 0) return find_prime(n/i, seed);
    }
    for (unsigned int i = 5; i*i <= n; i += 4) {
        if (n % i == 0) return find_prime(n/i, seed);
        i += 2;
        if (n % i == 0) return find_prime(n/i, seed);
    }
    return n;
}

unsigned long calculateE(unsigned long phiN){
    unsigned long e = 65537;
    if(phiN > 65537){
        while(gcd(phiN, e) != 1){
            e += 2;
        }
    }else{
        e = 3;
        while(gcd(phiN, e) != 1){
            e += 2;
        }
    }

    return e;
}

void get_rsa_params_v1(unsigned long *e, unsigned long *d, unsigned long *N, unsigned int* seed){
    unsigned int p = find_prime(random32bit(seed), seed);
    unsigned int q = find_prime(random32bit(seed), seed);
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