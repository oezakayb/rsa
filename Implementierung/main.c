#include "rsa_params.h"

const char* usage_msg =
        "Usage: %s [options]   Prints out the public and private key pairs. Try -h to see the options\n"
        "   or: %s -h / --help   Show all options\n";

const char* help_msg =
        "Optional arguments:\n"
        "  -V X   Runs the chosen version of implementation\n"
        "       V0: Our Assembler implementation (default)\n"
        "       V1: Our C implementation\n"
        "       V2: \n"
        "       V3: \n"
        "       V4: \n"
        "  -B X   The program will run for X times and the total runtime of the given version (if specified) of implementation will be measured\n"
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

    unsigned long *e,*d, *N;

    switch(v) {
        case 0:
            get_rsa_params(e, d, N);
            break;

        case 1:
            break;
    }

    fprintf("Public key: %ul, %ul\n" + "Private key: %ul, %ul\n", *e, *N, *d, *N);
}