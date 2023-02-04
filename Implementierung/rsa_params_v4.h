#include "rsa_params_v1.h"

unsigned long carmichael(unsigned int p, unsigned int q);
void get_rsa_params_v4(unsigned long *e, unsigned long *d, unsigned long *N);