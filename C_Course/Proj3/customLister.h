#ifndef CUSTOMLISTER_H
#define CUSTOMLISTER_H

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

typedef struct FreqKeep_thing * FrequencyTracker;

/*
 * Create an element that just contains the word. The count should be
 * initalized to zero because that's what the documentation for the project
 * requires.
 */
FrequencyTracker createElement(const char myWord);

/*
 * This will print the elements in the data structure, with a nice pretty
 * header for debugging purposes
 * @param array: The array of FrequencyTracker nodes
 * @returns: nothing
 */
void printElements ( FrequencyTracker * array);

/*
 * This will transverse the array in O(n) time or less, and will return either
 * the line number that the word exists at, or the value -1 if the word
 * searched for does not exist in the array
 * @param array: Array of FrequencyTracker nodes
 * @param myWord: the symbol to be searched for
 * @returns : the location of the symbol from the array
 */
int existsInList( FrequencyTracker * array, const char myWord);

/*
 * IncrementCount will go into the array and adjust the frequency of the node
 * whose symbol is located at lineNumber
 * @param lineNumber: the position in the array the symbol is located at
 * @param array : the array of FrequencyTracker nodes
 * @returns void
 */
void incrementCount( FrequencyTracker * array, int lineNumber);

/*
 * We use a slow insertion sort in order to get the frequncy array into
 * descending order
 * @param array: The array of FrequencyTracker nodes that are to be sorted
 * @returns void
 */
void sortElements( FrequencyTracker * array);

/*
 * Inserts the element in the soonest free space avaliable inside of the array.
 * Checks for the size in the beginning and then plops the element inside the
 * spot at 'size'
 * @param array: The array of FrequencyTracker nodes that we want to insert the
 * element into
 * @param element: The node that we want to put inside of the array
 * @returns none.
 */
void insertElement(FrequencyTracker * array, FrequencyTracker element);

/*
 * Processes a given file in order to get a sorted frequency list from it. It
 * handles no real memory management, although a memory management solution can
 * be found within this implementation's test function. The client is
 * responsable for all memory freeing
 * @param fp: the file pointer used to open and read the file
 * @returns: a frequency list
 */
FrequencyTracker * processFile(FILE * fp);

/*
 * Given the array holder, this will go and free every element present within
 * the array, as well as the array itself. It leaves no memory unfreed.
 * @param holder: The array of FrequencyTracker nodes
 * @returns none
 */
void deleteThis(FrequencyTracker * holder);

#endif
