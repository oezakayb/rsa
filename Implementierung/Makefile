CC = aarch64-linux-gnu-gcc
CFLAGS = -O3 -march=armv8-a

all: rsa
rsa: main.c rsa_params.S
	$(CC) $(CFLAGS) -o rsa main.c rsa_params.S
clean:
	rm -f rsa