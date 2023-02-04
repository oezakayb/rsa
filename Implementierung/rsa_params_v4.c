#include "rsa_params_v4.h"

unsigned long carmichael(unsigned int p, unsigned int q) {
    return (p - 1) * (q - 1) / gcd(p - 1, q - 1);
}

void get_rsa_params_v4(unsigned long *e, unsigned long *d, unsigned long *N){

}

