#include <math.h>
#include "conversions.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXSIZEFORINTSTRING 32 
#define MAXRELATIONSIZE 100
/*
 * we use the algorithm as described in the cs report
 * divide input by 2 and store remainder
 * store quotient back to the input number
 * repeat until quotient becomes 0
 * binary bumber is the result of remainders in reverse order
 */
unsigned int convert_to_binary(unsigned int decimalNumber){
    if(decimalNumber == 0){
        fprintf(stderr, "Number 0 is not a valid number");
        return 1;
    }
    short unsigned int remainder;
    long binary = 0, i = 1;
    while( decimalNumber != 0){
        remainder = decimalNumber%2;
        decimalNumber = decimalNumber/2;
        binary = binary + (remainder*i);
        i = i * 10;
    }
    return binary;
}

unsigned int convert_to_decimal(unsigned int binaryNumber){
    unsigned int decimalNumber = 0, i = 0, remainder;
    while(binaryNumber !=0)
    {
        remainder = binaryNumber%10;
        binaryNumber /= 10;
        decimalNumber += remainder*pow(2,i);
        i++;
    }
    return decimalNumber;
}

// we want the number in binary, that way it is absolutely trivial to get
// the number of generations using the formula
// generationsBack = length of binary number - 1;
unsigned int get_generations(unsigned int binaryNumber){
    if(binaryNumber == 1){
        return 0;
    }
    char convertedNumber[MAXSIZEFORINTSTRING];
    snprintf(convertedNumber, MAXSIZEFORINTSTRING, "%d", binaryNumber );
    return (strlen(convertedNumber) - 1);

}

// print either "mother's or father's"
// go to the last one and print either "mother" or "father" because the
// last one is a special case.
void get_family_relation(unsigned int binaryNumber){
    if(binaryNumber == 1){
        printf("self\n");
        return;
    }
    // convert binary number to String
    char convertedNumber[MAXSIZEFORINTSTRING];
    snprintf(convertedNumber, MAXSIZEFORINTSTRING, "%d", binaryNumber );
    // save the string length
    unsigned int stringLength = strlen(convertedNumber);
    // loop through every character of the string except for the first one (0)
    for(int i = 1; i < stringLength - 1; i++){
        if(convertedNumber[i] == '1'){
            printf("mother's ");
        }
        else if(convertedNumber[i] == '0'){
            printf("father's ");
        }
    }
    if(convertedNumber[stringLength - 1] == '1'){
        printf("mother \n");
    } else if (convertedNumber[stringLength - 1] == '0'){
        printf("father \n");
    } else {
        printf("%c", convertedNumber[stringLength - 1]);
    }
}

// This function first checks to see if the first value is s, which means that
// the user MUST HAVE entered 'self', which by itself is a limiting case, so it
// was worth simplifying the code by just having a simple check at the
// beginning. The rest of the function simply identifies m's or f's as the only
// location that they would be found is in the word's mother or father
// respectively.
unsigned int get_binary_from_string(const char x[]){
    if(x[0] == 's'){
        return 1;
    }
    char convertedRelation[MAXSIZEFORINTSTRING];
    char* ptr;
    int count = 1;
    convertedRelation[0] = '1';
    for(int i = 0; i < strlen(x); i++){
        if(x[i] == 'm'){
            convertedRelation[count] = '1';
            count++;
        } else if(x[i] == 'f'){
            convertedRelation[count] = '0';
            count++;
        }
    }
    convertedRelation[count] = '\0';
    return strtol(convertedRelation, &ptr, 10 );
}
