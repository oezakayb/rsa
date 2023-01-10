CFLAGS = -O3

all: rsa
rsa: main.c rsa_params.S
	$(CC) $(CFLAGS) -o $@ $^
clean:
	rm -f rsa