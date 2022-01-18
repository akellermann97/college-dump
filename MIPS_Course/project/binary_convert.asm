######################################################################################
# File        : binary_convert.asm
# Author      : Alexander Kellermann Nieves
# Description : In this file, we take the decimal number from main, and store it
# into an array called converted_num. This file also contains the method to
# print the converted_num to screen, complete with parenthesis!
#
######################################################################################

PRINT_INT    = 1
PRINT_STRING = 4
READ_INT     = 5
EXIT         = 10

        .align 0
        .data 


converted_num:
        .space 36

        .align 0

open_paren:
        .asciiz " ("

closed_paren:
        .asciiz ")\n"

        .align 2
        .text

        .globl convert_to_binny
        .globl print_num
        .globl address_of_converted_num

convert_to_binny:
	addi 	$sp, $sp, -16
	sw 	$ra, 12($sp)
	sw 	$s2, 8($sp)
	sw 	$s1, 4($sp)
	sw 	$s0, 0($sp)

        # prep work for our subtraction method
        la      $t6, converted_num      # t1 contains address of our 'array'
        li      $t5, 32


convert_to_binary:
        # The number to convert will be in $a0
        # The result will be stored in $v0

print_bin:

        move    $t0, $a0
        li      $t1, 0
        addi    $t3, $zero, 1           # load 1 as a mask
        sll     $t3, $t3, 31            # move the mask to appropriate position
        addi    $t4, $zero, 32          # loop counter

loop:
        and     $t1, $t0, $t3           # and the input with the mask
        beq     $t1, $zero, print       # Branch to print if its 0
        
        move    $t1, $zero              # Zero out $t1
        addi    $t1, $zero, 1           # Put a 1 in $t1
        addi    $t5, -1
        j       print
        
        
print:  
        addi    $t5, $t5, -1
        slti    $s0, $t5, 8 
        beq     $zero, $s0, shifting_stuff
        sw      $t1, 0($t6)
        addi    $t6, 4

shifting_stuff:
        
        srl     $t3, $t3, 1
        addi    $t4, $t4, -1
        bne     $t4, $zero, loop


done_with_convert:

	lw 	$ra, 12($sp)
	lw 	$s2, 8($sp)
	lw 	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addi 	$sp, $sp, 16

        la      $a0, converted_num


        jr $ra  # return to main


print_num:
	addi 	$sp, $sp, -16
	sw 	$ra, 12($sp)
	sw 	$s2, 8($sp)
	sw 	$s1, 4($sp)
	sw 	$s0, 0($sp)

print_open_paren:
        la      $s0, open_paren
        li      $v0, PRINT_STRING 
        move    $a0, $s0
        syscall

print_converted_binary_number_2_screen:
        la      $s0, converted_num
        li      $s3, 7
        
print_bin_loop_2_scr:
        lw      $s1, 0($s0)
        move    $a0, $s1
        li      $v0, PRINT_INT
        syscall
        beq     $s3, $zero, print_bin_loop_finished
        addi    $s3, $s3, -1
        addi    $s0, $s0, 4
        j       print_bin_loop_2_scr

print_bin_loop_finished:

print_closed_paren:
        la      $s0, closed_paren
        li      $v0, PRINT_STRING 
        move    $a0, $s0
        syscall

done_with_print_num:

	lw 	$ra, 12($sp)
	lw 	$s2, 8($sp)
	lw 	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addi 	$sp, $sp, 16

        jr      $ra                  # return to main

address_of_converted_num:
        la      $v0, converted_num
        jr      $ra
