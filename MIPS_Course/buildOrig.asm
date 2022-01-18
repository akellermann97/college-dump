# File:		build.asm
# Author:	K. Reek
# Contributors:	P. White,
#		W. Carithers,
#		Alexander Kellermann Nieves
#
# Description:	Binary tree building functions.
#
# Revisions:	$Log$


	.text			# this is program code
	.align 2		# instructions must be on word boundaries

#
# Name:		add_elements
#
# Description:	loops through array of numbers, adding each (in order)
#		to the tree
#
# Arguments:	a0 the address of the array
#   		a1 the number of elements in the array
#		a2 the address of the root pointer
# Returns:	none
#

	.globl	add_elements

add_elements:
	addi 	$sp, $sp, -16
	sw 	$ra, 12($sp)
	sw 	$s2, 8($sp)
	sw 	$s1, 4($sp)
	sw 	$s0, 0($sp)

#***** BEGIN STUDENT CODE BLOCK 1 ***************************
#
# Insert your code to iterate through the array, calling build_tree
# for each value in the array.  Remember that build_tree requires
# two parameters:  the address of the variable which contains the
# root pointer for the tree, and the number to be inserted.
#
# Feel free to save extra "S" registers onto the stack if you need
# more for your function.
#

#
# If you saved extra "S" reg to stack, make sure you restore them
#

#### MY CODE BEGINS HERE

add_elements_prep:
        move    $s0, $a0        # s0 contains address of the array
        move    $s1, $a1        # s1 contains numbers of elements
        move    $s2, $a2        # s2 contains address of the root pointer
        li      $t0, 0          # t0 will be used for comparisons

add_elements_begin:

# If there are no more elements, exit this function

        beq     $s1, $t0, finish_going_through_array 
        lw      $a1, 0($s0)     # get the number from current address
        addi    $s0, $s0, 4     # move s0 to the next number in the array
        move    $a0, $s2        # a0 now contains address of root pointer
        jal     build_tree      # build the tree!
        
## At this point, a1 contains the number, and a0 contains the address of root
## pointer
        
        
        
        

finish_going_through_array:
        # bottom text


#***** END STUDENT CODE BLOCK 1 *****************************

add_done:

	lw 	$ra, 12($sp)
	lw 	$s2, 8($sp)
	lw 	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addi 	$sp, $sp, 16
	jr 	$ra

#***** BEGIN STUDENT CODE BLOCK 2 ***************************
#
# This is the build tree routine in our code
# param a1: number to be inserted
# param a0: address of root pointer
#
        .globl build_tree

build_tree:
        addi    $sp, $sp, -32
        sw      $ra, 28($sp)
        sw      $s7, 24($sp) 
        sw      $s6, 20($sp) 
        sw      $s5, 16($sp) 
        sw      $s4, 12($sp) 
        sw      $s3, 8($sp) 
        sw      $s2, 4($sp) 
        sw      $s1, 0($sp) 

cleanup_build_tree:
        lw      $ra, 28($sp)
        lw      $s7, 24($sp) 
        lw      $s6, 20($sp) 
        lw      $s5, 16($sp) 
        lw      $s4, 12($sp) 
        lw      $s3, 8($sp) 
        lw      $s2, 4($sp) 
        lw      $s1, 0($sp) 
        addi    $sp, $sp, 32
        jr      $ra


#***** END STUDENT CODE BLOCK 2 *****************************
