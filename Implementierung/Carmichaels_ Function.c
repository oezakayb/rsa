#include "Carmichael_Function"
#include <stdio.h>
#include <math.h>

long gcd(unsigned long a, unsigned long b) {
    for (unsigned int i = 1; i <= a && i <= b; ++i)
    {
        // Checks if i is factor of both integers
        if (a % i == 0 && b % i == 0)
            return 1;
    }
    return 0;
}
int Carmichael_Function(unsigned long n) {
    int k;
    int* coprimes;
    //int coprimes[n];
    int counter = 0;
    int* ptr;
    ptr = (int*)malloc(sizeof(int) * n);
    if (ptr == NULL) {
        return 1;
    }


    //////////////////////////////////////////////////////////////////////////////
    //find all coprimes of n
    for (int x = 1; x < n; x++) {
        if (gcd(x, n) == 1)
        {
            //coprimes[counter] = x;
            //counter++;
            //coprimes = &x;
            //*(coprimes+1);
            //counter++

            ptr[counter] = x;
            counter++;
        }
    }

    k = 1;
    int length = sizeof(counter) / sizeof(int);

    /////////////////////////////////////////////////////////////////////////////


    bool done = false;
    while (true) {
        for (int u = 0; u < length; u++) {
            int temp = pow(ptr[u], k);
            int check = temp % n;
            if (check == 1) {
                done = true;
            }
            else {
                done = false;
                k += 1;
                break;
            }
        }
        if (done) break;
    }
    free(ptr);
    return k;

}
