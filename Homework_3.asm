####################### Homework 3 #########################                   
# 			Ethan Ong 			   #
#     This program will read a file and display the array  # 
#       of integers before and after it is sorted from     #
#         least to greatest. Then calculates the mean	   #
#     median and standard deviation for the given integer  #
#       						   #
############################################################
		.data
		
inputFile:	.asciiz	"input.txt"
msg_prompt:	.asciiz "Enter Filename: "
msg1_before:	.asciiz "The array before: \t"
msg2_after:	.asciiz "The array after: \t"
msg3_mean:	.asciiz "The mean is: "
msg4_median:	.asciiz "The median is: "
msg5_standDev:	.asciiz "The standard deviation is: "
buffer:		.space 	80
numArray:	.word 	20

		.text
main:	
	# Passes the file name places the integers into a buffer
	la	$a0, inputFile
	la	$a1, buffer
	jal	readFile
	beq	$v0, $0, Exit
	
	# Extracts the integers from buffer and store it in an array 
	la	$a0, numArray
	li	$a1, 20
	la	$a2, buffer
	jal	Ints
	move	$t7, $v0
	
	li	$v0, 4
	la	$a0, msg1_before
	syscall
	
	# print the array from file
	la	$a0, numArray
	move 	$a1, $t7
	jal	print
	
	# Sort the integers array from least to greatest
	la	$a0, numArray
	move	$a1, $t7
	jal	Sort
	
	# prints the array of numbers after sorted
	li	$v0, 4
	la	$a0, msg2_after
	syscall
	
	la	$a0, numArray
	move	$a1, $t7
	jal 	print
	
 	# Calculation for mean and prints the mean
	li	$v0, 4
	la	$a0, msg3_mean
	syscall
	
	la	$a0, numArray
	move	$a1, $t7
	jal	Mean
	li	$v0, 2
	syscall
	
	la 	$a0, 10			# prints new line   
	li	$v0, 11
	syscall 
	
	li	$v0, 4
	la	$a0, msg4_median
	syscall
	
	# Calculation for median and prints the median
	la	$a0, numArray
	move	$a1, $t7
	jal	Median
	blt	$v1, $0, intFloat
	
	move	$a0, $v0
	li	$v0,1
	syscall
	
intFloat:	
	li	$v0, 2
	syscall
	
	# Calculations for Stand Deviation and prints the standard Deviation
standDev:	
	la 	$a0, 10			# prints new line   
	li	$v0, 11
	syscall 
	
	li	$v0, 4
	la	$a0, msg5_standDev
	syscall
	
	la	$a0, numArray
	move	$a1, $t7
	jal 	callStandDev
	li	$v0, 2
	syscall
	
Exit:	
	li	$v0, 10			# Terminates Program
	syscall
	
	#################################################
	#               Take ints from File             #
	#################################################

Ints:
	# Reads the buffer 
	li	$s1, -1
	li	$t0, 0

numLoop:	
	lb	$t1, ($a2)
	beq	$t1, 10, storeArray
	beq	$t1, $zero, returnInts
	
	# Ignore the bytes if it is not a number (0-9)
	blt	$t1, 48, ignoreNextInt
	bgt	$t1, 57, ignoreNextInt
	
	# If it is a number then convert
	addi	$t1, $t1, -48		# Subtract 48 from the integers to convert it from ascii to an integer
	
	bne	$s1, -1, multiply	
	li	$s1, 0
	
multiply:
	li	$t3, 10				
	mul	$s1, $s1, $t3		# Multipies $s1 by 10
	add	$s1, $s1, $t1		# Adds the converted int
	
ignoreNextInt:
	add	$a2, $a2, 1		# Jumps to the next byte
	j	numLoop			# Loops through the function till there isn;t anymore integers
	
	# Once all the conversion is done, save it into an integer array
storeArray:	
	beq	$s1, -1, missStoring
	sll	$t2, $t0, 2
	add	$t2, $t2, $a0
	sw	$s1, 0($t2)
	li	$s1, -1
	
missStoring:
	addiu	$t0, $t0, 1		# Increments the index 
	add	$a2, $a2, 1		# continues to the next byte
	beq	$t0, 20, returnInts	# Once the array equals the maximum of 20, jumps to returnInts
	j	numLoop			
returnInts:
	move	$v0, $t0		# Returns the array of converted integers
	jr	$ra			# Jumps back to the main program
		
	#################################################
	#                   Read File                   #
	#################################################
	
readFile:
	move $t1, $a1			# $t1 tempararily hold the store address
	
	# Open File
	li	$v0, 13			# system call to open file
	li	$a1, 0
	syscall
	
	blt	$v0, $0, readFileReturn	# If file does not open, jumps back to main program
	move	$s0, $v0		# moves and save the file in $s0
	
	# Reads the file that is open
	li	$v0, 14			# System call to read the open file
	move	$a0, $s0		
	move	$a1, $t1		# Buffer address
	la	$a2, buffer
	syscall
	
	# Closes the file
	li	$v0, 16			# System call to close the file
	move	$a0, $s0
	syscall
	
	move	$v0, $s0		# Moves the number of characters reaf from file
	
readFileReturn:
	jr	$ra			# Jumps back to the main program
	
	#################################################
	#                     sort            	        #
	#################################################	
