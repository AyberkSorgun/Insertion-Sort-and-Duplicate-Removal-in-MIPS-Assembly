#####################################################################
#                                                                   #
# Name:Ceren Kocaoğullar-Ayberk Sorgun                              #
# KUSIS ID:53935-50397                                              #
#####################################################################

# This file serves as a template for creating 
# your MIPS assembly code for assignment 2

.eqv MAX_LEN_BYTES 400

#====================================================================
# Variable definitions
#====================================================================

.data

arg_err_msg:       .asciiz   "Argument error"
input_msg:         .asciiz   "Input integers"
.align 2
input_data:        .space    MAX_LEN_BYTES     #Define length of input list
#  You can define other data as per your need. 
output: 	   .asciiz "Sorted List: \0"
output2: 	   .asciiz "Sorted list without duplicates: \0"
sum: 	           .asciiz "List sum: \0"
space:             .asciiz " "
next_line:         .asciiz "\n"
exit_msg:	   .asciiz "Program finished"


#==================================================================== 
# Program start
#====================================================================

.text
.globl main

main:
   #
   # Main program entry
   li $v0, 4 # read string service  
   addi $t0, $zero, 2 # $t0 = 2
   bne $a0, $t0, Arg_Err # if the number of argument is not equal 2 ($t0), return error
   lw $t0, 0($a1) # load the string, $t0 = command 
   lb $t1, 0($t0) # load the first bit of the command
   addi $t2, $zero, 45 # $t2 = 45 which is the ascii code of '-'
   bne $t1, $t2, Arg_Err # if the character is not '-', return error message
   lb $t1, 1($t0) # load the second bit of the command, which is n command
   lb $t2, 2($t0) # check if there is another character after the command charachter
   bnez $t2, Arg_Err # give error if there is another character after command character
   lw $t0, 4($a1) # load the string of number of elements to be sorted
   lb $t3, 0($t0) # take the first byte of this string (first digit of the input number)
   addi $t3, $t3, -48 #convert ascii number of this input to decimal
   addi $a3, $t3, 0 # transfer t3's value to a3 
   lb $t4, 1($t0) # check if there is another character after the first digit of input number
   bnez $t4, Get_Sec_Digit # if there is another digit after the first, go and calculate the 2-digit number
   
   addi $t2, $zero, 110 # $t2 = 110, ascii of n
   
   
   # Check for first argument to be n
   beq $t1, $t2, Data_Input # if the character is n, jump to Data_Input
  
   
 
# Helper method to get the second digit of the input number and store the decimal value of this two digit number  
Get_Sec_Digit:
   addi $t4, $t4, -48 # convert ascii number of this input to decimal
   li $t5, 10 #t5 = 10
   mult $a3, $t5 # multiply the first digit of the input number with 10
   mflo $t5 # t5 = the result of multiplication
   add $a3, $t5, $t4 # add the numbers so that we have the two digit input number's decimal value
  

Data_Input:
   # Get integers from user as per value of n
   
   ##################  YOUR CODE  #################### 
   
   addi $s0, $zero, 0 # initialize counter variable i = 1
   la 	$a1, input_data # the first element of the array as a reference
   li $v0, 4
   la $a0, input_msg # print the next line
   syscall
   li $v0, 4
   la $a0, next_line # print the next line
   syscall

Loop:
	li $v0, 5 # set v0 to 5 in order to prepare it for integer input from the user
	syscall # wait for the user input
	move $t0, $v0 # take the user input stored in v0 and move it to t0
	sw $t0, 0($a1) # put the new input into the index adress
	addi $s0, $s0, 1 # increment the counter (i = i + 1)
	addi $a1, $a1, 4 # move the array address to the next
	bne $s0, $a3, Loop #if counter is not equal to desired number of inputs, go to loop
  	
# Insertion sort begins here
sort_data:

   ##################  YOUR CODE  ####################
   la  $t0, input_data  # Copy the base address of your array into $t1
   li $t5, 4 		# t5 = 4
   addi $t6, $a3, -1	# calculate the number of elements - 1 to in order to use in finding last address of list
   mult $t6, $t5 	# 4 bytes per int * num of ints = num of bytes in the array
   mflo $t5 		# t5 = the result of multiplication
   add $t0, $t0, $t5    # t0 is in the last address of the array
   
                               
outerLoop:              # Used to determine when we are done iterating over the Array
    add $t1, $0, $0     # $t1 holds a flag to determine when the list is sorted
    la  $a1, input_data     # Set $a0 to the base address of the Array
    beq $t0, $a1, print_w_dup
innerLoop:                  # The inner loop will iterate over the Array checking if a swap is needed
    lw  $t2, 0($a1)         # sets $t0 to the current element in array
    lw  $t3, 4($a1)         # sets $t1 to the next element in array
    slt $t4, $t2, $t3       # $t4 = 1 if $t2 < $t3
    beq $t4, 1, continue    # if $t5 = 1, then swap them
    beq $t2, $t3, continue
    addi $t1, $0, 1         # if we need to swap, we need to check the list again
    sw  $t2, 4($a1)         # store the greater numbers contents in the higher position in array (swap)
    sw  $t3, 0($a1)         # store the lesser numbers contents in the lower position in array (swap)
continue:
    addi $a1, $a1, 4            # advance the array to start at the next location from last time
    bne  $a1, $t0, innerLoop    # If $a1 != the end of Array, jump back to innerLoop
    bne  $t1, $0, outerLoop    # $t1 = 1, another pass is needed, jump back to outterLoop
    j print_w_dup

