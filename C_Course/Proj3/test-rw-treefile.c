//
// File: test-rw-treefile.c 
// Description: 
//    test the tools to read and write trees
//
// @author bksteele bks@cs.rit.edu
//
// compile flags: -std=c99 -ggdb -Wall -Wextra -pedantic -c
// link flags: -lm
//
// // // // // // // // // // // // // // // // // // // // // // // //

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include "packman_utils.h"

static void write1( void) {
    TreeNode tree = NULL;
    char * filename = "binput.1";
    printf( "writing file '%s'\n", filename );
    // generate binary test files
    FILE * fp = fopen( filename, "w" );
    assert( fp );
    // notes: write1 makes a single leaf node, the smallest tree.
    tree = createTreeNode( 'I', 1 );
    writeTree( fp, tree);
    freeTreeNode( tree);
    fclose( fp);
}

static void write2( void) {
    TreeNode tree = NULL;
    char * filename = "binput.2";
    printf( "writing file '%s'\n", filename );
    // generate binary test files
    FILE * fp = fopen( filename, "w" );
    assert( fp );
    // notes: write2 makes a 3 node tree, the smallest meaningful tree.
    tree = createTreeNode( 'Y', 2 );
    tree->left = createTreeNode( 'A', 1 );
    tree->right = createTreeNode( 'D', 1 );
    writeTree( fp, tree);
    freeTreeNode( tree);
    fclose( fp);
}

static void write3( void) {
    TreeNode tree = NULL;
    char * filename = "binput.3";
    printf( "writing file '%s'\n", filename );
    // generate binary test files
    FILE * fp = fopen( filename, "w" );
    assert( fp );
    // notes:
    // frequency numbers (e.g. 85) are not stored in the tree.
    // the sequence numbers (e.g. '0') are internal node labels.
    tree = createTreeNode( '0', 85 );
    tree->left = createTreeNode( '1', 33 );
    tree->left->left = createTreeNode( 'A', 1 );
    tree->left->right = createTreeNode( 'D', 1 );

    tree->right = createTreeNode( '2', 52 );
    tree->right->left = createTreeNode( 'F', 1 );
    tree->right->right = createTreeNode( '6', 27 );

    tree->right->right->left = createTreeNode( 'C', 1 );
    tree->right->right->right = createTreeNode( '8', 15 );
    tree->right->right->right->left = createTreeNode( 'B', 1 );
    tree->right->right->right->right = createTreeNode( 'E', 1 );
    writeTree( fp, tree);
    freeTreeNode( tree);
    fclose( fp);
}

/// main function tests the reading/writing of tree data.
/// Without a filename argument, create a test file.
/// With a filename argument, print the content of the given filename.
/// @param argc 1 or 2
/// @param argv optional binary file to read and print
///
int main( int argc, char * argv[] ) {

    printf( "usage: test-rw-treefile [treefile] \n" );
    if ( argc < 2 ) {

        write1();
        write2();
        write3();

    } else {

        TreeNode tree = NULL;
        // read binary file named on command line
        printf( "reading: %s...\n", argv[1] );
        FILE * fp = fopen( argv[1], "r" );
        assert( fp );
        tree = readTree( fp );
        printTree( tree );
        freeTreeNode( tree);
        fclose( fp);

    }
    return 0 ;
}

// // // // // // // // // // // // // // // // // // // // // // // //
// Revisions:
// See 'git log'
// master repo: ~csci243/GIT/Projects/Packman/
