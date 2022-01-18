// Author: Alexander Kellermann Nieves
// akn1736
// Version 1.0
#include <stdlib.h>

struct matrix_st{
    size_t rows;
    size_t cols;
    float **elements;
};

#include "Matrix.h"
/* 
 * Create a new Matrix with the specified order, and return it to the calling
 * routine. If the matrix is square, it is initalized to the identify matrix;
 * otherwise, otherwise it is initilized to teh zero matrix. On error, NULL is
 * returned.
 */
Matrix matCreate( size_t rows, size_t cols ){
    // we want to do error checking as soon as possible. This will check to see
    // if the Matrix has less than one row or column.
    if(rows < 1 || cols < 1){
        return NULL;
    }

    // firstly, we allocate space for our matrix
    Matrix newMatrix = (Matrix) malloc(sizeof(struct matrix_st));

    // Now, I initalize the rows and columns for the matrix.
    newMatrix->rows = rows;
    newMatrix->cols = cols;
    
    // Now we want to make sure that the matrix has the proper amounts of rows
    newMatrix->elements = (float**) malloc(sizeof(float));

    // Now we want to make sure that the matrix has the proper amount of cols
    for(int i = 0; i < rows; i++){
        newMatrix->elements[i] = (float*) malloc(sizeof(float) * cols);
    }



    return NULL;
}

/* 
 * Deallocate the matrix supplied as the parameter
 */
void matDestroy( Matrix mat );
