// Author: Alexander Kellermann Nieves
// filename: mmult.c
// description: the implementation of the required header files

#include <stdio.h>
#include <stdlib.h>
#include "mmult.h"


double** xalloc(int r, int c) {
    double** matrixArray = (double**)malloc(sizeof(double)*r);
    for (int i = 0; i < r; i++) {
        matrixArray[i] = (double*)malloc(sizeof(double)*c);
    }
    return matrixArray;
}

void xfree(int r, int c, double** A) {
    (void)c;
    for (int q = 0; q < r; q++) {
        free(A[q]);
    }
    free(A);
}

double** mread(FILE* fp, int* r, int* c) {
    // Allocate memory for a matrix
    double** matrixArray = xalloc(*r, *c);
    for (int i = 0; i < *r; i++) {
        for (int j = 0; j < *c; j++) {
            double bufferSpace;
            fscanf(fp, "%lf", &bufferSpace);
            matrixArray[i][j] = bufferSpace;
        }
    }
    return matrixArray;
}

void mwrite(FILE* fp, int rA, int cA, double** A) {
    fprintf(fp, "%d %d\n", rA, cA);
    for (int i = 0; i < rA; i++) {
        for (int j = 0; j < cA; j++) {
            fprintf(fp, "%8.2lf ", A[i][j]);
        }
        fprintf(fp, "\n");
    }
}

double **mmult(int rA, int cA, double** A, int rB, int cB, double** B) {
    if (cA != rB) {
        fprintf(stderr, "You can't multiply these two matrices together.\n");
        return NULL;
    }
    double** finalArray = xalloc(rA, cB);
    for (int w = 0; w < rA; w++) {
        for (int j = 0; j < cB; j++) {
            double total = 0;
            for (int k = 0; k < cA; k++) {
                total += A[w][k] * B[k][j];
            }
            finalArray[w][j] = total;
        }
    }
    return finalArray;
}
