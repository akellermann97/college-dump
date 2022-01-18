/*
 * Author: Alexander Kellermann Nieves
 * Date: November 26th
 * Filename: Packman.c
 * Description: The head honcho
 */

#include <assert.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include "encoder.h"

#define READ_ONLY "r"
#define APPEND_AT_BEGINNING_CREATE_IF_NOT_EXISTING "w+"
#define WRITE_ONLY "w"

int Tmain (int argc, char * argv[]){
    // First we make sure we have the proper amount of arguments
    if(argc != 3){
        fprintf(stderr, "Usage: packman [file] [file]\n");
        return EXIT_FAILURE;

    }

    // this will let us know where we output to.
    // o: stdout
    // d: decodedFile
    // e: encodedFile
    // f: fail
    char outputStyle;

    // these are the first, and second files, respectively
    FILE * firstFile;
    FILE * secondFile;

    // Now we just want to open the files to see if they exist. So what we do
    // is we open them in a fashion where it will error out or otherwise NOT
    // create a file, for at least the first one, but we will want to create a
    // file for the second one if one does not already exist. That is an
    // important difference.

    firstFile = fopen(argv[1], READ_ONLY);
    if(!firstFile){
        perror("packman.c:47:Unable to open file!");
        EXIT_FAILURE;
    }
    // now we know that the file can be opened
    // so we'll want to check to see if the file has already been encoded or
    // not.
    unsigned short firstThingInFile;
    fread(&firstThingInFile, sizeof(unsigned short), 1, firstFile);

    if(firstThingInFile == getMagic){
        // Decode the file
        
    } else {
        // Encode the file
    }


    secondFile = fopen(argv[2], APPEND_AT_BEGINNING_CREATE_IF_NOT_EXISTING);
    if(!secondFile){
        perror("Serious error!");
        EXIT_FAILURE;
    }

    /* This is where we find out what to do with the inputted flags*/
    if( !strcmp(argv[2],"-")){
        fprintf(stdout, "This goes to standardout!\n");
        outputStyle = 'o';
    } else {
        // now we know that the file 
        // check for magic number, but for now we don't have any files with the
        // magic number in them.
        outputStyle = 'e';
        
    }

    // Always close files when you're finished with them
    fclose(firstFile);
    fclose(secondFile);

    return EXIT_SUCCESS;
}

int main(void){
    FILE * fp;
    fp = fopen("HeapDT.h", "r");
    FrequencyTracker * holder = processFile(fp);
    TreeNode * tree = buildTree(holder);
}
