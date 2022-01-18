CC=gcc
CFLAGS= -std=c99 -Wall -Wextra -pedantic

all: binarySearch

binarySearch : bst.o 
	$(CC) bst.o -o binarySearch 

bst.o : bst.c
	$(CC) -c bst.c

clean:
	rm *.o binarySearch
