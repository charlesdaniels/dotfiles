CFLAGS=-Wall -Wextra -pedantic -std=c89 -Og -g -lm

.PHONY: clean

nowall: nowall.c nowall.h
	$(CC) $< $(CFLAGS) $$(pkg-config --cflags --libs x11) -o $@

clean:
	rm -rf nowall *.gch *.o
