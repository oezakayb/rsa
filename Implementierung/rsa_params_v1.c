#include<math.h>

#include "rsa_params_v1.h"

unsigned int* seed = 0x12345678;
unsigned int mul = 1664525;
unsigned int inc = 1013904223;

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

unsigned int random32bit(){
    *seed = (*seed * mul + inc) % (2 << 32);
    return *seed;
}

unsigned int find_prime(unsigned long n){
    if (n <= 1) return find_prime(random32bit());
    if (n <= 3) return n;
    if (n % 2 == 0) return find_prime(n/2);
    if (n % 3 == 0) return find_prime(n/3);
    //unsigned int sqr = sqrt(n);
    for (int i = 5; i < 23 ; i += 4) {
        if (n % i == 0) return find_prime(n/i);
        i += 2;
        if (n % i == 0) return find_prime(n/i);
    }
    for (unsigned int i = 5; i*i <= n; i += 4) {
        if (n % i == 0) return find_prime(n/i);
        i += 2;
        if (n % i == 0) return find_prime(n/i);
    }
    return n;
}

void get_rsa_params_v1(unsigned long *e, unsigned long *d, unsigned long *N){
    unsigned int p = random32bit();
    if(is_prime(p) != 1) {

    }
}