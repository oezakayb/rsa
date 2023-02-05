CFLAGS = -O3 -lm

get_rsa_params: main.c rsa_params_v0.S rsa_params_v1.c rsa_params_v2.c rsa_params_v4.c rsa_params_v5.S rsa_params_v6.c
	$(CC) $(CFLAGS) -o $@ $^
clean:
	rm -f get_rsa_params
