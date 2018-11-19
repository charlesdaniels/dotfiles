CFLAGS=-Wall -Wextra -pedantic -std=c99 -O3

.PHONY: clean

fastabr: fastabr.c fastabr.h
	$(CC) $< -o $@ $(CFLAGS) $$(if [ $$(uname)="Linux" ] ; then printf " -lbsd " ; fi) 

clean:
	rm -f *.o
	rm -f *.gch
	rm -f *.core
	rm -f fastabr
