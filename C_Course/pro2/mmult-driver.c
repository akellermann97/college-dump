// Author: Alexander Kellermann Nieves
// Description: The driver class for the main program
// Filename: mmult-driver.c

#include <stdlib.h>
#include <string.h>
#include "mmult.h"

int main(int argc, char * argv[]){
    // this prints out an error if the user supplies any arguments
    (void)(argv);
    if (argc != 1){
        fprintf(stderr, "Usage: mmult < [input file]\n");
        return EXIT_FAILURE;
    }

    // set the File pointer to be stdin, as we're reading from redirected
    // input, and not from an actual file
    FILE* pFile = stdin;
    char * buf = NULL;

    size_t n = 0;
    ssize_t num = -1;
    char * nonsense;

    num = getline( &buf, &n, pFile);
    int matrice = strtod(buf, &nonsense ); /** This contains the first digit in the file */
    const char s[2] = " "; 
    num = getline( &buf, &n, pFile);
    int * rowsA  = malloc(sizeof(int)); 
    int * columnsA = malloc(sizeof(int)); 
    int * rowsB  = malloc(sizeof(int)); 
    int * columnsB = malloc(sizeof(int)); 

    /** this outer loop is run matrice number of times **/
    if(matrice == 1){
        // this is a special case, and in this case we just want to print the
        // matrix
        *rowsA = strtod(strtok(buf, s), &nonsense);
        *columnsA = strtod(strtok(NULL, s), &nonsense);
        double ** daOnlyMatrix = mread(pFile, rowsA, columnsA);
        mwrite(stdout, *rowsA, *columnsA, daOnlyMatrix);
        return EXIT_SUCCESS;
        // This exits the program here. There's no need to write anything to
        // file, we just push it out of stdout.
    } else {
        // now for reach matrice we want to gather the number of rows and
        // columns
        *rowsA = strtod(strtok(buf, s), &nonsense);
        *columnsA = strtod(strtok(NULL, s), &nonsense);
        printf("rows = %d\n", *rowsA);
        printf("columns = %d\n", *columnsA);
        // now we have rows and columns
        // now we allocate the proper space for the array
        double ** matrix_1 = mread(pFile, rowsA, columnsA);
        mwrite(stdout, *rowsA, *columnsA, matrix_1);
        for(int i = 0; i < *rowsA; i++){
            getline(&buf, &n, pFile);
        }
        *rowsB = strtod(strtok(buf, s), &nonsense);
        *columnsB = strtod(strtok(NULL, s), &nonsense);
        double ** matrix_2 = mread(pFile, rowsB, columnsB);
        mwrite(stdout, *rowsB, *columnsB, matrix_2);


        double ** final = mmult(*rowsA, *columnsA, matrix_1, *rowsB, *columnsB, matrix_2);
        mwrite(stdout, *rowsA, *columnsB, final);
        
        return EXIT_SUCCESS;
    }
}
