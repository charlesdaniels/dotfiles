CFLAGS=-Wall -Wextra -pedantic -std=c99 -O3

.PHONY: clean

fastabr: fastabr.c fastabr.h
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f *.o
	rm -f *.gch
	rm -f *.core
	rm -f fastabr
