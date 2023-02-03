#include "rsa_params_v3.h"

unsigned int gcd(unsigned int a, unsigned int b) {
    if (b == 0) {
        return a;
    }

    return gcd(b, a % b);
}

unsigned long carmichael(unsigned int p, unsigned int q) {
    return (p - 1) * (q - 1) / gcd(p - 1, q - 1);
}