Sort:
	li	$t1, 0
	move	$a2, $a1
	subi	$s0, $a1, 1

sortOutLoop:
	beq	$t1, $s0, returnSort 
	move	$s6, $t1
	addi	$t2, $t1, 1		# Add 1 to #t1
	
intComp:
	sll	$t3, $t2, 2
	sll	$t4, $s6, 2
	add	$t3, $t3, $a0
	add	$t4, $t4, $a0
	lw	$t5, 0($t3)		# $t5 = numArray(i)
	lw	$t6, 0($t4)		# $t6 = numArray(jmin)
	bge	$t5, $t6, sortInLoop
	move 	$s6, $t2
	j	sortInLoop
	
sortInLoop:
	# Sorting the numArrays
	addi	$t2, $t2, 1
	bne	$t2, $a2, intComp
	sll	$t3, $t1, 2
	sll	$t4, $s6, 2
	add	$t3, $t3, $a0
	add	$t4, $t4, $a0
	lw	$t5, 0($t3)		
	lw	$t6, 0($t4)		
	sw	$t5, 0($t4)
	sw	$t6, 0($t3)
	j	Update

Update:
	addi	$t1, $t1, 1
	j sortOutLoop
	
returnSort:     
   	jr 	$ra			# Return back to main program
   	
	#################################################
	#                     print            	        #
	#################################################

print: 
	move	$s0, $a0
	li	$t0, 0

loop2:
	beq	$t0, $a1, printReturn
	li	$v0, 1
	sll	$t1, $t0, 2
	add	$t1, $t1, $s0
	lw	$a0, 0($t1)		# loads the ints
	syscall				# prints the ints
		
	la 	$a0, 32			# print space 
	li 	$v0, 11
	syscall	
	
	add	$t0, $t0, 1
	j 	loop2
	
printReturn:
	la 	$a0, 10			# prints new line   
	li	$v0, 11
	syscall 
	
	jr	$ra			# Jumps back to the main program
	
	#################################################
	#                   standDev                    #
	#################################################
	
callStandDev:
	add	$sp, $sp, -4
	sw	$ra, 4($sp)
	jal	Mean			# Jumps to the Mean so it can be used
	mov.s	$f0, $f12		# Stores the mean to $f12
	li	$t0, 0
	mtc1	$t0, $f12

loopStandDev:
	beq	$t0, $a1, returnStandDev
	mul	$t1, $t0, 4
	add	$t1, $t1, $a0
	lw	$t2, 0($t1)
	mtc1	$t2, $f1
	cvt.s.w	$f1, $f1		
	sub.s	$f2, $f1, $f0		# $f2 = i - avg
	mul.s	$f3, $f2, $f2		
	add.s	$f12, $f12, $f3
	add	$t0, $t0, 1
	j	loopStandDev		# Loops through loopStandDev till it is at the end
	
returnStandDev:
	sub	$t2, $a1, 1
	mtc1	$t2, $f4
	cvt.s.w	$f4, $f4		
	div.s	$f12, $f12, $f4		# divides the sum by n - 1
	sqrt.s	$f12, $f12		# square root for $f12
	lw	$ra, 4($sp)
	add	$sp, $sp, 4
	jr	$ra			# Jumps back to the main program
	
	#################################################
	#                    Median            	        #
	#################################################
	
Median:	
	div	$t0, $a1, 2		# $t0 is the middle of the integers
	mfhi	$t1			
	beq	$t1, $0, average	# Calculates the average of the two middle integers if $t1 = 0
	
	sll	$t2, $t0, 2
	add	$t2, $t2, $a0
	lw	$v0, 0($t2)		# If the total number of integer is odd then returns the middle integer	
					# as the median
	li	$v1, 0			# Returns 0
	j	returnMedian
	
average:
	sub	$t1, $t0, 1
	sll	$t2, $t0, 2
	sll	$t3, $t1, 2
	add	$t2, $t2, $a0
	add	$t3, $t3, $a0
	lw	$t4, 0($t2)		# Loads the two middle number 
	lw	$t5, 0($t3)
	add	$t4, $t4, $t5		# Adds the two middle number
	mtc1	$t4, $f12		# Stores the sum of the two middle number to $f12
	li	$t5, 2			# Let $t5 = 2
	mtc1	$t5, $f0		# Let $t0 = 2
	div.s	$f12, $f12, $f0		# Divides the sum by $t0 (0)
	li	$v1, -1			# if the middle number is a negative number then the result is a float

returnMedian:
	jr	$ra			# Returns back to main
	
	#################################################
	#                     Mean            	        #
	#################################################
	
Mean:	
	li	$t0, 0
	mtc1	$t0, $f12
	mtc1	$t0, $f0
	
	#
meanLoop:
	beq	$t0, $a1, returnMean	# Once all numbers are added, jumps to returnMean
	sll	$t1, $t0, 2
	add	$t1, $t1, $a0
	lwc1	$f0, 0($t1)
	add.s	$f12, $f12, $f0
	add	$t0, $t0, 1
	j	meanLoop		# Loops through to add all the integers

returnMean:
	mtc1	$a1, $f0		
	div.s	$f12, $f12, $f0		# Divides the sum by the total number of integers
	jr	$ra			# Returns the Mean 
	
	
