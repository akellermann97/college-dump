# File:		$Id$
# Author:	J. Heliotis, (author's version 1.3)
# Contributors:	K. Reek, 
# 		P. White, 
#	        Alexander Kellermann Nieves
# Description:	This program reads a description of a geometric
#		figure from standard input and displays some
#		further information about it. Currently, the
#		program handles two types of figures: blocks
#		(rectangles) and circles.
#
# Purpose:	To demonstrate the implementation of polymorphic
#		subroutine calls
#
# Revisions:	$Log$
#		4/1/04	M. Reek changed to use MIPS linkage conventions
#
# CONSTANTS
#
# syscall codes
PRINT_INT =	1
PRINT_STRING = 	4
READ_INT = 	5
READ_STRING =	8

# various frame sizes used by different routines

FRAMESIZE_8 = 	8
FRAMESIZE_24 =	24
FRAMESIZE_40 =	40
FRAMESIZE_48 =	48

	.data
	.align 2

	#
	# Memory for allocating up to 100 figures.
	#
next:	
	.word	pool		# ptr into the pool where next free
				# space is located
pool:	
	.space	1200		# room for 100 figures
pool_end:			# a marker for the end of the free space
	.word	0		# used to tell us if we are out of mem

fig_width:
	.word	0
fig_height:
	.word	0

	.align 0
fig_char:
	.asciiz	"0123456789"	# I know this isn't a character, but
				# SPIMs only has read_string, which 
				# reads to eol and then null
				# terminates the string it read in

	#
	# some constants for the code
	#
PI	= 3			# an bad integer approx. to pi, 3.14159...

char_c:	
	.ascii	"C"
char_b:	
	.ascii	"B"

new_error:
	.asciiz	"Out of memory for allocating figures.\n"

figure_type_error_string:
	.asciiz	"Illegal figure type\n"

circle_string:
	.asciiz	"Circle ("

block_string:
	.asciiz	"Block ("

comma_string:
	.asciiz	","

area_string:
	.asciiz	") - area = "

perimeter_string:
	.asciiz	"; perimeter = "

new_line:
	.asciiz	"\n"

#
# Name:		MAIN PROGRAM
#
# Description:	Main logic for the program.
#
#		The program reads three values from standard input:
#		1) a character representing the type of figure to create
#		2) an integer representing the width of the bounding box
#			of the figure
#		3) an integer representing the height of the bounding box
#			of the figure
#
#		After creating the specified figure object, the program then
#		displays all available information on the object created.
#

	.text			# this is program code
	.align 2		# instructions must be on word boundaries
	.globl main		# main is a global label

main:
	# allocate stack frame according to formula & save state

	addi 	$sp, $sp,-FRAMESIZE_24   	
	sw 	$ra, -4+FRAMESIZE_24($sp)	
	sw 	$s1, -8+FRAMESIZE_24($sp)
	sw 	$s0, -12+FRAMESIZE_24($sp)

	#
	# Read the character representing the figure type
	#

	li 	$v0, READ_STRING	# read a string	
	la 	$a0, fig_char	# place to store the char read in
	addi	$a1, $zero, 9	# the number of characters to read
	syscall

	#
	# Read the width into r1
	#
	li	$v0, READ_INT
	syscall
	move	$s0, $v0

	#
	# Read the height into r2
	#
	li	$v0, READ_INT
	syscall
	move	$s1, $v0

	#
	# Do the output
	#
	move	$a0, $s0
	move	$a1, $s1
	jal	output_figures

#
# All done -- exit the program!
#
	lw 	$ra, -4+FRAMESIZE_24($sp)	
	lw 	$s1, -8+FRAMESIZE_24($sp)
	lw 	$s0, -12+FRAMESIZE_24($sp)

	addi 	$sp, $sp, FRAMESIZE_24   	
	jr 	$ra		# return from main and exit spim
	

# ***********************************************************************
# *                                                                     *
# * THIS IS THE START OF EXPERIMENT-SPECIFIC CODE                       *
# *                                                                     *
# ***********************************************************************

# Name:		Constants to keep in mind while working with figures
#

