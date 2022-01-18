# File:		traverse_tree.asm
# Author:	K. Reek
# Contributors:	P. White,
#		W. Carithers,
#		Alexander Kellermann Nieves
#
# Description:	Binary tree traversal functions.
#
# Revisions:	$Log$


# CONSTANTS
#

# traversal codes
PRE_ORDER  = 0
IN_ORDER   = 1
POST_ORDER = 2

	.text			# this is program code
	.align 2		# instructions must be on word boundaries

#***** BEGIN STUDENT CODE BLOCK 3 *****************************
#
# Put your traverse_tree subroutine here.
# 

	.globl	traverse_tree
	.globl	print_func1
	.globl	print_func2
        .globl  main

# register a0 is the root address
# register a1 is the address of the print function to use
# register a2 is the type of traversal to make (either 0,1,2)

        # figure out the travseral and then perform that particular version


traverse_tree:
        # We already know which thing we're trying to do
        # Pre order is root, left, right
        # we print the root. 
        # we then go to the left
        # we then go to the right
        addi    $sp, $sp, -24
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)
        sw      $s2, 12($sp)
        sw      $s3, 16($sp)
        sw      $s4, 20($sp)

bounds_stuff:
        move    $s1, $a0        # store the values of the root node into a safe
                                # register 
        li      $s4, PRE_ORDER
        beq     $a2, $s4, print_root_pre
        li      $s4, IN_ORDER
        beq     $a2, $s4, check_left_post
        li      $s4, POST_ORDER
        beq     $a2, $s4, check_left_post
        j       traverse_done

check_left_post:
# Check if there's anything to the left
        lw      $a0, 4($s1)
        beq     $a0, $zero, check_right_post       # goto print if no left
        jal     traverse_tree
        

check_right_post:
        # check if there's anything to the right
        lw      $a0, 8($s1)
        beq     $a0, $zero, print_root_post       # goto print if no left
        jal     traverse_tree

print_root_post:
        # check if there's anything straight ahead
        move    $a0, $s1
        jal     print_func1
        j       traverse_done
        
check_left_in: 
        # If there is an element on the left, visit it
        lw      $a0, 4($s1)                     # puts left node mem into a0
        beq     $a0, $zero, print_root_in       # if it equals 0, we know to
                                                # print root
        jal     traverse_tree                   # if it isn't zero, we call
                                                # traverse tree on that location

print_root_in:
        # print the value 
        move    $a0, $s1
        jal     print_func1
        j       check_right_in

check_right_in: 
# If there is an element on the right, visit it.
# Otherwise, quit
        lw      $a0, 8($s1)
        beq     $a0, $zero, traverse_done
        jal     traverse_tree

print_root_pre:
# print the root
        jal     print_func1
        j       check_left_pre
        # fall through is okay (one less instruction this way)

check_left_pre:
# check if left exists, then visit it
        lw      $a0, 4($s1)
        beq     $a0, $zero, check_right_pre
        jal     traverse_tree

check_right_pre:
# check if right exists, then visit it
# otherwise, quit
        lw      $a0, 8($s1)
        beq     $a0, $zero, traverse_done
        jal     traverse_tree

traverse_done:
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        lw      $s4, 20($sp)
        addi    $sp, $sp, 24
        jr      $ra

#***** END STUDENT CODE BLOCK 3 *****************************
