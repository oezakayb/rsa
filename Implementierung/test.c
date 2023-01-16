#include <stdio.h>
#include <stdlib.h>

int carmicael(int number);
int gcd(int a);

int main(int argc, char** argv)
{
    int result = carmicael(atoi(argv[1]));
    printf("%d\n", result);
    return 0;
}
