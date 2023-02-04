#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <getopt.h>
#include <time.h>

#include "rsa_params_v0.h"
#include "rsa_params_v1.h"
#include "rsa_params_v2.h"
#include "rsa_params_v3.h"


const char* usage_msg =
        "Usage: %s [options]   Prints out the public and private key pairs. Try -h to see the options\n"
        "   or: %s -h / --help   Show all options\n";

const char* help_msg =
        "  -V X   Runs the chosen version of implementation\n"
        "       V0: Assembler implementation (default)\n"
        "       V1: C implementation with improved RNG\n"
        "       V2: C implementation with basic RNG"
        "       V3: Assembler implementation with Carmichael instead of Extended-GCD\n"
        "       V4: C implementation implementation with Carmichael instead of Extended-GCD\n"
        "  -B X   The program will run for X times and the total and average runtime of the given version (if specified) of implementation will be measured\n"
        "       and printed\n"
        "  -h / --help   Show help message (this text) and exit\n";

void print_usage(const char* progname) {
    fprintf(stderr, usage_msg, progname, progname);
}

void print_help(const char* progname) {
    print_usage(progname);
    fprintf(stderr, "\n%s", help_msg);
}

int main(int argc, char** argv) {
    const char *progname = argv[0];

    int opt;
    int v = 0;
    int b;
    bool bbool = false;

    struct option long_options[] = {
            {"help", 0, NULL, 'h'},
            {0,      0, 0,    0}
    };

    while ((opt = getopt_long(argc, argv, "V:B:h", long_options, 0)) != -1) {
        switch (opt) {
            case 'V':
                v = atoi(optarg);
                break;
            case 'B':
                bbool = true;
                b = atoi(optarg);
                if (b == 0) {
                    fprintf(stderr, "Argument of B is 0 or not an integer.\n");
                    print_usage(progname);
                    return EXIT_FAILURE;
                }
                break;
            case 'h':
                print_help(progname);
                return EXIT_SUCCESS;
            default:
                print_usage(progname);
                return EXIT_FAILURE;
        }
    }

    unsigned long *e = malloc(sizeof * e);
    unsigned long *d = malloc(sizeof * d);
    unsigned long *N = malloc(sizeof * N);

    if(bbool){
        switch(v) {
            case 1:
                {
                    struct timespec start;
                    clock_gettime(CLOCK_MONOTONIC, &start);
                    for (int i = 0; i < b; ++i) {
                        get_rsa_params_v1(e, d, N);
                    }
                    struct timespec end;
                    clock_gettime(CLOCK_MONOTONIC, &end);
                    double time = end.tv_sec - start.tv_sec + 1e-9 * (end.tv_nsec - start.tv_nsec);
                    double average = time / b;
                    printf("It took a total of %lf seconds to generate the keys for %d times with an average of %lf.",
                           time, b, average);
                }

                    break;

            case 2:
                {
                    struct timespec start;
                    clock_gettime(CLOCK_MONOTONIC, &start);
                    for (int i = 0; i < b; ++i) {
                        get_rsa_params(e, d, N);
                    }
                    struct timespec end;
                    clock_gettime(CLOCK_MONOTONIC, &end);
                    double time = end.tv_sec - start.tv_sec + 1e-9 * (end.tv_nsec - start.tv_nsec);
                    double average = time / b;
                    printf("It took a total of %lf seconds to generate the keys for %d times with an average of %lf.",
                           time, b, average);
                }

                break;

            case 3:
                {
                    struct timespec start;
                    clock_gettime(CLOCK_MONOTONIC, &start);
                    for (int i = 0; i < b; ++i) {
                        get_rsa_params(e, d, N);
                    }
                    struct timespec end;
                    clock_gettime(CLOCK_MONOTONIC, &end);
                    double time = end.tv_sec - start.tv_sec + 1e-9 * (end.tv_nsec - start.tv_nsec);
                    double average = time / b;
                    printf("It took a total of %lf seconds to generate the keys for %d times with an average of %lf.",
                           time, b, average);
                }

                break;

            default:
                {
                    struct timespec start;
                    clock_gettime(CLOCK_MONOTONIC, &start);
                    for (int i = 0; i < b; ++i) {
                        get_rsa_params(e, d, N);
                    }
                    struct timespec end;
                    clock_gettime(CLOCK_MONOTONIC, &end);
                    double time = end.tv_sec - start.tv_sec + 1e-9 * (end.tv_nsec - start.tv_nsec);
                    double average = time / (double) b;
                    printf("It took a total of %lf seconds to generate the keys for %d times with an average of %lf.", time, b, average);
                }
                break;

        }
    }else{
        switch(v) {
            case 1:
                get_rsa_params_v1(e, d, N);
                break;

            case 2:
                get_rsa_params_v2(e, d, N);
                break;

            case 3:
                get_rsa_params_v3(e, d, N);
                break;

            default:
                get_rsa_params(e, d, N);
                break;
        }
    }

    printf("Public key: %lu, %lu\n Private key: %lu, %lu\n", *e, *N, *d, *N);
    return 0;
}