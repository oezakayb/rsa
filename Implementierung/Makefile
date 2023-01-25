CFLAGS = -g -O0

all: main
main: main.c rsa_params.S
	$(CC) $(CFLAGS) -o $@ $^
clean:
	rm -f main
