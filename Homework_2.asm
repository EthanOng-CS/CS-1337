# Homework 2
# Ethan Ong
# This program gets the user's entered text 
# and caculates the how many words and characters
# are in the text

		.data

num_char:	.word 	0
num_word:	.word 	0
reset:		.word 	0				
usersInputLen:	.space	100						
usersInputStr:	.space	200				
msg1_prompt:	.asciiz	"Enter some text: "
msg2_goodbye:	.asciiz "               Good Bye!"
msg3_words:	.asciiz "Words"							
msg4_chars:	.asciiz "Characters\n"	
		
		.text
		
main:
	# Prompts and ask user to input a message
	la 	$a0, msg1_prompt
	la 	$a1, usersInputLen	# Length of the word	
	la 	$a2, usersInputStr	# Length of the Sring
	li 	$v0, 54			# Creates a pop up box for the user
	syscall

	# Variable for register
	la 	$a0, usersInputLen
	li 	$t1, 32
	lw 	$v0, num_word
	lw 	$v1, num_char
	
	# Using Stack structure 
	addi 	$sp, $sp, -4		# Creates room 
	sw 	$s0, 0($sp)		# push into stack
	move 	$s0, $a0		# move s1 to a0

	jal charCount 			# calls charCount function

exit:
	# Prompts the user good bye when user leaves
	la 	$a0, msg2_goodbye
	li 	$v0, 59
	syscall

	# Terminate Program
	li 	$v0, 10
	syscall

																	
charCount:
	# charCount function	
	lbu 	$t0, 0($s0)
	beq 	$t0, $0, print		# Check if user's input is a terminator 
	beq 	$t0, $t1, wordCount	# Check if user's input is a string of char
	addi 	$s0, $s0, 1		# Increases the index of string by 1
	addi 	$v0, $v0, 1		# Increases the size by 1

	j charCount 			# Loops to the beginning of charCount until the end of the message 
					
wordCount:
	# wordCount function	
	addi 	$v0, $v0, 1		# Increases size by 1
	addi 	$v1, $v1, 1
	addi 	$s0, $s0, 1		# Increases the index of string by 1
	
	j charCount 			# Loops to beginning of charCount loop
	
ResetProg:
	# Resets the variable so it can be done again
	lw 	$t3, reset
	sw 	$t3, num_char
	sw 	$t3, num_word
	
	# Loops the program from main untill user wants to terminate program
	j main
												
print:
	# Print function										
	# Prints the words and characters counts
	addi 	$v0, $v0, -1
	sw 	$v0, num_char
	addi 	$v1, $v1, 1
	sw 	$v1, num_word

	# check string length ... exit 
	blt 	$a1, 0, exit

	# Outputs the users input string
	la 	$a0, usersInputLen
	li 	$v0, 4
	syscall

	# Outputs the number of words from the user's input message 
	lw 	$a0, num_word
	li 	$v0, 1
	syscall

	la 	$a0, 32		# Print space  
	li 	$v0, 11
	syscall	

	la 	$a0, msg3_words
	li 	$v0, 4
	syscall

	la 	$a0, 32		# Print space  
	li	$v0, 11
	syscall		
	
	# Print number of characters from the user's input message
	lw 	$a0, num_char
	li 	$v0, 1 
	syscall

	la 	$a0, 32		# Print space 
	li 	$v0, 11
	syscall	

	la 	$a0, msg4_chars
	li 	$v0, 4
	syscall
	
	la 	$a0, 10		# Prints new line   
	li	$v0, 11
	syscall
	
	j	ResetProg

# Example 1:
# Hello, I'm a CS major.
# 5 Words 22 Characters

# Example 2:
# Today is a good day to be outside.
# 8 Words 34 Characters

