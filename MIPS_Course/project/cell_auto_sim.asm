##############################################################################
# File        : main.asm
# Author      : Alexander Kellermann Nieves
#
# Description : This is the main entry point of the program. All the error
# messages originate from here, and cause the program to end while in this
# particular file. This file also contains the data for the binary_input that
# the users puts, but does not contain the data for the binary representation
# of the rule number in binary. 
##############################################################################

PRINT_INT    = 1
PRINT_STRING = 4
READ_INT     = 5
EXIT         = 10

        .align 0
        .data

intro_text:
        .ascii  "*****************************************\n"
        .ascii  "**     Cellular Automata Simulator     **\n"
        .asciiz "*****************************************\n"

invalid_rule:
        .asciiz "Invalid rule number, cell-auto-sim terminating\n"

invalid_gen_num:
        .asciiz "Invalid generation number, cell-auto-sim terminating\n"

invalid_row_size:
        .asciiz "Invalid row size, cell-auto-sim terminating\n"

illegal_input_val:
        .asciiz "Illegal input value, cell-auto-sim terminating\n"

rule_intro_text:
        .asciiz "Rule "

binary_input:
        .space 284

new_line:
        .asciiz "\n"

        .align 2
        .text
        .globl  main
        .globl  convert_to_binny
        .globl  print_num
        .globl  print_scale
        .globl  print_current_row
        .globl  generate_row_prep
        .globl  get_row_a_address

main:
        li      $t7, 0                          # We use this as a row counter
                                                # in cell_display.asm (we use
                                                # it to keep track of which row
                                                # to print)

        li      $v0, READ_INT                   # accepting rule number
        syscall
        move    $s0, $v0                        # store rule number in s0, do
                                                # not change this.

                                                # Check if rule number is valid
        li      $t1, 256                        # setting it to 256 means that
                                                # 255 is the largest value
        slt     $t2, $s0, $t1                   # t2 is 1 is s0 greater than 255
        beq     $t2, $zero, invalid_rule_error  # error out
        li      $t1, -1
        slt     $t2, $t1, $s0                   # t2 is 1 when s0 less than 0
        beq     $t2, $zero, invalid_rule_error  # error out


        li      $v0, READ_INT                   # number of generations to simulate
        syscall
        move    $s1, $v0                        # store the amount of
                                                # generations to simulate. We do        
                                                # change this in the program so be weary

        li      $t1, 26                         # Check if generation number is valid
        slt     $t2, $s1, $t1                   # t2 is 1 is s0 greater than 25
        beq     $t2, $zero, invalid_gen_error   # error out
        li      $t1, -1
        slt     $t2, $t1, $s1                   # t2 is 1 when s0 less than 0
        beq     $t2, $zero, invalid_gen_error   # error out

        li      $v0, READ_INT                   # read the row size
        syscall
        move    $s2, $v0                        # store the row size in $s2
                                                # and it does not change

        li      $t1, 71                         # Check if row number is valid
        slt     $t2, $s2, $t1                   # t2 is 1 is s0 greater than 25
        beq     $t2, $zero, invalid_row_error
        li      $t1, 0
        slt     $t2, $t1, $s2                   # t2 is 1 when s0 less than 0
        beq     $t2, $zero, invalid_row_error

        
        
binary_row_prep:
        li      $s6, 0                          # start the loop where we take in 
                                                # all the input, make sure they're all
        li      $t6, 2                          # zero's and ones, and store them in "binary_input"
        jal     get_row_a_address
        move    $t5, $v0

binary_row_loop_begin: 
        beq     $s6, $s2, binary_row_loop_end   # check if we reached the size
        li      $v0, READ_INT                   # of the row yet. If so, stop.
        syscall
        
        move    $t1, $v0                        # move our precious value to t1
        slt     $t2, $t1, $zero                 # check if less than 0
        bne     $t2, $zero, binary_row_error_out
        slt     $t2, $t1, $t6                   # check if less than 2
        beq     $t2, $zero, binary_row_error_out

       
        sw      $t1, 0($t5)                     # if we're here, we know the value is 
        addi    $t5, $t5, 4                     # valid, so we add it to our array

        addi    $s6, $s6, 1
        j       binary_row_loop_begin

binary_row_loop_end:

        li      $v0, PRINT_STRING       # print the banner
        la      $a0, intro_text
        syscall

        li      $v0, PRINT_STRING       # print the new line
        la      $a0, new_line
        syscall
        # finish printing new line
        
        li      $v0, PRINT_STRING       # print the rule number + binary
        la      $a0, rule_intro_text
        syscall

        li      $v0, PRINT_INT          # print the rule number (decimal)
        move    $a0, $s0
        syscall
                                        # now print the binary portion
        jal     convert_to_binny        # Converts decimal to binary
        jal     print_num               # Prints the binary representation
        li      $t0, 8
        move    $t2, $a0


        move    $a0, $s2                # Now we print the scale
        jal     print_scale
        addi    $s1, $s1, 1

running_generations:
                                        # Print all the runs of the program
        move    $a0, $s2                # move row size
        jal     print_current_row       # prints the row and space
        move    $a0, $s2                # moves row size
        move    $a1, $s1                # moves row number
        jal     generate_row_prep       # generate generation
        addi    $s1, $s1, -1            # decrement remaining rows
        beq     $s1, $zero, end_generations_loop
        j       running_generations

end_generations_loop: 

        move    $a0, $s2                # Print the scale again
        jal     print_scale

        li      $v0, EXIT               # Exit program successfully
        syscall

#################################################
# Below this line there is only code for errors #
#################################################

invalid_rule_error:
        li      $v0, PRINT_STRING
        la      $a0, invalid_rule
        syscall
        li      $v0, EXIT               # Exit
        syscall

invalid_gen_error:
        li      $v0, PRINT_STRING
        la      $a0, invalid_gen_num
        syscall
        li      $v0, EXIT               # Exit 
        syscall

invalid_row_error:
        li      $v0, PRINT_STRING
        la      $a0, invalid_row_size
        syscall
        li      $v0, EXIT               # Exit
        syscall

binary_row_error_out:
        li      $v0, PRINT_STRING
        la      $a0, illegal_input_val
        syscall
        li      $v0, EXIT               # Exit
        syscall
