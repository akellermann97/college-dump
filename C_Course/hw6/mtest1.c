//
// Simple test of the Matrix ADT
//
// tests matCreate(), matInit(), matPrint(), matDestroy()
//

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "Matrix.h"

int main( void ) {
    Matrix m1;

    m1 = matCreate( 3, 3 );

    if( m1 == NULL ) {

        fputs( "ERROR create of 3x3 matrix failed!\n", stderr );

    } else {

	puts( "Matrix 1 contains:" );
	matPrint( m1, stdout );
        matDestroy( m1 );
    }

    return( 0 );

}
