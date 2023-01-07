#include "prime_generator.h"

void generate_primes(unsigned long *p, unsigned long *q){
    uint64_t prand;
    uint64_t qrand;
    do{
        uint64_t r1 = (uint64_t) arc4random();
        uint64_t r2 = (uint64_t) arc4random();
        prand = r1 << 32 | r2;
    } while(is_prime(prand) == 0);

    uint64_t max = UINT64_MAX / prand;

    do{
        uint64_t r1 = (uint64_t) arc4random();
        uint64_t r2 = (uint64_t) arc4random();
        qrand = r1 << 32 | r2;
    } while(qrand <= max && is_prime(qrand) == 0);

    *p = prand;
    *q = qrand;
}

int is_prime(unsigned long n){
    if (n <= 1) return 0;
    for (unsigned long i = 2; i <= sqrt(n); i++) {
        if (n % i == 0) return 0;
    }
    return 1;
}