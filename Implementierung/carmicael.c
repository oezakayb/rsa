#include "carmicael.h"


long gcd(unsigned long a, unsigned long b) {
    if (b == 0) {
        return a;
    }

    return gcd(b, a % b);
}

int carmicael(int n) {
    if (n == 1|| n == 2) {
        return 1;
    }
        int k = 1;
        for (int i = 2; i < n; i++) {
            if (gcd(i, n) == 1) {
                int x = i;
                int j = 1;
                while (x != 1) {
                    x = (x * i) % n;
                    j++;
                }
                k = (k*j)/gcd(k,j);
            }
        }
        return k;
}


