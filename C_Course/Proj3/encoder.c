/*
 * @author: Alexander Kellermann Nieves: akn1736
 * @date: November 30th 2016
 * @filename: encoder.c
 */

#include "customLister.h"
#include "HeapDT.h"
#include "encoder.h"
#define EMPTY NULL
#define MAGIC_NUMBER 0x80F0
#define MAX_SIZE 256 // We know that for every thing the max size is 2^8


/* Function used to create Nodes that go into a tree */
TreeNode * createNode(char word, unsigned int count) {
    TreeNode * root = (TreeNode *)calloc(1, sizeof(TreeNode));
    root->left=EMPTY;
    root->right=EMPTY;
    root->symbol=word;
    root->frequency=count;
    return root;
}

char ** tableHelper(TreeNode * root, char * symbol, char ** lookupTable) {

    if(root->right != EMPTY) {
        char * rightcode = malloc(sizeof(char) * MAX_SIZE);
        memset(rightcode, '0', MAX_SIZE); // make sure the string is all zeros
        strcpy(rightcode, symbol);
        strcat(rightcode, "1");
        lookupTable = tableHelper(root->right, rightcode, lookupTable);
    }
    if(root->left != EMPTY) {
        char * leftcode = malloc(sizeof(char) * MAX_SIZE);
        memset(leftcode, '0', MAX_SIZE); // we want to make sure the string is all zero's 
        strcpy(leftcode, symbol);
        strcat(leftcode, "0");
        lookupTable = tableHelper(root->left, leftcode, lookupTable);
    }
    free(symbol);
    return lookupTable;
}

char ** createLookupTable(TreeNode * root) {
    char ** lookupTable = malloc(sizeof(char*) * MAX_SIZE);
    memset(lookupTable, '0', MAX_SIZE);
    int i = 0;
    while( i < MAX_SIZE){
        lookupTable[i] = malloc(sizeof(char) * MAX_SIZE);
        memset(lookupTable[i], '0', MAX_SIZE);
        ++i;
    }

    char * charSymbol = malloc(sizeof(char) * MAX_SIZE);
    
    if(root->left == EMPTY && root->right == EMPTY) {
        // both the children are empty (NULL)
        strcpy(lookupTable[root->symbol], "0");
        free(charSymbol);
    }
    return tableHelper(root, charSymbol, lookupTable);

}

unsigned int * createEncoded(FILE * fp, char ** lookupTable) {
    unsigned int * bitArray = malloc(sizeof(unsigned int) * MAX_SIZE);
    memset(bitArray, '0', MAX_SIZE);
    unsigned char buf;
    unsigned short bitsUsed = 0;
    unsigned int capacity = MAX_SIZE;
    unsigned int intsUsed = 0;
    char * binStr = malloc(sizeof(char) * MAX_SIZE);
    memset(binStr, '0', MAX_SIZE);
    while (fread(&buf, sizeof(unsigned char), 1, fp)) {
        strcpy(binStr, lookupTable[buf]); 
        for( unsigned int i = 0; i < strlen(binStr); ++i) {
            if(binStr[i] == '0') {
                bitArray[intsUsed+1] <<= 1;
            } else if(binStr[i] == '1') { 
                bitArray[intsUsed+1] <<=1;
                bitArray[intsUsed+1] |= 1;
            }
            bitsUsed += 1;

            if(bitsUsed >= sizeof(unsigned int)*8) {
                intsUsed += 1;
                bitsUsed = 0;
            }

            if(intsUsed+2 >= capacity) {
                unsigned int * temp = realloc(bitArray, capacity*sizeof(unsigned int)+(MAX_SIZE*sizeof(unsigned int)));
                capacity += MAX_SIZE;

                if(temp == EMPTY) {
                    perror("Failed to allocate memory");
                    exit(EXIT_FAILURE);
                }
                bitArray = temp;
            }
        }
    }

    free(binStr);
    for(unsigned int i = bitsUsed; i < sizeof(unsigned int)*8; ++i) {
        bitArray[intsUsed+1] <<= 1;
    }
    bitArray[0] = ((intsUsed)*sizeof(unsigned int)*8) + bitsUsed;
    return bitArray;
}

