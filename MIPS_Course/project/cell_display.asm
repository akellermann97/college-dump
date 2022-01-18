################################################################################
#
# File        : cell_display.asm
# Author      : Alexander Kellermann Nieves
# Description : Handle all display functions outside of the banner,
# This includes the function to generate the next cell based on the current
# cell, the function to print the scale, the function that decides whether an
# 'A' or other letter is printed, and the one that handles the justification of
# letters to the right if they're under 2 digits long.
#
################################################################################

PRINT_INT    = 1
PRINT_STRING = 4
READ_INT     = 5
PRINT_CHAR   = 11
EXIT         = 10

        .align 0
        .data
minus:
        .asciiz "-"

empty:
        .asciiz " "

plus:
        .asciiz "+"

cero:
        .asciiz "0"

new_line_display:
        .asciiz "\n"

dot:
        .asciiz "."

alpha:
        .asciiz ".ABCDEFHIJKLMNOPQRSTUVWXYZ"

        .align 2

row_a:
        .space 284

row_b:
        .space 284

        .align 2
current_row_number:
        .byte  0

cell_0:
        .word  1
        .word  1
        .word  1

cell_1:
        .word  1
        .word  1
        .word  0

cell_2:
        .word  1
        .word  0
        .word  1
cell_3:
        .word  1
        .word  0
        .word  0

cell_4:
        .word  0
        .word  1
        .word  1

cell_5:
        .word  0
        .word  1
        .word  0

cell_6:
        .word  0
        .word  0
        .word  1

cell_7:
        .word  0
        .word  0
        .word  0

temp_cell:
        .word  0 # empty, because we populate it ourselves
        .word  0
        .word  0

print_text1:
        .asciiz "Old cell: "

print_text2:
        .asciiz "New Cell: "

what_happens_to_cell:
        .asciiz "The cell dies: "

        .align 2
        .text 


        # functions called by cell_auto_sim.asm
.align 2
.text
        .globl  print_scale
        .globl  print_current_row
        .globl  generate_row_prep
        .globl  get_row_a_address
        .globl  address_of_converted_num

get_row_a_address:
        la      $v0, row_a
        jr      $ra             # Return to calling function


print_scale:
        # a0 will contain the amount of columns we need to print
        li      $v0, PRINT_STRING
        move    $t1, $a0
        addi    $t1, $t1, 1
        li      $t5, 5          # t4 is counter 
        li      $t4, 1          # t5 is counter 

print_my_buffer_space:
        la      $a0, empty
        syscall
        syscall                 # print 3 blanks
        syscall

scale_loop:
        addi    $t1, $t1, -1    # counter for things to print
        addi    $t5, $t5, -1    # counter for fives column
        beq     $t1, $zero, exit_scale_loop
        beq     $t5, $zero, is_fifth_column
        la      $a0, minus
        syscall
scale_loop_jump:
        j       scale_loop

is_fifth_column:
        beq     $t4, $zero, is_tenth_column
        addi    $t4, $t4, -1    # add 1 to t4
        la      $a0, plus       # print the plus
        syscall
        li      $t5, 5
        j       scale_loop_jump

is_tenth_column:
        move    $t4, $zero      # set t4 to zero
        li      $t5, 5
        la      $a0, cero
        syscall
        addi    $t4, $t4, 1
        j       scale_loop_jump

exit_scale_loop:
        la      $a0, new_line_display
        syscall
        jr      $ra


right_justify:
        li      $v0, PRINT_STRING
        la      $a0, empty
        syscall
        j       continue_printing_number

print_current_row:
        la      $t4, current_row_number
        lb      $t5, 0($t4)

        # Check to see if number is less than 10, if it is, we print a space
        slti    $t6, $t5, 10
        bne     $t6, $zero, right_justify

continue_printing_number:

        move    $a0, $t5
        li      $v0, PRINT_INT
        syscall
        
        addi    $t5, $t5, 1
        sb      $t5, 0($t4)
        li      $v0, PRINT_STRING
        la      $a0, empty
        syscall

        jr      $ra

generate_row_prep:
        addi    $sp, $sp, -28
        sw      $ra, 0($sp)
        sw      $s0, 4($sp)
        sw      $s1, 8($sp)                     # row size stored in $a0
        sw      $s2, 12($sp)                    # Store S registers on the stack
        sw      $s3, 16($sp)                    # Rule number in binary is in
        sw      $s4, 20($sp)                    # converted_num
        sw      $s5, 24($sp)                    # The original row of binary is in row_a 

        move    $s0, $a0                        # store row size
        move    $s4, $a0                        # use this as a counter variable
        li      $s1, 2                          # Determine if odd or even
        la      $t0, current_row_number
        lb      $t0, 0($t0)
        move    $t0, $a1                        # move 
        div     $t0, $s1                        # t0/s1
        mfhi    $t0                             # t0
        beq     $t7, $zero, row_a_is_cur        # if 0 = 0 make row a = 0
        j       row_b_is_cur
        

