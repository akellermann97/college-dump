#ifndef MMULT_H
#define MMULT_H
#include <stdio.h>


// Return the product A*B as a new, dynamically allocated rA x cB matrix.
double **mmult(int rA, int cA, double **A, int rB, int cB, double **B);

// Dynamically allocate an r x c matric of doubles, initialized to zeros.
double **xalloc(int r, int c);

// Free all memory allocated for A
void xfree(int r, int c, double **A);

// reads a maxtric (in row-major order) from file
double **mread(FILE *fp, int *r, int *c);

// writes the rAxcA matrix A to already open file
void mwrite(FILE *fp, int rA, int cA, double **A);

// return the element of A at the r-th row and the c-th column
double aref(int r, int c, double **A);

// set the value of the element of A at the r-th row and c-th column to x
void aset(int r, int c, double **A, double x);

#endif
