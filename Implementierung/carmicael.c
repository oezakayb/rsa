#include "carmicael.h"

int carmicael(unsigned long n) {
    int k;
    for (int i = 2; i < n; i++) {
        if (gcd(i, n) == 1) {
            int j = 1;
            while ((pow(i, j) % n) != 1) {
                j++;
            }
            if (j < k) {
                k = j;
            }
        }
    }
    return k;
}

long gcd(unsigned long a, unsigned long b) {
    if(b == 0){
        return a;
    }

    return gcd(b, a%b);
}