row_a_is_cur:
        la      $s1, row_a                      # store row address (A)
        la      $s2, row_b                      # store row address (B)
        li      $t7, 1
        j       generate_row_begin

row_b_is_cur:
        la      $s1, row_b                      # store row address (B)
        la      $s2, row_a                      # store row address (A)
        li      $t7, 0

generate_row_begin:
        # S1 = current row
        # S2 = Row we're writing to.
        # S4 = our counter
        # S0 = our permanent row size (we use this as reference)

        # stop loop condition
        beq     $s4, $zero, generate_row_end    # stop loop when row = 0
        # stop loop condition

        
        ### Printing characters to screen
        lw      $s3, 0($s1)                     # load a word from row cur
        la      $a0, alpha                      # store address of alpha string
        add     $a0, $a0, $s3                   # add offset of alpha by t0
        lb      $a0, 0($a0)                     # load the correct letter
        li      $v0, PRINT_CHAR                 # print the character
        syscall
        ### Printing characters to screen

        # li      $v0, PRINT_STRING             # print the character
        # la      $a0, print_text1
        # syscall

        # call fill cell
        j       fill_cell
        # Now calulate what we do with that cell
cell_been_filled:

        j       cell_survive_or_die
did_cell_die:

                                                # The number of the cell is now stored in $v1
        jal     address_of_converted_num        # The address of converted num is now in $v0
        li      $t1, 4          # t1 = 4
        mul     $v1, $v1, $t1   # v1 * 4 = v1
        add     $v0, $v0, $v1   # v0 = v0 + v1
        lw      $v1, 0($v0)     # load what is at v0

        # Stores the word in the proper place for the next generation
        # s3 already contains the current number
        beq     $v1, $zero, current_num_zero
        add     $v1, $v1, $s3

current_num_zero:
        sw      $v1, 0($s2)                     # v1 now contains whether or not the 
                                                # cell will die or not in the
                                                # next generation

                                                # incrementing characters and jumping
        addi    $s1, $s1, 4                     # move to next character (word)
        addi    $s2, $s2, 4
        addi    $s4, $s4, -1                    # decrement counter
        j       generate_row_begin              # continue loop
                                                # incrementing characters and jumping
generate_row_end:
        li      $v0, PRINT_STRING               # prepare string 
        la      $a0, new_line_display           # print '\n'
        syscall

        lw      $ra, 0($sp)
        lw      $s0, 4($sp)
        lw      $s1, 8($sp)
        lw      $s2, 12($sp)
        lw      $s3, 16($sp)
        lw      $s4, 20($sp)
        lw      $s5, 24($sp)
        addi    $sp, $sp, 28
        jr      $ra

################################################################################
#    This function takes the current cell index (s4) and fills the temp_cell   #
#       address with the appropriate left, middle, and right values.           #
################################################################################
fill_cell:
        la      $t0, temp_cell
        addi    $v1, $zero, 1
        beq     $s4, $s0, fill_cell_first
        beq     $s4, $v1, fill_cell_last        # v1 = 1
        lw      $t6, -4($s1)                    # left
        sw      $t6, 0($t0)
        lw      $t6, 0($s1)                     # middle
        sw      $t6, 4($t0)
        lw      $t6, 4($s1)                     # right
        sw      $t6, 8($t0)                     # right of temp_cell

        j       cell_been_filled


fill_cell_first:
# Special case, where the cell is all the way left.
        lw      $t6, 0($s1)     # loading middle
        sw      $t6, 4($t0)     # storing middle
        lw      $t6, 4($s1)     # loading right
        sw      $t6, 8($t0)     # storing right


        li      $t2, 0          # t2 = 1
        add     $s1, $s1, $t2

        lw      $t6, 0($s1)     # loading left
        sw      $t6, 0($t0)     # storing left
        sub     $s1, $s1, $t2   # move array s1 spaces back
        
        j       cell_been_filled