void writeBitArray(FILE * fp, unsigned int * bitArray) {
    for(unsigned int i = 0; i <= (unsigned int)(32+bitArray[0])/(sizeof(int)*8); ++i) {
        fwrite(&bitArray[i], sizeof(unsigned int), 1, fp);
    }
}



/* This just writes 0x80F0 to the beginning of a file */
void placeMagicAtBeginningOfFile(FILE * file){
    fwrite(&getMagic, sizeof(unsigned short), 1, file);
}

/* Function used to compare two nodes of a tree by frequency */
int compareFunc(const void * one, const void * two){
    return (((TreeNode *)one)->frequency < ((TreeNode *)two)->frequency);
} 

/* This function creates the heap by initializing all of the thing required by
 * HeapDT.h and then invoking the commands inside of that file.
 * Once the heap has been built, we go straight to building the Tree, and then
 * we return it 
 */
TreeNode * buildTree( FrequencyTracker * holder){
    int(* compFun)(const void * lhs, const void * rhs) = &compareFunc;
    void(* dumpEntry)(const void *, FILE *) = EMPTY; // Make sure to either delete this or make it work before submitting to try.
    Heap myHeap  = createHeap(256, compFun, dumpEntry);
    unsigned int i = 0;
    // First we need to generate the heap. We're just putting the
    // FrequencyTracker objects into this file
    while(holder[i] != EMPTY){
        insertHeapItem(myHeap,  holder[i]);
        ++i;
    }

    while(sizeHeap(myHeap) > 1) {
        TreeNode * nodeLeft = removeTopHeap(myHeap);
        TreeNode * nodeRight = removeTopHeap(myHeap);
        TreeNode * nodeX = createNode(' ', (nodeLeft->frequency + nodeRight->frequency));
        nodeX->left = nodeLeft;
        nodeX->right = nodeRight;
        insertHeapItem(myHeap, nodeX);
    }

    // Now we should have the beginnings of a huffman Tree
    TreeNode * huffmanTree = removeTopHeap(myHeap);
    destroyHeap(myHeap);
    return huffmanTree;
}

void deleteTreeMemory(TreeNode * root) {
    if(root == EMPTY){
        // Base case, the root has nothing
        return;
    } else if (root != EMPTY){
        deleteTreeMemory(root->right);
        deleteTreeMemory(root->left);
        free(root);
    } else {
        fprintf(stderr,"Memory error, we counted something that needs to be fixed.  This error is located on line %d in file %s", __LINE__, __FILE__);
    }
}

void writeTreeHelper(FILE * fp, TreeNode * tree) {
    if(tree->left != EMPTY || tree->right != EMPTY) {
        unsigned char zero = '0';
        fwrite(&zero, sizeof(unsigned char), 1, fp);
        writeTreeHelper(fp, tree->left);
        writeTreeHelper(fp, tree->right);
    }
    if(tree->left == EMPTY && tree->right == EMPTY) {
        unsigned char one = '1';
        unsigned char * sym = malloc(sizeof(unsigned char *));
        *sym = tree->symbol;
        fwrite(&one, sizeof(unsigned char), 1, fp);
        fwrite(sym, sizeof(unsigned char), 1, fp);
        free(sym);
    }
}

void writeTree(FILE * fp, TreeNode * tree) {
    unsigned char bits = 8;
    fwrite(&bits, sizeof(unsigned char), 1, fp);
    writeTreeHelper(fp, tree);
}

void readTreeHelper(FILE * fp, TreeNode ** tree, int leafBits) {
    unsigned char buf;
    fread(&buf, leafBits/8, 1, fp);
    if (buf == '1') {
        fread(&buf, leafBits/8, 1, fp);
        * tree = createNode(buf, 0);
    } else if(buf == '0') {
        if(*tree == EMPTY) {
            *tree = createNode(' ', 0);
        }
        readTreeHelper(fp, &((*tree)->left), leafBits);
        readTreeHelper(fp, &((*tree)->right), leafBits);
    }
}

TreeNode * readTree(FILE * fp) {
    unsigned char size;
    fread(&size, sizeof(unsigned char), 1, fp);
    TreeNode * tree = EMPTY;
    readTreeHelper(fp, &tree, 8);
    return tree;
}


/* This will be a small little test program */
int main(void){
    FILE * fp;
    fp = fopen("HeapDT.h", "r");
    FrequencyTracker * pray = processFile(fp);
    sortElements(pray);
    printElements(pray);
}
