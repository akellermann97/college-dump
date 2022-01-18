CFLAGS= -Wall -Wextra -pedantic -std=c99
CC= gcc

main: mmult.o mmult-driver.o
	$(CC) mmult.o mmult-driver.o -o main

mmult.o: mmult.c
	$(CC) -c mmult.c

mmult-driver.o: mmult-driver.c
	$(CC) $(CFLAGS) -c mmult-driver.c

clean:
	rm -f *.o
