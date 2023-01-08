#include "Carmichael_Function"
#include <stdio.h>
#include <math.h>

long gcd(unsigned long a, unsigned long b) {
    for (i = 1; i <= n1 && i <= n2; ++i)
    {
        // Checks if i is factor of both integers
        if (n1 % i == 0 && n2 % i == 0)
        return i;
    }
    return 0;
}
long is_gcd(unsigned long a, unsigned long b) {
    for (i = 1; i <= n1 && i <= n2; ++i)
    {
        // Checks if i is factor of both integers
        if (n1 % i == 0 && n2 % i == 0)
            return 1;
    }
    return 0;
}
 int Carmichael_Function(unsigned long n) {
     int k;
     int x;
     int coprimes[];
     int counter = 0;

     //find all coprimes of n
     for (x = 1; x < n; x++) {
         if (is_gcd(x, n) == 1)
         {
             coprimes[counter] = x;
             counter++;
         } 
     }
     k = 1;
     int length = sizeof(counter) / 4;
    
     bool done = false;
     while (true) {
         for (int u = 0; u < length; u++) {
             if (pow(coprimes[u], k) % n == 1) {
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
    
        
     return k;

}


