#include <math.h>
#include "rsa_params_v1.h"

unsigned int find_prime_sqrt(unsigned int n, unsigned int* seed);
void get_rsa_params_v2(unsigned long *e, unsigned long *d, unsigned long *N,  unsigned int* seed);