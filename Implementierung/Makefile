CFLAGS = -O0

all: main
main: test.c carmicael.S gcd.S
	$(CC) $(CFLAGS) -o $@ $^
clean:
	rm -f main