# A Figure contains three words 
#		address of virtual function table at offset 0 in fig object
#		figure width 	at offset 4 in fig object
#		figure height 	at offset 8 in fig object
# Making the figures size as 12 bytes

# A Figure virtual function table contains two function addresses (words):
#		addr area function 	at offset 0 in vtable
#		addr perimeter function	at offset 4 in vtable
#

#
# Name:		new_figure
#
# Description:	Allocate space for a new figure from the pool of
#		available space. Luckily, both subclasses of FIGURE
#		take up the same amount of space.
#
# Arguments:	None.
# Returns:	v0: the address of the newly allocated figure.
#

new_figure:
	#
	# See if there is any space left in the pool.
	#

	lw	$t0, next
	la	$t1, pool_end

	slt	$t2, $t0, $t1	# Compare next addr to end of pool
	bne	$t2, $zero, new_figure_ok	#  if less, still have space

	#
	# No space left; write error message and exit.
	#

	li 	$v0, PRINT_STRING	# print error message
	la 	$a0, new_error
	syscall	

	li 	$v0, 10		# terminate program
	syscall	

new_figure_ok:
	#
	# There is space available.  Allocate the next figure, and
	# initialize all of its fields.
	#

	move	$v0, $t0	# set up to return spot for new figure
	addi	$t0, $t0, 12	# Adjust pointer to next figure
	sw	$t0, next

	#
	# Clear all fields.
	#

	sw	$zero, 0($v0)
	sw	$zero, 4($v0)
	sw	$zero, 8($v0)

	jr	$ra


#
# Name:		figure_make
#
# Description:	Initialize the components of the figure object.
#		Since FIGURE is an abstract class, it is expected that
#		the creation subroutines for child classes will call this
#		subroutine.
#
# Arguments:	a0 contains the height of the figure's bounding box
#		a1 contains the width of the figure's bounding box
#		a2 contains the address of the figure object
#
figure_make:

	sw 	$a1, 4($a2)	# store the width in the fig object
	sw 	$a0, 8($a2)	# store the height in the fig object

	jr	$ra

# CODE FOR FIGURE SUBCLASS BLOCK

#***** BEGIN STUDENT CODE BLOCK 1 ********************************
#
# Using the circle code below as your guide, write everything
# necessary to implement the FIGURE child class called BLOCK.
# This involves defining BLOCK's virtual function table, its
# creation routine, block_make, and its two virtual (polymorphic)
# functions, block_area and block_perimeter.
#

        .data 
        .align 2

block_vtb1:
        .word   block_area
        .word   block_perimeter

        .text

block_make:
        addi    $sp, $sp, -FRAMESIZE_8
        sw      $ra, -4+FRAMESIZE_8($sp)

        la      $t1, block_vtb1         # get blocks vtable pointer
        sw      $t1, 0($a2)

        jal     figure_make

        lw      $ra, -4+FRAMESIZE_8($sp) # return the return address
        addi    $sp, $sp, FRAMESIZE_8
        jr      $ra

block_area:
        # This routine is entirely stolen from the circle's routine. Saving the
        # return address register is unnecessary, but I kept it just in case I
        # need to revist this function and use it.
        #  Arguments:   a0 contains the address of the figure object
        #
        # Returns: v0 will contain the area of the block

        addi    $sp, $sp, -FRAMESIZE_8
        sw      $ra, -4+FRAMESIZE_8($sp)

        # This is where the PI is in the other function but we don't need that
        # in our functoin
        lw      $t0, 4($a0)     # Get the width
        lw      $t1, 8($a0)     # Get the height

        mul     $v0, $t0, $t1   # Multiply width times height put result in v0

        lw      $ra, -4+FRAMESIZE_8($sp)
        addi    $sp, $sp, FRAMESIZE_8
        jr      $ra

