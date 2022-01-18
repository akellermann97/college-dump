CC=gcc
SOURCES= ahnentafel.c
CFLAGS= -c -Wall -Wunused -Wimplicit -pedantic -std=c99
EXECUTABLE=main

all: ahnentafel 

ahnentafel: ahnentafel.o conversions.o
	$(CC) ahnentafel.o conversions.o -o ahnentafel 

ahnentafel.o: ahnentafel.c
	$(CC) $(CFLAGS) ahnentafel.c

conversions.o: conversions.c
	$(CC) $(CFLAGS) conversions.c

clean:
	rm *o main
