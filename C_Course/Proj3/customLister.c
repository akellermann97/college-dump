/*
 * @author: Alexander Kellermann Nieves: akn1736
 * @date: November 30th
 * @file: customLister.c
 * This file shows how we create and organize a frequency table for the project
 */


#include "customLister.h"
#include "HeapDT.h"

// If we're using 8 bit bytes, then we know the maximum amount of symbols is
// 255.
#define ARRAYSIZE 255

// The internal structure that will be used to store the key, value pair. Not
// enough time to create a hashMap, which would have been used if the
// programming language were Java, and had one built in.
struct FreqKeep_thing {
    char word;
    unsigned count;
} ;

// Creates an element and returns it.
FrequencyTracker createElement(const char myWord){
    FrequencyTracker element = malloc(sizeof(struct FreqKeep_thing));
    element->word=(char)myWord;
    element->count=1;
    return element;
}

// prints all the elements in the array in a nice, easy to read format
void printElements( FrequencyTracker * array){
    printf("Frequency\tValue\n");
    printf("----------------------\n");
    int i = 0;
    while(array[i] != NULL){
        printf("%d\t\t%c\n",array[i]->count, array[i]->word);
        ++i;
    }
}


// Traverses the entire array and checks to see if the word already exists in
// the array, returns true if it does and false otherwise
int existsInList( FrequencyTracker * array, const char myWord){
    int i = 0;
    while(array[i] != NULL){
        if(myWord == array[i]->word){
            return i;
            // It exists in the array
            // And I is its line number
        }
        ++i;
    }
    return -1; // It shouldn't exist in the array
}

// Should increment the count of whatever exists at 'linenumber'
void incrementCount( FrequencyTracker * array, int lineNumber){
    assert(array[lineNumber] != NULL);
    array[lineNumber]->count = (array[lineNumber]->count+=1);
}

// this function will take the array and sort it in place.
// This sort function uses insert sort because there's no time to figure out
// how to use any other sort
void sortElements( FrequencyTracker * array){
    // First we want to generate the size of the sortable portions of the array
    int size = 0;
    while(size < 255){ 
        if(array[size] != NULL)
            ++size;
        else
            break;
    }
    //printf("size is: %i\n", size);

    // now we want to sort them
    int i = 0;
    int key= 0;
    int value = 0;
    int j = 0; 


    for( i = 1; i < size; ++i ){
        // key is the count
        key = array[i]->count;
        // value is the word
        value = array[i]->word;
        j = i-1;

        while(j >= 0 && (array[j]->count) > key){
            array[j+1]->word = array[j]->word;
            array[j+1]->count = array[j]->count;
            j = j-1;
        }
        array[j+1]->count = key;
        array[j+1]->word = value;
    }
}

// Will find the nearest empty slot in the array and will insert the element in
// its place
void insertElement(FrequencyTracker * array, FrequencyTracker element){
    int size = 0;
    while(size < 255){ 
        if(array[size] != NULL)
            ++size;
        else
            break;
    }
    array[size] = element;
}

// Given a file pointer, this function will go in and populate an array with
// all the unique symbols present in the file
FrequencyTracker * processFile(FILE * fp){
    FrequencyTracker * holder = calloc(sizeof(struct FreqKeep_thing), ARRAYSIZE);
    int charmander = fgetc(fp);
    int temp;
    while(charmander != EOF){
        temp = existsInList(holder, charmander);
        if(temp == -1){
            insertElement(holder, createElement(charmander));
        } else {
            // this is when we know it exists in the array, so we just want to
            // increment the count
            incrementCount(holder, temp);
        }
        //printf("Character: %c\n", charmander);
        charmander = fgetc(fp);
    }
    return holder;
}

// Deletes allocated memory
void deleteThis(FrequencyTracker * holder){
    int i = 0;
    while(holder[i] != NULL){
        free(holder[i]);
        ++i;
    }
}

void test(){
    // this is just a function used for testing.
    //FrequencyTracker thing[ARRAYSIZE];
    FrequencyTracker alex = malloc(sizeof(struct FreqKeep_thing));
    alex->count=1;
    alex->word=(char)'a';
    printf("alex: has the number %d, and the letter %c\n", alex->count, alex->word);
    ///////////////////////////////
    printf("Let's try to run some tests!\n");
    FrequencyTracker test = createElement((char)'%');
    printf("test: has the number %d, and the letter %c\n", test->count, test->word);
    //////////////////////////////
    printf("Now let's try to get some arrays to work!\n");
    FrequencyTracker* holder = calloc(sizeof(struct FreqKeep_thing), ARRAYSIZE);
    holder[0] = alex;
    holder[1] = test;
    holder[2] = createElement('W');
    printElements(holder);
    printf("Does 'b' exist in holder? %d\n", existsInList(holder, 'b'));
    holder[3] = createElement('b');
    printf("Does 'b' exist in holder? %d\n", existsInList(holder, 'b'));
    // At this point we know that exists works, create elements work, now we
    // need to be able to increment things that are already in the list!
    int liner = existsInList(holder, 'W');
    incrementCount(holder, liner);
    printElements(holder);
    sortElements(holder);
    printElements(holder);
    insertElement(holder, createElement('F'));
    holder[5] = createElement('G');
    printElements(holder);
}

// A function used for testing
int main(void){
    // Now let's try to read a file and test our little program! <3

    FILE * fp;  
    fp = fopen("HeapDT.h", "r");
    FrequencyTracker * pray = processFile(fp);
    sortElements(pray);
    printElements(pray);
    
    fclose(fp);
    deleteThis(pray);
    free(pray);
}
