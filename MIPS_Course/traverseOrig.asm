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
# register a0 is the root address
# register a1 is the address of the print function to use
# register a2 is the type of traversal to make (either 0,1,2)

traverse_tree:
        # figure out the travseral and then perform that particular version


traverse_preorder:
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

# print the root
print_root:
        jr      $a1


check_left:
# check if left exists, then visit it
        beq     $s1, $zero, check_right
        move    $a0, $s1
        

check_right:
# check if right exists, then visit it


traverse_pre_done:
        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        lw      $s4, 20($sp)
        addi    $sp, $sp, 24
        jr      $ra

#***** END STUDENT CODE BLOCK 3 *****************************
