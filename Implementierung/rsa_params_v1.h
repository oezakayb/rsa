#include <stdio.h>
#include <stdlib.h>

unsigned long gcd(unsigned long a, unsigned long b);
void compute_d(unsigned long N, unsigned long e, signed long* s, signed long* t);
unsigned int random32bit(unsigned int* seed);
unsigned int find_prime(unsigned int n, unsigned int* seed);
unsigned long calculateE();
void get_rsa_params_v1(unsigned long *e, unsigned long *d, unsigned long *N, unsigned int* seed);