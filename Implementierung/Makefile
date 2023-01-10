CC = gcc
CFLAGS = -O3

all: rsa
rsa: main.c rsa_params.S
	$(CC) $(CFLAGS) -o rsa main.c rsa_params.S
clean:
	rm -f rsa