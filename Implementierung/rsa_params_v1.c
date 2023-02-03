#include "rsa_params_v1.h"

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

void get_rsa_params_v1(unsigned long *e, unsigned long *d, unsigned long *N){

}