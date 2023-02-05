#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <getopt.h>
#include <time.h>

#include "rsa_params_v0.h"
#include "rsa_params_v1.h"
#include "rsa_params_v2.h"
#include "rsa_params_v4.h"
#include "rsa_params_v5.h"
#include "rsa_params_v6.h"

const char* usage_msg =
        "Usage: %s [options]   Prints out the RSA public and private key pairs. Try -h to see the options\n"
        "   or: %s -h / --help   Show all options\n";

const char* help_msg =
        "  -V X Runs the chosen version of implementation\n"
        "       V0: Assembly implementation (default)\n"
        "       V1: C implementation with linear congruential generaor\n"
        "       V2: C implementation with linear congruential generator and improved prime check\n"
        "       V3: C implementation with Carmichael's totient function\n"
        "       V4: Assembly implementation with predefined p, q and N (for comparison)\n"
        "       V5: C implementation with predefined p, q and N (for comparison)\n"
        "  -B X The program will run for X times and the total and average runtime of the given version (if specified) of implementation will be measured\n"
        "       and printed along with the last generated pair\n"
        "  -e M Encrypts and decrypts M with the generated (the last one if -B is on) key pairs\n"
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
    bool ebool = false;
    unsigned __int128 M;

    struct option long_options[] = {
            {"help", 0, NULL, 'h'},
            {0,      0, 0,    0}
    };

    while ((opt = getopt_long(argc, argv, "V:B:e:h", long_options, 0)) != -1) {
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
            case 'e':
                ebool = true;
                M = (unsigned __int128) atoll(optarg);
                break;
            case 'h':
                print_help(progname);
                return EXIT_SUCCESS;
            default:
                print_usage(progname);
                return EXIT_FAILURE;
        }
    }

    unsigned long *e = malloc(sizeof *e);
    unsigned long *d = malloc(sizeof *d);
    unsigned long *N = malloc(sizeof *N);
    unsigned int *seed = malloc(sizeof *seed);

    if(e == NULL || d == NULL || N == NULL || seed == NULL) {
        printf("No memory!\n");
        return EXIT_FAILURE;
    }

    *seed = 0;

    if(bbool){
        switch(v) {
            case 1:
            {
                struct timespec start;
                clock_gettime(CLOCK_MONOTONIC, &start);
                for (int i = 0; i < b; ++i) {
                    get_rsa_params_v1(e, d, N, seed);
                }
                struct timespec end;
                clock_gettime(CLOCK_MONOTONIC, &end);
                double time = end.tv_sec - start.tv_sec + 1e-9 * (end.tv_nsec - start.tv_nsec);
                double average = time / b;
                printf("It took a total of %lf seconds to generate the keys for %d times with an average of %lf.\n",
                       time, b, average);
            }

                break;

            case 2:
            {
                struct timespec start;
                clock_gettime(CLOCK_MONOTONIC, &start);
                for (int i = 0; i < b; ++i) {
                    get_rsa_params_v2(e, d, N, seed);
                }
                struct timespec end;
                clock_gettime(CLOCK_MONOTONIC, &end);
                double time = end.tv_sec - start.tv_sec + 1e-9 * (end.tv_nsec - start.tv_nsec);
                double average = time / b;
                printf("It took a total of %lf seconds to generate the keys for %d times with an average of %lf.\n",
                       time, b, average);
            }

                break;

            case 3:
            {
                struct timespec start;
                clock_gettime(CLOCK_MONOTONIC, &start);
                for (int i = 0; i < b; ++i) {
                    get_rsa_params_v4(e, d, N, seed);
                }
                struct timespec end;
                clock_gettime(CLOCK_MONOTONIC, &end);
                double time = end.tv_sec - start.tv_sec + 1e-9 * (end.tv_nsec - start.tv_nsec);
                double average = time / b;
                printf("It took a total of %lf seconds to generate the keys for %d times with an average of %lf.\n",
                       time, b, average);
            }

                break;

            case 4:
            {
                struct timespec start;
                clock_gettime(CLOCK_MONOTONIC, &start);
                for (int i = 0; i < b; ++i) {
                    get_rsa_params_v5(e, d, N);
                }
                struct timespec end;
                clock_gettime(CLOCK_MONOTONIC, &end);
                double time = end.tv_sec - start.tv_sec + 1e-9 * (end.tv_nsec - start.tv_nsec);
                double average = time / b;
                printf("It took a total of %lf seconds to generate the keys for %d times with an average of %lf.\n",
                       time, b, average);
            }

                break;

            case 5:
            {
                struct timespec start;
                clock_gettime(CLOCK_MONOTONIC, &start);
                for (int i = 0; i < b; ++i) {
                    get_rsa_params_v6(e, d, N);
                }
                struct timespec end;
                clock_gettime(CLOCK_MONOTONIC, &end);
                double time = end.tv_sec - start.tv_sec + 1e-9 * (end.tv_nsec - start.tv_nsec);
                double average = time / b;
                printf("It took a total of %lf seconds to generate the keys for %d times with an average of %lf.\n",
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
                printf("It took a total of %lf seconds to generate the keys for %d times with an average of %lf.\n", time, b, average);
            }
                break;

        }
    }else{
        switch(v) {
            case 1:
                get_rsa_params_v1(e, d, N, seed);
                break;

            case 2:
                get_rsa_params_v2(e, d, N, seed);
                break;

            case 3:
                get_rsa_params_v4(e, d, N, seed);
                break;

            case 4:
                get_rsa_params_v5(e, d, N);
                break;

            case 5:
                get_rsa_params_v6(e, d, N);
                break;

            default:
                get_rsa_params(e, d, N);
                break;
        }
    }

    printf("Public key: %lu, %lu\nPrivate key: %lu, %lu\n", *e, *N, *d, *N);

    if(ebool) {
            unsigned __int128 c = 1;
            while (*e > 0) {
                if (*e & 1) {
                    c = (c * M) % *N;
                }
                *e = *e >> 1;
                M = (M * M) % *N;
            }
            M = 1;
            printf("C: %lu\n", (unsigned long) c);
            while (*d > 0) {
                if (*d & 1) {
                    M = (M * c) % *N;
                }
                *d = *d >> 1;
                c = (c * c) % *N;
            }
            printf("D: %lu\n", (unsigned long) M);
    }

    free(e);
    free(d);
    free(N);
    free(seed);
    return 0;
}
