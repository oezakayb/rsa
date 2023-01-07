#include <stdio.h>
#include <stdlib.h>

int semiprime(int number);

int main(int argc, char** argv) {
        int isSemiprime = semiprime(atoi(argv[1]));
        printf("%d\n", isSemiprime);
        return 0;
}