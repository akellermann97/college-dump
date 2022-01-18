/***
 * This is the main program for the ahnentafel.c project.
 * The overall menu exists in this file.
 *
 * @author: akn1736 ||  Alexander Kellermann Nieves
 */

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>
#include <ctype.h>
#include "conversions.h"

#define MAXSTRINGLENGTH 32
#define END '\0'

// @param none
// @return none
// The purpose of this function is to print the description when the
// program is run in interactive mode (no command line arguments supplied) 
void description(){
    printf("The Ahnentafel number is used to determine the relation\n");
    printf("between an individual and each of his/her direct ancestors.\n\n");
}

// @param str* this is a pointer to an array of characters. 
// @return none
// The purpose of this method is to take in a base 10 number, and then
// properly display the number in binary, as well as the family relations,
// and generations back. Then the function exits
void base10(char* str){
    char* ptr;
    printf("Enter the ahnentafel number in base-10: ");
    fgets(str, MAXSTRINGLENGTH, stdin);
    unsigned int bin = convert_to_binary(strtol(str, &ptr, 10));
    printf("ahnentafel number in binary: %d\n", bin);
    printf("family relation: ");
    get_family_relation(bin);
    printf("generations back: %d\n", get_generations(bin));
    printf("\n");
}

// @param str* this is a pointer to an array of characters
// @return none
// The purpose of this method is to take in a string, and pass it through
// some helper functions as defined in conversions.h to extract a binary
// number, and through that binary number, deduce all other things about
// the ancestory
void relation(char* str){
    printf("Enter family relation(e.g.) \"father\'s  mother\": ");
    fgets(str, MAXSTRINGLENGTH, stdin);
    unsigned int binaryNumber = get_binary_from_string(str);
    printf("ahnentafel number in binary: %d\n", binaryNumber);
    printf("ahnentafel number in base-10: %d\n", convert_to_decimal(binaryNumber));
    printf("generations back: %d\n\n", get_generations(binaryNumber));
}

// @param str* this is a pointer to an array of characters. 
// @return none
// The purpose of this method is to take in a base 2 number, and then
// properly display the number in decimal, as well as the family relations,
// and generations back. Then the function exits
void base2(char *str){
    char *ptr;
    printf("Enter the ahnentafel number in binary: ");
    fgets(str, MAXSTRINGLENGTH, stdin);
    unsigned int binBoy = strtol(str, &ptr, 10);
    printf("base-10 value: %d\n", convert_to_decimal(binBoy) );
    printf("family relation:");
    get_family_relation(binBoy);
    printf("generations back: %d\n\n", get_generations(binBoy));

}

// by using a Max string length, we can build in a safety guarantee by
// telling fgets the buffer size.
int menu(char* str){
    char *ptr;
    printf("1)\t description\n");
    printf("2)\t ahnentafel number (base 10)\n");
    printf("3)\t ahnentafel number (base 2)\n");
    printf("4)\t relation (e.g. mother's mother's father)\n");
    printf("5)\t exit\n\n");
    printf(">");
    // fgets takes an array of characters
    // The max buffer length
    // the input
    fgets(str, MAXSTRINGLENGTH,stdin);

    // declare and initalize an integer and set it to the value of 
    // strtol
    long numberReturned = strtol(str, &ptr ,10);

    if(numberReturned == 1){
        description();
        return 1;
    } else if (numberReturned == 2){
        base10(str);
        return 1;
    }
    else if (numberReturned == 3){
        base2(str);
        return 1;
    }
    else if (numberReturned == 4){
        relation(str);
        return 1;
    }
    else if (numberReturned == 5){
        printf("Goodbye.\n");
        return EXIT_SUCCESS;
    } else {
        // TODO: numbers 2 - 4
        fprintf(stderr, "Unknown operation!\n");
        return 1;
    }
    // return value 1 will simply call the menu function again because of how
    // the main method is set up. Consider this a fall back feature.
    return 1;
}

// This is the main function of the program, the entry point. The only time any
// dynamic memory allocation is done is all handled within this function.
// Hopefully no memory should be leaked, as the only pointer that is ever
// allocated is immediately deallocated before the next menu is spawned
int main(int argc, char* argv[]){
    if(argc <  2){
        // calloc allows us to create an array of memory on the heap. I do this
        // to avoid recreating arrays unneccessaryily. I perform the allocation
        // in main to ensure that the memory is released. In every other
        // function I simply pass the pointer to the address in memory. This
        // saves valuable space and time.
        while(1){ 
            char* standardInputString = calloc(MAXSTRINGLENGTH, sizeof(char));

            // pass the pointer to menu
            int returnedValue = menu(standardInputString);
            
            // free the memory
            free(standardInputString);
            if(returnedValue == EXIT_SUCCESS){
            break;
            }
        }
    } else {
        // command line argument supplied, so run this code.
        // check to see if the first character is an ASCII code, and if it is,
        // we know that the user entered a relationship argument
        char *string = argv[1];
        char *ptr;
        if(string[strlen(string) - 1] == 'b'){
            char str[2] = "b";
            char * tester = strtok(string, str);
             printf("base-10 value: %d\n", convert_to_decimal(strtol(tester, &ptr, 10)));
             printf("famiy relation: ");
             get_family_relation(strtol(tester, &ptr, 10));
             printf("generations back: %d\n", get_generations(strtol(tester, &ptr, 10)));
            // TODO: Other things with the binary number now
        } else if (isalpha(string[0])){
            // This is when you're given a giant input string
            // We need to reconstruct the individual slices that come in by
            // putting them into a larger string (with max size 32)
            char fullReconstructedString[MAXSTRINGLENGTH];
            for( int i = 1; i < argc; i++){
                strcat(fullReconstructedString, argv[i]);
            }
            unsigned int binBoyo = get_binary_from_string(fullReconstructedString);
            printf("ahnentafel number in binary: %d\n", binBoyo );
            printf("ahnentafel number in base-10: %d\n", convert_to_decimal(binBoyo));
            printf("generations back: %d\n\n", get_generations(binBoyo));
        } else {
            int binaryThingy = convert_to_binary(strtol(string, &ptr, 10));
            printf("ahnentafel number in binary: %d\n", binaryThingy);
            printf("family relation: ");
            get_family_relation(binaryThingy);
            printf("generations back: %d\n", get_generations(binaryThingy));
        }
    }
    return 0;
}
