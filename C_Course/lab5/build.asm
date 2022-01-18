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
#	address of an array of values	$a0, input_array
#	number of integers in the array	$a1, 
#	pointer to the root of the tree	$a2, ptr_root
# 
iter_prep:
        move    $s0, $a0   # save the register from future function calls
        move    $s1, $a1   # save the register from future function calls
        move    $s2, $a2   # save the register from future function calls
        

iter_through:
        beq     $s1, $zero, iter_finished       # if s1 = 0, no more numbers
        lw      $a1, 0($s0)                     # get the value at current
                                                # place in array
        addi    $s0, $s0, 4                     # move array 1 word forward
        addi    $s1, $s1, -1                    # subtract 1 from count
        move    $s2, $a0                        # move ptr_root into a0
        jal     build_tree
        j       iter_through
                
        

iter_finished:
        #done


#
# If you saved extra "S" reg to stack, make sure you restore them
#
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
# Put your build_tree subroutine here.
#
        .globl  build_tree
        .globl  allocate_mem

# a0 is the ptr_root
# a1 is the number to be inserted

build_tree:
        addi    $sp, $sp, -24
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)
        sw      $s4, 20($sp)

build_tree_prep:
        move    $s0, $a0        # save these from allocate_mem
        move    $s1, $a1

# check to see if tree exists
does_tree_exist:
        lw      $s2, 0($s0)                     # load root
        beq     $s2, $zero, create_tree         # root dne
        j       search_for_member               # root exists
        
create_tree:
        li      $a0, 3          # get 3 words for the node
        jal     allocate_mem
        # v0 now contains what will become the root node
        sw      $a1, 0($v0)     # put number at 0 offest
        sw      $zero, 4($v0)   # put 0 as left node
        sw      $zero, 8($v0)   # put 0 as right node
        sw      $v0, 0($s0)     # move the v0 address into s0
        j       build_done      # we don't need to run any other functions
        

# once tree exists, check if value exists in the tree already. Do this by
# knowing that all values less than root are on left, and all values greater
# than root are on the right
search_for_member:
        # tree must exist in order for this to be run
        

# call allocate_mem, grab the address from v0
allocate_and_add:

build_done:
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        lw      $s4, 20($sp)
        addi    $sp, $sp, 24
        jr      $ra

#***** END STUDENT CODE BLOCK 2 *****************************