block_perimeter:
        # Easy maths on this one. Just do two simple add additions. (or if one
        # prefers, one could perform 2 multiplications) and then a third to
        # combine. Return that
        # Arguments:    a0 contains the address of the figure object
        #
        # returns:      v0 contains the perimeter
        lw      $t0, 4($a0)     # Get the width
        lw      $t1, 8($a0)     # Get the height
        
        # I duplicate t0 just because I'm worried of what MIPS might do  
        move    $t2, $t0        # Probably unnecessary
        add     $t0, $t2, $t0   # t0 = t0 + t0
        move    $t2, $t1        # Probably unnecessary
        add     $t1, $t2, $t1   # t1 = t1 + t1
        
        add     $v0, $t1, $t0   # This boils down to v0 = 2(t1) + 2(t0)

        jr      $ra
        
#***** END STUDENT CODE BLOCK 1 **********************************

# CODE FOR FIGURE SUBCLASS CIRCLE

#************************************
	.data
	.align	2

circle_vtbl:
	.word	circle_area
	.word	circle_perimeter

	.text
#************************************
#
# Name:		circle_make
#
# Description:	Initialize the components of the circle object
#		All this subroutine does is set the virtual function
#		table, then call figure_make.
#
# Arguments:	a0 contains the height of the figure's bounding box
#		a1 contains the width of the figure's bounding box
#		a2 contains the address of the figure object
#

circle_make:
	addi 	$sp, $sp,-FRAMESIZE_8
	sw 	$ra, -4+FRAMESIZE_8($sp)

	la	$t1, circle_vtbl	# get circle's vtable pointer
	sw	$t1, 0($a2)	# put circle's vtable pointer into this fig
				# object
	jal	figure_make

	lw 	$ra, -4+FRAMESIZE_8($sp)  # get ra off stack, and restore
	addi 	$sp, $sp, FRAMESIZE_8
	jr	$ra

#
# Name:		circle_area
#
# Description:	Compute the area of the circle figure
#
# Arguments:	a0 contains the address of the figure object
#
# Returns:	v0 contains the area
#
circle_area:
	addi 	$sp, $sp,-FRAMESIZE_8
	sw 	$ra, -4+FRAMESIZE_8($sp)

	li	$t9, PI		# get our int approx. for PI = 3

	jal	circle_diameter	# get my diameter in v0
	
	div	$t0, $v0, 2	# t0 = radius
	mul	$t1, $t0, $t0	# t1 = radius squared
	mul	$v0, $t1, $t9	# v0 = PI * radius squared

	lw 	$ra, -4+FRAMESIZE_8($sp)	# restore ra from stack
	addi 	$sp, $sp, FRAMESIZE_8
	jr	$ra

#
# Name:		circle_perimeter
#
# Description:	Compute the perimeter of the circle figure
#
# Arguments:	a0 contains the address of the figure object
#
# Returns:	v0 contains the perimeter
#
circle_perimeter:
	addi 	$sp, $sp,-FRAMESIZE_8
	sw 	$ra, -4+FRAMESIZE_8($sp)

	li	$t9, PI		# get our int approx. for PI = 3

	jal	circle_diameter	# get my diameter in v0
	
	mul	$v0, $v0, $t9	# v0 = PI * diameter

	lw 	$ra, -4+FRAMESIZE_8($sp)	# restore ra from stack
	addi 	$sp, $sp, FRAMESIZE_8
	jr	$ra

#
# Name:		circle_diameter
#
# Description:	Compute the diameter of the circle figure
#
# Arguments:	a0 contains the address of the figure object
#
# Returns:	v0 contains the diameter
#
circle_diameter:
	lw	$t0, 4($a0)	# get fig's width
	lw	$t1, 8($a0)	# get fig's height

	slt	$t2, $t0, $t1	# see if width < height
	beq	$t2, $zero, cd_height_bigger

	move	$v0, $t0	# width is smaller
	jr	$ra

cd_height_bigger:
	move	$v0, $t1	# height is smaller
	jr	$ra

