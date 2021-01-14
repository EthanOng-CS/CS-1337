# Homework 1
# Ethan Ong
# This program gets the user's entered integers
# then calculates 3 different math expressions 
# and displays the name and result

	.data
	
a:	.word	0
b:	.word	0
c: 	.word	0
ans1:	.word	0
ans2:	.word	0
ans3:	.word	0
name:	.space	20
space:	.asciiz	" "
msg1:	.asciiz	"What is your name? "
msg2:	.asciiz "Please enter an integer between 1-100: "
msg3:	.asciiz "Your answers are: "

	.text
	
	# gets and stores the user's name
	li	$v0, 4		# print String
	la	$a0, msg1
	syscall
	
	li	$v0, 8		# get name from user
	la	$a0, name
	li	$a1, 20
	syscall
	
	# get three integer from the user
	li	$v0, 4		# print String
	la	$a0, msg2
	syscall
	
	li	$v0, 5		# get integer from user
	syscall
	sw	$v0, a
	
	li	$v0, 4		# print String
	la	$a0, msg2
	syscall
	
	li	$v0, 5		# get integer from user
	syscall
	sw	$v0, b
	
	li	$v0, 4		# print String
	la	$a0, msg2
	syscall
	
	li	$v0, 5		# get integer from user
	syscall
	sw	$v0, c
	
	# Caculate ans1 = 2a - c + 4
	lw	$s0, a		# load
	lw	$s1, b
	lw	$s2, c
	add	$t0, $s0, $s0
	sub	$t0, $t0, $s2
	add	$t0, $t0, 4
	sw	$t0, ans1	# save
	
	# Caculate ans2 = b - c + (a - 2)
	sub 	$s3, $s1, $s2
	sub	$s4, $s0, 2
	add	$t1, $s3, $s4
	sw	$t1, ans2	# save
	
	# Caculate ans3 = (a + 3) - (b - 1) + (c + 3) 
	add	$t5, $s0, 3
	sub 	$t6, $s1, 1
	add	$t7, $s2, 3
	sub	$t2, $t5, $t6
	add	$t2, $t2, $t7
	sw	$t2, ans3	# save
	
	# prints the users name
	li	$v0, 4		# print String
	la	$a0, name
	syscall
	
	# prints the results
	li	$v0, 4		# print String
	la	$a0, msg3
	syscall
	
	li	$v0, 1		# prints answer 1
	lw 	$a0, ans1
	syscall		
	
	li	$v0, 4		# prints space
	la	$a0, space
	syscall
	
	li	$v0, 1		# prints answer 2
	lw 	$a0, ans2
	syscall
	
	li	$v0, 4		# prints space
	la	$a0, space
	syscall		
		
	li	$v0, 1		# prints answer 3
	lw 	$a0, ans3
	syscall

exit:
	li	$v0, 10		#terminate program
	syscall
	
# Example #1:	
# a = 2, b = 45, c = 30
# Expected Output: Eq1 = -22, Eq2 = 15, Eq3 = -6
# Sample Output:
# What is your name? Billy
# Please enter an integer between 1-100: 2
# Please enter an integer between 1-100: 45
# Please enter an integer between 1-100: 30
# Billy
# Your answers are: -22 15 -6

# Example #2:
# a = 56, b = 98, c = 2
# Expected Output: Eq1 = 114, Eq2 = 150, Eq3 = -33
# Sample Output: 
# What is your name? Joey
# Please enter an integer between 1-100: 56
# Please enter an integer between 1-100: 98
# Please enter an integer between 1-100: 2
# Joey
# Your answers are: 114 150 -33
