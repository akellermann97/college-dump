#include "customLister.h"
#include "HeapDT.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

const unsigned short getMagic = 0x80F0;

typedef struct TreeNodeS {
    int frequency;
    unsigned char symbol;
    struct TreeNodeS * left;
    struct TreeNodeS * right;
} TreeNode;

TreeNode * createNode(char word, unsigned int count);

char ** tableHelper(TreeNode * root, char * symbol, char ** lookupTable);

char ** createLookupTable(TreeNode * root);

unsigned int * createEncoded(FILE * fp, char ** lookupTable);

void writeBitArray(FILE * fp, unsigned int * bitArray);

void placeMagicAtBeginningOfFile(FILE * file);

int compareFunc(const void * one, const void * two);

TreeNode * buildTree( FrequencyTracker * holder);

void deleteTreeMemory(TreeNode * root);

void writeTreeHelper(FILE * fp, TreeNode * tree);

void writeTree(FILE * fp, TreeNode * tree);

void readTreeHelper(FILE * fp, TreeNode ** tree, int leafBits);

TreeNode * readTree(FILE * fp);