#
# Name:		output_figures
#
# Description:	Given the paramters for a figure, make one and print out
#		its attributes.
#
# Arguments:	fig_char: Character representing figure type
#		a0: width
#		a1: height
#
#
output_figures:
	addi	$sp, $sp,-FRAMESIZE_48
	sw	$ra, -4+FRAMESIZE_48($sp)
	sw	$s7, -8+FRAMESIZE_48($sp)
	sw	$s6, -12+FRAMESIZE_48($sp)
	sw	$s5, -16+FRAMESIZE_48($sp)
	sw	$s4, -20+FRAMESIZE_48($sp)
	sw	$s3, -24+FRAMESIZE_48($sp)
	sw	$s2, -28+FRAMESIZE_48($sp)
	sw	$s1, -32+FRAMESIZE_48($sp)
	sw	$s0, -36+FRAMESIZE_48($sp)

	move	$s3, $a0	# s3 will be the width
	move	$s4, $a1	# s4 will be the height

	jal	new_figure	# create a new figure
	move	$s1, $v0	# save the pointer to the fig object

	#
	# Now, see which one we should make
	#

	lbu	$s6, char_c	# get our characters for comparison
	lbu	$s7, char_b

	lbu	$s5, fig_char	# get the type of fig to create

	bne	$s5, $s6, not_circle  # see if creating a circle
	#
	# Set up the arguments to the circle_make call
	# 	a0 contains the height of the figure's bounding box
	# 	a1 contains the width of the figure's bounding box
	#	a2 contains the address of the figure object
	#
	move	$a0, $s4		# s4 was the height
	move	$a1, $s3		# s3 was the width
	move	$a2, $s1		# s1 was the location of new fig object
	jal	circle_make


	#
	# Print "Circle ("
	#

	li 	$v0, PRINT_STRING	# print a "Circle ("
	la 	$a0, circle_string
	syscall	

	move	$a0, $s1		# send the pointer to the fig object
				# as the arg. to print_rest
	jal	print_rest	# print rest of info of the fig
	j 	done_output


not_circle:
	bne	$s5, $s7, not_anything  # see if creating a block
	#
	# Set up the arguments to the block_make call
	# 	a0 contains the height of the figure's bounding box
	# 	a1 contains the width of the figure's bounding box
	#	a2 contains the address of the figure object
	#
	move	$a0, $s4		# s4 was the height
	move	$a1, $s3		# s3 was the width
	move	$a2, $s1		# s1 was the location of new fig object
	jal	block_make


	#
	# Print "Block ("
	#

	li 	$v0, PRINT_STRING	# print a "Block ("
	la 	$a0, block_string
	syscall	

	move	$a0, $s1		# send the pointer to the fig object
				# as the arg. to print_rest
	jal	print_rest	# print rest of info of the fig
	j 	done_output

not_anything:
	#
	# Print error message
	#

	li 	$v0, PRINT_STRING
	la 	$a0, figure_type_error_string
	syscall	

	#
	# exit
	#

done_output:
	lw	$ra, -4+FRAMESIZE_48($sp)
	lw	$s7, -8+FRAMESIZE_48($sp)
	lw	$s6, -12+FRAMESIZE_48($sp)
	lw	$s5, -16+FRAMESIZE_48($sp)
	lw	$s4, -20+FRAMESIZE_48($sp)
	lw	$s3, -24+FRAMESIZE_48($sp)
	lw	$s2, -28+FRAMESIZE_48($sp)
	lw	$s1, -32+FRAMESIZE_48($sp)
	lw	$s0, -36+FRAMESIZE_48($sp)
	addi	$sp, $sp, FRAMESIZE_48

	jr	$ra

#
# Name:		print_rest
#
# Description:	prints out the information about a figure
#
# Arguments:	a0: contains the address of the figure object
#

print_rest:
	#
	# Save all the S registers & ra
	#
	addi	$sp, $sp,-FRAMESIZE_40
	sw	$ra, -4+FRAMESIZE_40($sp)
	sw	$s7, -8+FRAMESIZE_40($sp)
	sw	$s6, -12+FRAMESIZE_40($sp)
	sw	$s5, -16+FRAMESIZE_40($sp)
	sw	$s4, -20+FRAMESIZE_40($sp)
	sw	$s3, -24+FRAMESIZE_40($sp)
	sw	$s2, -28+FRAMESIZE_40($sp)
	sw	$s1, -32+FRAMESIZE_40($sp)
	sw	$s0, -36+FRAMESIZE_40($sp)

	move	$s0, $a0	# s0 will be your pointer to figure
				# since a0 is needed by the syscalls

