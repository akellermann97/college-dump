//
// Simple test of the Matrix ADT
//
// tests matDuplicate(), matEquals()
//

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "Matrix.h"

int main( void ) {
    Matrix m1, m2;

    m1 = matCreate( 3, 3 );
    if( m1 == NULL ) {
        fputs( "ERROR - create of first 3x3 matrix failed!\n", stderr );
	exit( 1 );
    }

    puts( "Matrix 1:" );
    matPrint( m1, stdout );

    m2 = matDuplicate( m1 );
    if( m2 == NULL ) {
        fputs( "ERROR - create of second 3x3 matrix failed!\n", stderr );
	matDestroy( m1 );
	exit( 1 );
    }

    puts( "\nMatrix 2:" );
    matPrint( m1, stdout );
    putchar( '\n' );

    if( matEquals(m1,m2) ) {
        fputs( "SUCCESS - matrices are equal\n", stdout );
    } else {
        fputs( "ERROR - matrices are NOT equal\n", stdout );
    }

    matDestroy( m1 );
    matDestroy( m2 );

    return( 0 );

}
