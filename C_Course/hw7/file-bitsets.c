/*
 * @file: file-bitsets.c
 * @author: Alexander Kellermann Nieves
 * @description: Peforms various set functions on characters
 */

#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define DAMIGHTYSTRING "ABCDEFGHIJKLMNOPQRSTUVWXYZ.0123456789,abcdefghijklmnopqrstuvwxyz";
#define MAXBUFSIZE 256

/* 
 * Converts a decimal number into binary. However, we make sure that the
 * returned binary representation is 64 characters wide 
 * @param decimal = the original number
 * @param binary = the binary reprentation
 */
void decimalToBinary(uint64_t decimal, char* binNum) {
    char buffer[MAXBUFSIZE];
    int i = 0; 
    while (decimal != 0) {
        uint64_t remainder = decimal % 2;
        if (remainder) {
            strcpy(buffer, "1"); strcat(buffer, binNum); strcpy(binNum, buffer);
        }
        else {
            strcpy(buffer, "0"); strcat(buffer, binNum); strcpy(binNum, buffer);
        }
        i++;
        decimal /= 2;
    }
    binNum[i] = '\0';
    int padding = 64 - i;
    for (int a = 0; a < padding; a++) {
        buffer[a] = '0';
        /* we need the null terminating character at the end */
        buffer[a+1] = '\0';
    }
    strcat(buffer, binNum);
    strcpy(binNum, buffer);
    return;
}

/*
 * As the documentation requires, we simply return the relative bit of a
 * character
 * @param daCharacter : the character whose bit we need
 */
int char_bit(char daCharacter) {
    char* ref = DAMIGHTYSTRING;
    for (size_t i = 0; i < strlen(ref); i++) {
        if (ref[i] == daCharacter)
            return strlen(ref)-i;
    }
    return 0;
}

/*
 * We loop through string, continously changing the value of 'result' for each
 * character. Then we want to get the bit represenation of the character and
 * shift that to the left. Finally, we put that bit into result!
 */
uint64_t set_encode(char* st) {
    uint64_t result = 0x0;
    for (size_t i = 0; i < strlen(st); i++) {
        int bit = char_bit(st[i]);
        if (bit) {
            uint64_t one = 0x1;
            result = result | (one << (bit-1));    }
    }

    return result;
}

/*
 * Read the open file, returning a version that's heavily encoded.
 * Perhaps it'll never be able to be unencoded, hehehe
 */
uint64_t file_set_encode(FILE* fp) {
    uint64_t result = 0x0;
    char ch;
    while (fread(&ch, sizeof(char), 1, fp)) {
        int bit = char_bit(ch);
        if (bit) {
            uint64_t one = 0x1;
            result = result | (one << (bit-1));
        }
    }
    if (ferror(fp)) {
        perror("ERROR");
    }
    return result;
}

/*
 * The Union of two sets is just the bitwise OR of the two sets
 */
uint64_t set_union(uint64_t first_set, uint64_t second_set) {
    return first_set | second_set;
}

/*
 * The set complement is literally just the inversion of the set given to it,
 * so all that needs to be done is a simple bitwise inversion operation
 */
uint64_t set_complement(uint64_t first_set) {
    return ~first_set;
}

/* Performs the intersection operation on the two sets, using the bitwise AND
 * operator
 * @ param first_set : the first set
 * @ param second_set : the second set
 */
uint64_t set_intersect(uint64_t first_set, uint64_t second_set) {
    return first_set & second_set;
}

/*
 * Clever use of inversion and the bitwise AND operator in combination with the
 * inversion operation allows this function to be quite terse, but it just goes
 * like this. We want to first find the AND of the two sets, and invert that.
 * Once inverted, all we have to do is find the AND of that with the first set
 * and you get the set difference.
 */
uint64_t set_difference(uint64_t first_set, uint64_t second_set) {
    return (first_set & (~(first_set & second_set)));
}

/*
 * Performs the symmetric difference calculation by using the bitwise OR
 * operator
 */
uint64_t set_symdifference(uint64_t first_set, uint64_t second_set) {
    return set_difference(first_set, second_set) | set_difference(second_set, first_set);
}

/*
 * Returns the amount of 1's in the binary set
 */
