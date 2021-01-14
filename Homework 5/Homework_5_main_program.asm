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

.include	"Homework_5_macro.asm"

		.data 
	
heap:		.word 	0
compSize:	.space	500	
buffer:		.space	1024

		.text
	
mainLoop:

# Allocate heap memory 

	allocateHeap($s4)			# buffer for the file 
	sw	$v0, heap			# save the pointer
	
	jal	moveHeap

# Ask for filename from user

	ptrStr("\nPlease enter the filename to compress or <enter> to exit: ")	
	getUserString()				# Gets user's file name
	
	# If user enters 'enter', exit program
	beq	$t2, 10, exit			# If equals to new line exit program

	endFile()				# Remove new line character

# Open file to read - Take out necessary information out of the file

	openFile($s3)				# Open file 	
	blt	$s3, $0, error			# Compares the file to make sure it isn't nagative
	
	jal	openCloseFile
	
# Output original data from file - Output the original data that was in the file

	ptrStr("\nOriginal data: \n")	# Print String 
	dataOutput(compSize)			# Print data from original file
	
# Compression and uncompressing function - Outputs the compress and uncompress data 

	ptrStr("\nCompressed data: \n")	# Print String  
	compression(compSize)			# Call macro to compress the file

uncompression:					
	ptrStr("\nUncompressed data: \n")	
	uncompression()				# Call macro to uncompress the file
	
# Print byte number of each file - Outputs the bytes of the original and compressed file

printFileSize:
	ptrStr("\nOriginal file size: ")	# Print String 
	printInt($s3)				# Print Size of original file
	ptrStr("\nCompressed file size: ")	
	printInt($s4)				
	
deallocation:
		deallocate($s2)			# Deallocate the heap memory 
	
backLoop:
	j	mainLoop			# Jump to the beginning of the main function 
	
moveHeap:
	move 	$s6, $v0
	move	$s2, $s6			# Move the pointer's location so it cant be changed
	
	jr	$ra	

openCloseFile:
	fileRead(compSize, buffer)		# Read file size into buffer
	closeFile(compSize)			# Close the file 
	
	jr	$ra

error:
	ptrStr("\nError opening file. Progam terminating.")	# If file doesn\'t open, print errat
	
# Terminate Program
exit:
	li	$v0, 10
	syscall
