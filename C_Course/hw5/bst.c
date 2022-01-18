// Author: Alexander Kellermann Nieves
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "bst.h"
#define _GNU_SOURCE

int main(int argc, char * argv[]){
    if(argc != 1){
        fprintf(stderr, "Usage: bst\n");
    }
    // 
    // Look at Standard input, stepping through word by word.
    // Check to see if any form of the word exists in the tree already
    // Then just cry :)
    File * pFile = stdin;

    // set buffer to NULL. getline will allocate it.
    char * buf = NULL;
    
}
