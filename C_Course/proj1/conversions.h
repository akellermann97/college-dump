#ifndef CONVERSIONS_H_
#define FOO_H_

/**
 * @author: akn1736: Alexander Kellermann
 * Header file for all the functions used in conversions.c
 */

// this will take an int and return an int.
unsigned int convert_to_binary(unsigned int x);

// this will take an int, and return an int.
unsigned int convert_to_decimal(unsigned int x);

// since array's are passed by value, we can just edit the original array
// and not worry about passing anything back
unsigned int get_generations(unsigned int x);

// this function will simply print out the family relation, as handling the
// dynamically changing string length was tricky
void get_family_relation(unsigned int x);

// returns an unsigned integer after given a string that is supposed to contain
// a binary value
unsigned int get_binary_from_string(const char x[]);

#endif
