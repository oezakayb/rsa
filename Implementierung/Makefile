CFLAGS = -g -O3

all: main
main: main.c rsa_params_v0.S rsa_params_v1.c rsa_params_v2.S rsa_params_v3.c
	$(CC) $(CFLAGS) -o $@ $^
clean:
	rm -f main
