CFLAGS = -O3

all: rsa
rsa: main.c rsa_params.S carmicael.S
	$(CC) $(CFLAGS) -o $@ $^
clean:
	rm -f rsa