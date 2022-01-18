# File:		add_ascii_numbers.asm
# Author:	K. Reek
# Contributors:	P. White, W. Carithers
#		Alexander Kellermann Nieves  (akn1736)
#
# Updates:
#		3/2004	M. Reek, named constants
#		10/2007 W. Carithers, alignment
#		09/2009 W. Carithers, separate assembly
#
# Description:	Add two ASCII numbers and store the result in ASCII.
#
# Arguments:	a0: address of parameter block.  The block consists of
#		four words that contain (in this order):
#
#			address of first input string
#			address of second input string
#			address where result should be stored
#			length of the strings and result buffer
#
#		(There is actually other data after this in the
#		parameter block, but it is not relevant to this routine.)
#
# Returns:	The result of the addition, in the buffer specified by
#		the parameter block.
#

	.globl	add_ascii_numbers

add_ascii_numbers:
A_FRAMESIZE = 40

#
# Save registers ra and s0 - s7 on the stack.
#
	addi 	$sp, $sp, -A_FRAMESIZE
	sw 	$ra, -4+A_FRAMESIZE($sp)
	sw 	$s7, 28($sp)
	sw 	$s6, 24($sp)
	sw 	$s5, 20($sp)
	sw 	$s4, 16($sp)
	sw 	$s3, 12($sp)
	sw 	$s2, 8($sp)
	sw 	$s1, 4($sp)
	sw 	$s0, 0($sp)
	
# ##### BEGIN STUDENT CODE BLOCK 1 #####

        .data 
        .align 0
testing:
        .word 9                 # set up a data segment for testing
        .word 23
        .word 34
        .word 49

wordz:
        .ascii "7"

        .text
        .align 2

else:

# I want to test the program by writing nonsense results to the result. But I
# can't seem to get the result to change. This makes debugging the program
# difficult. 

        lw      $s0, 0($a0)     # This stores the first string
        lw      $s1, 4($a0)     # This stores the second string
        lw      $s2, 8($a0)     # This stores the addr of where 2 put result.
        lw      $s3, 12($a0)    # Length of the string
        lw      $s4, 16($a0)    # Result (This is only a string)

        la      $s5, wordz
        lw      $s6, 0($s5)     # s6 should now contain ascii 7

        sw      $s5, 16($a0)

        li      $t0, 0          # This will be the counter for the loop

addloop:
        beq     $t0, $s3, endLoop       # When t0==s3, exit
        addi    $t0, $t0, 1

        j       addloop
        


endLoop:
        
        
## Attempting to write to the word block


# ###### END STUDENT CODE BLOCK 1 ######

#
# Restore registers ra and s0 - s7 from the stack.
#
	lw 	$ra, -4+A_FRAMESIZE($sp)
	lw 	$s7, 28($sp)
	lw 	$s6, 24($sp)
	lw 	$s5, 20($sp)
	lw 	$s4, 16($sp)
	lw 	$s3, 12($sp)
	lw 	$s2, 8($sp)
	lw 	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addi 	$sp, $sp, A_FRAMESIZE

	jr	$ra			# Return to the caller.