#***** BEGIN STUDENT CODE BLOCK 2 ********************************
#
# Print the figure's width using PRINT_INT. At this point, s0 contains
# the address of the figure object, and shouldn't be changed.
#
# Note that this does not involve any polymorphic functions.
#
        
# Remember s0 is the address. So we need to print it's width

        lw      $a0, 4($s0)
        li      $v0, PRINT_INT
        syscall
#***** END STUDENT CODE BLOCK 2 **********************************

	li 	$v0, PRINT_STRING	# print ','
	la 	$a0, comma_string
	syscall

#***** BEGIN STUDENT CODE BLOCK 3 ********************************
#
# Print the figure's height using PRINT_INT. At this point, s0 contains
# the address of the figure object, and shouldn't be changed.
#
# Note that this does not involve any polymorphic functions.
#
        lw      $a0, 8($s0)
        li      $v0, PRINT_INT
        syscall
        
#***** END STUDENT CODE BLOCK 3 **********************************
	
	li 	$v0, PRINT_STRING 	# print ') - area = '
	la 	$a0, area_string
	syscall

#***** BEGIN STUDENT CODE BLOCK 4 ********************************
#
# Print the figure's area using PRINT_INT. At this point, s0 contains
# the address of the figure object, and shouldn't be changed.
#

# First we want to know if it's a Circle or a block
        la      $t2, fig_char
        la      $t1, char_b
        lb      $t7, 0($t2)
        lb      $t6, 0($t1)
        beq     $t7, $t6, do_block_stuff
        j       do_circle_stuff

do_circle_stuff:
        move    $a0, $s0
        jal     circle_area
        move    $a0, $v0 
        j       finish_stuff

do_block_stuff:
        move    $a0, $s0
        jal     block_area
        move    $a0, $v0 
        j       finish_stuff

finish_stuff:
        li      $v0, PRINT_INT
        syscall

#***** END STUDENT CODE BLOCK 4 **********************************
	
	li 	$v0, PRINT_STRING	# print '; perimeter = '
	la 	$a0, perimeter_string
	syscall

#***** BEGIN STUDENT CODE BLOCK 5 ********************************
#
# Print the figure's perimeter using PRINT_INT. At this point, s0
# contains the address of the figure object, and shouldn't be changed.
#

# First we want to know if it's a Circle or a block
# This code is basically the same as in student block 4. Except we just do
# perimeter stuff instead of Area.

        la      $t2, fig_char
        la      $t1, char_b
        lb      $t7, 0($t2)
        lb      $t6, 0($t1)
        beq     $t7, $t6, do_block_stuff_perim
        j       do_circle_stuff_perim

do_circle_stuff_perim:
        move    $a0, $s0
        jal     circle_perimeter
        move    $a0, $v0 
        j       finish_stuff_perim

do_block_stuff_perim:
        move    $a0, $s0
        jal     block_perimeter
        move    $a0, $v0
        j       finish_stuff_perim

finish_stuff_perim:
        li      $v0, PRINT_INT
        syscall
#***** END STUDENT CODE BLOCK 5 **********************************

	
	li 	$v0, PRINT_STRING	# print newline
	la 	$a0, new_line
	syscall

	#
	# Restore all the S registers
	#
	lw	$ra, -4+FRAMESIZE_40($sp)
	lw	$s7, -8+FRAMESIZE_40($sp)
	lw	$s6, -12+FRAMESIZE_40($sp)
	lw	$s5, -16+FRAMESIZE_40($sp)
	lw	$s4, -20+FRAMESIZE_40($sp)
	lw	$s3, -24+FRAMESIZE_40($sp)
	lw	$s2, -28+FRAMESIZE_40($sp)
	lw	$s1, -32+FRAMESIZE_40($sp)
	lw	$s0, -36+FRAMESIZE_40($sp)
	addi	$sp, $sp, FRAMESIZE_40

	jr	$ra