remove_duplicates:
   
   ##################  YOUR CODE  ####################

   la  $a0, input_data  # Copy the base address of your array into $t0
   li $t5, 4     	# t5 = 4
   addi $t6, $a3, -1	# calculate the number of elements - 1 to in order to use in finding last address of list
   mult $t6, $t5   	# 4 bytes per int * num of ints = num of bytes in the array
   mflo $t5     	# t5 = the result of multiplication
   add $t5, $a0, $t5    # t5 is in the last address of the array
   beq $a3, 1, print_wo_dup # if our list's length equal to 1, there is no need to remove duplicate, jump to printing phase
   
 scan:
   addi $a1, $a0, 4     # creating a second pointer to check 2 variables at a time
   bge $a0, $t5, print_wo_dup # if list length is 1-first element's address equal to last address (a0=t5)- go to printing immediately
   add $t0, $a0, $zero  #creating temp pointers to iterate through list
   add $t1, $a1, $zero  #creating temp pointers to iterate through list
   lw $t3, ($a0)	#load the value of current element to t3
   lw $t4, ($a1)	#load the value of next element to t4
   beq $t3, $t4, shiftBack # if they are equal, jump to shirfback phase
   addi $a0, $a0, 4	# move a0 to the next element of the list
   bne $a0, $t5, scan	# if current elemen is not the last element of the list, continue iterating
   j print_wo_dup
   
 shiftBack:
   beq $t0, $t5, decSize # if the shiftBack has completed, go to decSize
   lw $t3, ($t1) # load the argument stored in address t1 to temporary value t3
   sw $t3, ($t0) # store the t3 value in address t0 so that the shiftBack itself is executed
   addi $t0, $t0, 4 # incremention of pointers
   addi $t1, $t1, 4 # incremention of pointers
   j shiftBack

 decSize:
   sw $zero, ($t5) # assign 0 to the last element of list
   sub $t5, $t5, 4 # decrement the last address of the list
   sub $a3, $a3, 1 # decrement the number of elements of the list
   j scan
 
print_w_dup:

   ##################  YOUR CODE  ####################
   	la $a1, input_data # the first element of the array as a reference
   	addi $s0, $zero, 0 # initialize counter variable i = 0
   	li $v0, 4
   	la $a0, output # print the "Sorted List: " string
	syscall
	li $v0, 4
        la $a0, next_line # print the next line
        syscall


Loop2:
	li $v0, 1 # print the number
	lw $a0, 0($a1) 
	syscall
	li $v0, 4
	la $a0, space #print the space between elements	
	syscall
	addi $a1, $a1, 4 # move the array address to the next
	addi $s0, $s0, 1 # increment the counter (i = i + 1)
	bne $s0, $a3, Loop2 #if counter is not equal to desired number of inputs, go to loop2
    	la $a0, next_line # move to the next line
	li $v0, 4
	syscall
	j remove_duplicates
	
print_wo_dup:

   ##################  YOUR CODE  ####################
        la $a1, input_data # the first element of the array as a reference
   	addi $s0, $zero, 0 # initialize counter variable i = 0
   	li $v0, 4
   	la $a0, output2 # print the "Sorted list without duplicates: " string
	syscall
	li $v0, 4
        la $a0, next_line # print the next line
        syscall

Loop3:
	li $v0, 1 # print the number
	lw $a0, 0($a1) 
	syscall
	li $v0, 4
	la $a0, space #print the space between elements	
	syscall
	addi $a1, $a1, 4 # move the array address to the next
	addi $s0, $s0, 1 # increment the counter (i = i + 1)
	bne $s0, $a3, Loop3 #if counter is not equal to desired number of inputs, go to loop3
    	la $a0, next_line # move to the next line
	li $v0, 4
	syscall
	j list_sum
# Perform reduction
   
   ##################  YOUR CODE  ####################

# Print sum

list_sum:
   la $a1, input_data # the first element of the array as a reference
   addi $a2, $a1, 0 # a2 is equal to the address of a1
   add $t0, $a1, $zero # t0 is equal to a1
   li $t1, 4 		# t1 = 4
   addi $t2, $a3, -1	# calculate the number of elements - 1 to in order to use in finding last address of list
   mult $t2, $t1 	# 4 bytes per int * num of ints = num of bytes in the array
   mflo $t1 		# t1 = the result of multiplication
   add $t0, $t0, $t1    # t0 is in the last address of the array
   
   li $v0, 4
   la $a0, sum # print the "List sum: " string
   syscall
   li $v0, 4
   la $a0, next_line # print the next line
   syscall

LoopSum: 
   beq $a2, $t0, PrintSum
   addi $a2, $a2, 4
   lw $t4, ($a1)
   lw $t5, ($a2)
   add $t4, $t4, $t5
   sw $t4, ($a1)
   j LoopSum
   
PrintSum:
    li $v0, 1 # print the number
    lw $a0, 0($a1) 
    syscall  
    li $v0, 4
    la $a0, next_line # print the next line
    syscall
    j Exit 
   
Arg_Err:
   # Error message when no input arguments specified
   # or when argument format is not valid
   la $a0, arg_err_msg
   li $v0, 4
   syscall
   li $v0, 4
   la $a0, next_line # print the next line
   syscall
   j Exit

Exit:   
   # Jump to this label at the end of the program
   li $v0, 4
   la $a0, exit_msg # print the next line
   syscall
   li $v0, 10
   syscall