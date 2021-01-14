####################### Homework 5 #########################
# 	   CS 2340.005 - Computer Architecture	     	   #
# 		       Karen Mazidi                   	   #
# 			Ethan Ong 			   #
# 	 			   			   #
#     This program will create different types of data     # 
#  using a macro file. we get 2 different kinds of output  #
#        from using 2 different files. We ouput the        #
#     compressed data original data, uncompressed data,    #
#    originall file size, and the compressed file size.	   #
#       						   #
############################################################

# Get the string from the user's input macro funtion
.macro getUserString() 

		.data
		
fileName:	.space	64

		.text
		
	li	$v0, 8			# Read string
	la	$a0, fileName	
	la	$a1, 64
	syscall

	move	$t2, $a0
	
.end_macro

# Strings macro funtion
.macro ptrStr (%pString)

		.data
	
Stringfunc:	.asciiz	%pString

		.text
	
	la	$a0, Stringfunc
	li	$v0, 4			# Print string
	syscall
	
.end_macro

# Remove file 
.macro	endFile()

	move	$s0, $a0	
	li	$t3, '\n'		# Compare the new line character with the load register

Endloop:
	beq	$t4, 10, intReplace 	# Jump to replace0 if $$t4 = 0
	add	$s0, $s0, 1		# Goes to next line by adding 1
	lb	$t4, 0($s0)		# When the new line character equals the current byte number
	
	j Endloop

intReplace:
	sb	$0, 0($s0)		# Replace new line character with end of line characters
	
.end_macro

# Read file macro function
.macro	fileRead(%spaceSize, %buffer)	# Pick if it is static or dynamic memory

	
	la	$a0, ($s3)		# File descriptor
	la	$a1, %spaceSize		# size of the file
	la	$a2, %buffer		# Choose type of storage, static or dynamic memory
	li	$v0, 14
	syscall
	
	# store size of file, used later 
	move	$s1, $v0		# Store characters counted
	move	$s3, $s1 
	
.end_macro

# Heap memory
.macro allocateHeap(%allocateMemory)	# Whereever the memory is store it is going to take in the registers

	la	$a0, 1024
	li	$v0, 9
	syscall
	 
	move	%allocateMemory, $v0	# Move the address
	
.end_macro

# Deallocate heap memory 
.macro	deallocate(%DeallocateMemory)

	li	$t3, 0			# i = 0
	li	$t5, 4			# Offset 
	li	$t2, 4
	mult	$t2, $s4		# Multiply the number of characters
	mflo	$t2
	sub	$s2, $s2, $t2		# Subtract to move the pointer back to the front
	
dealloLoop:
	lb	$t7, ($s2)		# beqz = if branch equal zero
	beqz	$t7, backLoop		# If the byte is null, leave macro function
	li	$t7, 0			# Replace current byte with  0
	sb	$t7, ($s2)		# Store 0 into location
	
	# Add 4 to go to the next byte
	addi	$s2, $s2, 4	
	
	j	dealloLoop
	
.end_macro
			
# Compress file 
.macro compression(%bufferInput)

	la	$a1, ($s4)		# nNew compressed file
	la	$a2, ($s1)		# Size of uncompressed
	la	$a0, %bufferInput	# Buffer of original file read into
	
	move	$t8, $a0
	move	$s0, $a0	
	move	$s1, $a0
	
	jal 	counter
	
compLoop1:
	add	$t3, $t1, 1
	add	$s0, $s0, $t3		

compLoop2:
	lb	$t4, ($s1)		# any byte we compar will come to $a0
	beqz	$t4, uncompression	
	lb	$t5, ($s0)		# Comparsion byte from $s0
	beqz	$t4, uncompression
	beq	$t4, $t5, counterToAdd
	sb	$t4, ($s2)		# Store byte to memory
	li	$v0, 11			# print if different
	la	$a0, ($t4)
	syscall
	
	j	compLoop3
	
counterToAdd:
	add	$t2, $t2, 1
	add	$t3, $t3, 1		# add 1 to j until different
	add	$s0, $s0, 1
	
	j	compLoop2
	
compLoop3:
	addi	$s4, $s4, 1
	add	$s2, $s2, $t7
	sb	$t2, 0($s2)
	add	$s2, $s2, $t7
	li	$v0, 1
	la	$a0, ($t2)
	syscall
	
	add	$s4, $s4,1
	
	# Resets the Compression
	move	$t1, $t3, 
	move	$s1, $t8
	add	$s1, $s1, $t1		
	li	$t2, 1
	move	$s0, $t8
	
	j	compLoop1

counter:
	li	$t1, 0			# $t1 = i
	li	$t2, 1			# Counter
	addi	$t3, $t1, 1		# $t3 = j, j = i+1
	li	$s4, 0			# Character count
	li	$t7, 4
	
	jr	$ra
	
.end_macro

# uncompressed the file macro function
.macro uncompression()

# move pointer to front again
	li	$t3, 0			# i = 0
	li	$t2, 4
	mult	$t2, $s4		# Multiply the number of characters
	mflo	$t2
	sub	$s2, $s2, $t2		# Subtract to move the pointer back to the front
	
pointerL:				
	lb	$t7, ($s2)		# Load first byte
	move	$t6, $t7
	beqz	$t6, printFileSize
	
	printChar($t6)			# Print out character 
	
	# Check Numbers
	add	$s2, $s2, 4		# Get next byte 
	lb	$t7, ($s2)
	beqz	$t7, printFileSize
	bgt	$t7, 1, display
	add	$t3, $t3, 1
	add	$s2, $s2, 4
	
	j	pointerL	
	
display:
	printChar($t6)			#  print character
	
	add	$t7, $t7, -1
	beq	$t7, 1, addDisplay
	
	j	display	
	
addDisplay:
	add	$s2, $s2, 4
	
	j	pointerL
	

.end_macro 

# Open File macro function
.macro	openFile(%fileDescription)	

	li	$v0, 13			# Syscall to open file
	la	$a1, 0 
	la	$a2, 0
	syscall
	
	move	%fileDescription, $v0	# Store file description 

.end_macro

# Close file
.macro	closeFile(%spaceSize)

	li	$v0, 16
	la	$a0, ($s3)
	syscall
	
.end_macro

# Print int macro function
.macro printInt(%y)

	add	$a0, $0, %y
	li	$v0, 1			#print int
	syscall
	
.end_macro

# Print an integer macro function
.macro printInt(%integerRegister)

	la	$a0, (%integerRegister)
	li	$v0, 1			# Print int
	syscall
	
.end_macro

# Print a character
.macro printChar(%characterRegister)

	la	$a0, (%characterRegister)
	li	$v0, 11			# Print char
	syscall
	
.end_macro

# Print output
.macro	dataOutput(%buffer)		# Takes the location of the buffer

	la	$a0, %buffer
	li	$v0, 4			# Print
	syscall
	
.end_macro


