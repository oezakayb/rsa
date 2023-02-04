CFLAGS = -O3 -lm

main: main.c rsa_params_v0.S rsa_params_v1.c rsa_params_v2.c rsa_params_v3.S rsa_params_v4.c
	$(CC) $(CFLAGS) -o $@ $^
clean:
	rm -f main