fill_cell_last:
# Special case, where the cell is all the way right
        lw      $t6, 0($s1)     # loading middle
        sw      $t6, 4($t0)     # storing middle
        lw      $t6, -4($s1)    # loading left
        sw      $t6, 0($t0)     # storing left


        li      $t2, 4          # t2 = 1
        addi    $s0, $s0, -1    # s0 now contains the amount we need to mul by

        mul     $t2, $t2, $s0

        sub     $s1, $s1, $t2   # move array t2 spaces ahead
        lw      $t6, 0($s1)     # loading left
        sw      $t6, 8($t0)     # storing left
        add     $s1, $s1, $t2   # move array t2 spaces back

        addi    $s0, $s0, 1     # restore s0
        
        j       cell_been_filled

###############################################################################
### Calulate whether or not the cell dies or not, store the result in $v1 #####
###############################################################################

cell_survive_or_die:
        la      $t1, temp_cell
        lw      $t2, 0($t1)
        lw      $t3, 4($t1)
        lw      $t4, 8($t1)
        li      $s5, 1
        slt     $t2, $zero, $t2         # If t# > 1 then t# = 1
        slt     $t3, $zero, $t3
        slt     $t4, $zero, $t4
        sw      $t2, 0($t1)
        sw      $t3, 4($t1)
        sw      $t4, 8($t1)

check_cell0:
        la      $t2, cell_0
        lw      $t3, 0($t1)
        lw      $t4, 0($t2)
        bne     $t3, $t4, check_cell1 
        lw      $t3, 4($t1)
        lw      $t4, 4($t2)
        bne     $t3, $t4, check_cell1 
        lw      $t3, 8($t1)
        lw      $t4, 8($t2)
        bne     $t3, $t4, check_cell1 
        li      $v1, 0
        j       did_cell_die

check_cell1:
        la      $t2, cell_1
        lw      $t3, 0($t1)
        lw      $t4, 0($t2)
        bne     $t3, $t4, check_cell2 
        lw      $t3, 4($t1)
        lw      $t4, 4($t2)
        bne     $t3, $t4, check_cell2 
        lw      $t3, 8($t1)
        lw      $t4, 8($t2)
        bne     $t3, $t4, check_cell2 
        li      $v1, 1
        j       did_cell_die

check_cell2:
        la      $t2, cell_2
        lw      $t3, 0($t1)
        lw      $t4, 0($t2)
        bne     $t3, $t4, check_cell3 
        lw      $t3, 4($t1)
        lw      $t4, 4($t2)
        bne     $t3, $t4, check_cell3 
        lw      $t3, 8($t1)
        lw      $t4, 8($t2)
        bne     $t3, $t4, check_cell3 
        li      $v1, 2
        j       did_cell_die

check_cell3:
        la      $t2, cell_3
        lw      $t3, 0($t1)
        lw      $t4, 0($t2)
        bne     $t3, $t4, check_cell4 
        lw      $t3, 4($t1)
        lw      $t4, 4($t2)
        bne     $t3, $t4, check_cell4 
        lw      $t3, 8($t1)
        lw      $t4, 8($t2)
        bne     $t3, $t4, check_cell4 
        li      $v1, 3
        j       did_cell_die

check_cell4:
        la      $t2, cell_4
        lw      $t3, 0($t1)
        lw      $t4, 0($t2)
        bne     $t3, $t4, check_cell5 
        lw      $t3, 4($t1)
        lw      $t4, 4($t2)
        bne     $t3, $t4, check_cell5 
        lw      $t3, 8($t1)
        lw      $t4, 8($t2)
        bne     $t3, $t4, check_cell5 
        li      $v1, 4
        j       did_cell_die

check_cell5:
        la      $t2, cell_5
        lw      $t3, 0($t1)
        lw      $t4, 0($t2)
        bne     $t3, $t4, check_cell6 
        lw      $t3, 4($t1)
        lw      $t4, 4($t2)
        bne     $t3, $t4, check_cell6 
        lw      $t3, 8($t1)
        lw      $t4, 8($t2)
        bne     $t3, $t4, check_cell6 
        li      $v1, 5
        j       did_cell_die

check_cell6:
        la      $t2, cell_6
        lw      $t3, 0($t1)
        lw      $t4, 0($t2)
        bne     $t3, $t4, check_cell7
        lw      $t3, 4($t1)
        lw      $t4, 4($t2)
        bne     $t3, $t4, check_cell7
        lw      $t3, 8($t1)
        lw      $t4, 8($t2)
        bne     $t3, $t4, check_cell7
        li      $v1, 6
        j       did_cell_die

check_cell7:
        li      $v1, 7
        j       did_cell_die
        ### If we get to here, it must be cell 7 type
