//
// Simple test of the Matrix ADT
//
// tests matInit(), matSetCell(), matGetCell(), matTranspose()
//

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "Matrix.h"

///
// support function - convert Status value to string
///

const char *code( Status n ) {

    switch( n ) {

        case Success:
	    return( "Success" );

	case BadRowNumber:
	    return( "BadRowNumber" );

	case BadColNumber:
	    return( "BadColNumber" );

	default:
	    break;
    }

    return( "???" );
}

///
// support function:  set a cell, then test it
///

void set_and_test( Matrix mat, size_t row, size_t col, float data ) {
    Status status;

    // first, try to set the cell
    status = matSetCell( mat, data, row, col );
    if( status != Success ) {
        fprintf( stderr, "SetCell(%lu,%lu) error: code %d, '%s'\n",
	         row, col, status, code(status) );
    } else {
        float num;

	status = matGetCell( mat, &num, row, col );
	if( status != Success ) {
	    fprintf( stderr, "GetCell(%lu,%lu) error: code %d, '%s'\n",
	             row, col, status, code(status) );
	} else if( num != data ) {
	    fprintf( stderr, "Set/Get(%lu,%lu): set to %8.3f, got %8.3f back\n",
	             row, col, data, num );
	}
    }
}

int main( void ) {
    Matrix m1, m2, m3, m4, m5;

    m1 = matCreate( 3, 3 );
    if( m1 == NULL ) {
        fputs( "ERROR - create of first 3x3 matrix failed!\n", stderr );
	exit( 1 );
    }

    m2 = matCreate( 3, 3 );
    if( m2 == NULL ) {
        fputs( "ERROR - create of second 3x3 matrix failed!\n", stderr );
	matDestroy( m1 );
	exit( 1 );
    }

    float data1[] = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0 };
    float data2[] = { 9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0 };

    matInit( m1, data1 );
    matInit( m2, data2 );

    puts( "Modified Matrix 1:" );
    matPrint( m1, stdout );
    puts( "\nModified Matrix 2:" );
    matPrint( m2, stdout );

    m3 = matTranspose( m1 );
    puts( "\nMatrix 3:" );
    matPrint( m3, stdout );

    m4 = matCreate( 3, 5 );
    set_and_test( m4, 2, 1, 8.0 );
    set_and_test( m4, 3, 1, 9.75 );
    set_and_test( m4, 1, 4, 2.5 );
    puts( "\nMatrix 4:" );
    matPrint( m4, stdout );

    m5 = matTranspose( m4 );
    puts( "\nMatrix 5:" );
    matPrint( m5, stdout );

    matDestroy( m1 );
    matDestroy( m2 );
    matDestroy( m3 );
    matDestroy( m4 );
    matDestroy( m5 );

    return( 0 );

}