size_t set_cardinality(uint64_t set) {
    char* binNum = (char*)calloc(MAXBUFSIZE, sizeof(char));

    size_t cardinality = 0;
    /* We want cardinality to be 0 to start off with, that is our base case */

    decimalToBinary(set, binNum);
    for (size_t i = 0; i < strlen(binNum); i++) {
        if (binNum[i] == '1') {
            cardinality += 1;
        }
    }
    free(binNum);
    return cardinality;
}

/*
 * This function simply displays which characters are in a set. 
 * Then it allocates memory, which will then need to be freed
 */
char * set_decode(uint64_t set) {
    char * binNum = (char*)calloc(MAXBUFSIZE, sizeof(char));
    char * reference = DAMIGHTYSTRING;
    char * result = (char*)calloc(MAXBUFSIZE, sizeof(char));

    decimalToBinary(set, binNum);
    // Easier if we work in binary

    for (size_t i = 0; i < strlen(binNum); i++) {
        if (binNum[i] == '1') {
            result[strlen(result)] = reference[i];
        }
    }

    result[strlen(result)] = '\0';
    free(binNum);

    return result;
}

/*
 * This is the main entry point of the program. From here all the set
 * operations are performed. We first check to make sure that the command line
 * arugments supplied are of the right format, and then from there, we create
 * an unsigned int which will contain the two sets. 
 */
int main(int argc, char* argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: file-bitsets string1 string2\n");
        return EXIT_FAILURE;
    }
    uint64_t first_set, second_set;
    /* Follow the documentations suggestion that we use uint64_t to specify the sets */
    int file_uno = 0;
    int file_dos = 0;

    /* Attempt to open file */

    FILE* fp1 = fopen(argv[1], "rb");
    if (fp1 == NULL) {
        first_set = set_encode(argv[1]);
    } else {
        file_uno = 1;
        first_set = file_set_encode(fp1);
        /* Close the file! */
        fclose(fp1);
    }

    /* Attempt to open file */

    FILE* fp2 = fopen(argv[2], "rb");
    if (fp2 == NULL) {
        second_set = set_encode(argv[2]);
    } else {
        file_dos = 1;
        second_set = file_set_encode(fp2);
        /* Close the file! */
        fclose(fp2);
    }

    /* Prints the correct string that matches what the documentations wants */
    if (file_uno) {
        printf("string1:\t%s\tEncoding the file:\t%s\n", argv[1], argv[1]);
    } 
    else {
        printf("string1:\t%s\tEncoding the string:\t%s\n", argv[1], argv[1]);
    }
    if (file_dos) {
        printf("string2:\t%s\tEncoding the file:\t%s\n", argv[2], argv[2]);
    } 
    else {
        printf("string2:\t%s\tEncoding the string:\t%s\n", argv[2], argv[2]);
    }

    ///////////////////////////////////////////////////////////////////////////
    /* start of printf hell */
    printf("\n");

    printf("set1:\t%#018lx\n", first_set);
    printf("set2:\t%#018lx\n\n", second_set);

    printf("set_intersect:\t%#018lx\n", set_intersect(first_set, second_set));
    printf("set_union:\t%#018lx\n\n", set_union(first_set, second_set));

    printf("set1 set_complement:\t%#018lx\n", set_complement(first_set));
    printf("set2  set_complement:\t%#018lx\n\n", set_complement(second_set));

    printf("set_difference:\t\t%#018lx\n", set_difference(first_set, second_set));
    printf("set_symdifference:\t%#018lx\n\n", set_symdifference(first_set, second_set));

    printf("set1 set_cardinality:\t%lu\n", set_cardinality(first_set));
    printf("set2 set_cardinality:\t%lu\n\n", set_cardinality(second_set));

    char * second_set_dec = set_decode(first_set);
    char * first_set_dec = set_decode(second_set);

    printf("members of set1:\t'%s'\n", second_set_dec);
    printf("members of set2:\t'%s'\n", first_set_dec);

    /* Valgrind give me strength */
    free(second_set_dec);
    free(first_set_dec);

    /* Thank you ladies and gentleman, it has been an absolute pleasure serving
     * as your captain for this flight
     */
    return EXIT_SUCCESS;
}
