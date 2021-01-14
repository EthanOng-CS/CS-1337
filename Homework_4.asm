####################### Homework 4 #########################
# 	   CS 2340.005 - Computer Architecture	     	   #
# 		       Karen Mazidi                   	   #
# 			Ethan Ong 			   #
# 	 			   			   #
#  This program will creat a bit map of 7 different colors # 
#     and creat a square. With the 7 colors each of the    #
#       colors will be moving around to make a masquee 	   #
#     You would alos be able to mave the box around with   #
#         the keys w (up), a (left), s (down),             #
#               d (right), & space (exit)                  #
#       						   #
###################### Instructions ########################
#							   #
#                 Connect bitmap display                   #
#               Set pixel dimention to 4x4		   #
#	    Set Display dimentions to 256x256		   #
#	 Use 0x10008000 ($gp) as the base address	   #
#	 Connect the keyboard and run the program	   #
#      Use WASD to move the square and SPACE to exit  	   #
#						  	   #
############################################################


.data  
# Width of screen of pixels: 256 / 4 = 64 
.eqv	WIDTH 64	
# Hight of screen in pixels
.eqv	HIGHT 64

# Colors used for the array
.eqv	RED 	0x00FF0000
.eqv	GREEN	0x0000FF00
.eqv	BLUE	0x000000FF
.eqv	WHITE	0x00FFFFFF
.eqv	YELLOW	0x00FFFF00
.eqv	CYAN	0x0000FFFF
.eqv	MAGENTA	0x00FF00FF 

		.data 

colorArray: 	.word	RED, GREEN, BLUE, WHITE, YELLOW, CYAN, MAGENTA 

		.text 
main:  
	la $t1, WIDTH	# Load width 
	la $t2, HIGHT  	# Load height 
	div $a1, $t1, 2 # Divide $t1, and 2 into $a1 
	div $a2, $t2, 2 # Divide $$1, and 2 into $a2 
	li $t3, 0	# $t3 is repeater to loop through colors 
	li $t4, 0 	# $t4 is check the total number of pixels in the line  
	li $t5, 0	# $t5 starts the marqee effect 
			
############## Pixel Movement - Process Input ################											
															
pixelMovement: 
	jal	topLoop 
	
	lw $t6, 0xffff0000 		# $t6 is the holding value of user input 
	beq $t6, 0, pixelMovement 
	
	 # Process input
	lw 	$s0, 0xffff0004
	beq	$s0, 32, exit		# Input space
	beq	$s0, 119, Up 		# Input w
	beq	$s0, 115, Down 		# Input s
	beq	$s0, 97, Left 		# Input a
	beq	$s0, 100, Right		# Input d
	
	# Invalid input, ignore
	j	pixelMovement   
	
############## WASD Movement ################	
	
Up: 
	jal 	topBlackOut 
	subi 	$a2, $a2, 1 		# Add 1 to x 
	j	pixelMovement   
	 
Down: 
	jal	topBlackOut 
	addi 	$a2, $a2, 1 		# Add 1 to x
	j	pixelMovement  
	
Left: 
	jal 	topBlackOut 
	subi 	$a1, $a1, 1 		# Add 1 to x 
	j	pixelMovement   
	
Right: 
	jal 	topBlackOut 
	addi 	$a1, $a1, 1 		# Add 1 to x 
	j	pixelMovement  
	
############ Display Pixel Loops ##############	
						   								   								   								   								   								   								   								   								   								   								   								   													   								   								   								   								   								   								   								   								   								   								   								   							
topLoop: 
	mul	$s0, $a2, WIDTH 	# storing WIDTH and value of $a2 into $s0 
	add 	$s0, $s0, $a1 		# taking hight of 64, and hight of 64/2 storei into $s0 
	sll	$s0, $s0, 2		# add to base address 
	add	$s0, $s0, $gp 		# $gp and $s0 in new $s0
	sll 	$a3, $t3, 2	
	
	lw	$a3, colorArray($a3)     
	sw	$a3, 0($s0) 		# Store the array of color, be printed out later
	j 	drawTop  
	
	### Comments above will be the same for rightLoop, bottomLoop, & leftLop ###
	
rightLoop: 			
	mul	$s0, $a2, WIDTH 	 
	add 	$s0, $s0, $a1 		
	sll	$s0, $s0, 2		
	add	$s0, $s0, $gp 		
	sll 	$a3, $t3, 2 	
	
	lw	$a3, colorArray($a3)     
	sw	$a3, 0($s0) 	
	
	j 	drawRight	
	
bottomLoop: 
	mul	$s0, $a2, WIDTH 	 
	add 	$s0, $s0, $a1 		 
	sll	$s0, $s0, 2		 
	add	$s0, $s0, $gp 		
	sll 	$a3, $t3, 2 	
	
	lw	$a3, colorArray($a3)     
	sw	$a3, 0($s0) 		
	
	j	drawBottom
	
leftLoop: 
	mul	$s0, $a2, WIDTH 	 
	add 	$s0, $s0, $a1 		 
	sll	$s0, $s0, 2		
	add	$s0, $s0, $gp 		
	sll 	$a3, $t3, 2 	
	
	lw	$a3, colorArray($a3)     
	sw	$a3, 0($s0) 		
	
	j	drawLeft

############ Draw Pixels ##############	
	
drawTop:
	# Checks the total number of time its been printed out
	beq 	$t4, 7, rightRepeat 	# Exit program when it loops 7 times
	bge	$t5, 6, colorStartRes  	# $t5 to 0 whenever we hit the end of array 
	add 	$t4, $t4, 1 		# Add 1 to the counter $t4
	add 	$a1, $a1, 1 		# Adds 1 to x
	add 	$t3, $t3, 1 		# Loops through the array 
	bge	$t3, 7, topReset 	# Loops through the whole array 
		 				   
	j 	topLoop 	
		
	### Comments above will be the same for drawRight, drawBottom, & drawLeft ###
drawRight:
	beq 	$t4, 7, bottomRepeat 	
	add 	$t4, $t4, 1 		
	add 	$a2, $a2, 1 		
	add 	$t3, $t3, 1 		
	bge	$t3, 7, rightReset 
	
	j 	rightLoop
	
drawBottom:	
	beq 	$t4, 7, leftRepeat 	
	add 	$t4, $t4, 1 		
	sub 	$a1, $a1, 1 		
	add 	$t3, $t3, 1 		
	bge	$t3, 7, bottomReset  
		      
	j 	bottomLoop
	
drawLeft:
	beq 	$t4, 7, topRepeat 	 
	add 	$t4, $t4, 1 		
	sub 	$a2, $a2, 1		
	add 	$t3, $t3, 1 		
	bge	$t3, 7, leftReset 
	
	j	leftLoop

marqeeDelay:
	li 	$v0, 32
	li	$a0, 5
	syscall
	
	jal main 
	
############## Black out  Loop ##############	    
	   						   								   					   								   				
topBlackOut:
	mul	$s0, $a2, WIDTH 	# Store WIDTh and $a2 into $s0
	add 	$s0, $s0, $a1 		# Taking hight of 64, and diveide it by 2 and store it into $s0 
	sll	$s0, $s0, 2			# Add it to the base by shifting it left logically 
	add	$s0, $s0, $gp 		# $gp and $s0 in new $s0
	
	li	$a3, 0    
	sw	$a3, 0($s0) 		# Store the array of color, be printed out later
	 
	j	drawTopBlackOut
	
	### Comments above will be the same for rightBlackOut, bottomBlackOut, & leftBlackOut ###	
rightBlackOut: 
	mul	$s0, $a2, WIDTH 	
	add 	$s0, $s0, $a1 		
	sll	$s0, $s0, 2			 
	add	$s0, $s0, $gp 		
	
	li	$a3, 0    
	sw	$a3, 0($s0) 	
	
	j	drawRightBlackOut	
	
bottomBlackOut: 
	mul	$s0, $a2, WIDTH 	
	add 	$s0, $s0, $a1 		 
	sll	$s0, $s0, 2			 
	add	$s0, $s0, $gp 		
	
	li	$a3, 0    
	sw	$a3, 0($s0) 
	
	j	drawBottomBlackOut		 
	
leftBlackOut: 
	mul	$s0, $a2, WIDTH 
	add 	$s0, $s0, $a1 		 
	sll	$s0, $s0, 2			 
	add	$s0, $s0, $gp 		
	
	li	$a3, 0    
	sw	$a3, 0($s0) 
	
	j	drawLeftBlackOut	
		 
############## Draw Pixel - Black Out ##############	

drawTopBlackOut:
	# Checks the total number of time its been printed out 
	beq 	$t4, 7, rightBlackOutRes # Exit program when it loops 7 times
	add 	$t4, $t4, 1 		# Add 1 to the counter $t4
	add 	$a1, $a1, 1 		# Add 1 to x
	
	j 	topBlackOut  
	
	### Comments above will be the same for drawRightBlackOut, drawBottomBlackOut, & drawLeftBlackOut ###
drawRightBlackOut:
	beq 	$t4, 7, bottomBlackOutRes  
	add 	$t4, $t4, 1 		
	add 	$a2, $a2, 1 		
	    
	j 	rightBlackOut 
	
drawBottomBlackOut:	 
	beq 	$t4, 7, leftBlackOutRes 	
	add 	$t4, $t4, 1 		
	sub 	$a1, $a1, 1 		
	      
	j 	bottomBlackOut  
	
drawLeftBlackOut:
	beq 	$t4, 7, originalColor 	 
	add 	$t4, $t4, 1 		
	sub 	$a2, $a2, 1 		
	      
	j 	leftBlackOut
	
############## Black Out reset ##############	

originalColor:
	li 	$t4, 0
	jr	$ra
	
rightBlackOutRes:
	li 	$t4, 0
	j 	rightBlackOut  
	
bottomBlackOutRes:
	li 	$t4, 0
	j 	bottomBlackOut 
	
leftBlackOutRes:
	li 	$t4, 0
	j 	leftBlackOut
	
############### Reseat and Repeat ###################
	
	# Reset the Color
topReset: 
	li 	$t3, 0 
	j 	topLoop
	
rightReset:
	li	$t3, 0 
	j 	rightLoop 
	  
bottomReset:
	li	$t3, 0 
	j 	bottomLoop 
	
leftReset:
	li	$t3, 0 
	j 	leftLoop  
	
	# Repeat and let the marqee effect happen
topRepeat:
	li	$t4, 0
	addi 	$t5, $t5, 1  		# Starting of the color we are printing is $t5
	addi	$t3, $t5, 0 		# Reset the index  
	jr	$ra                   
	
rightRepeat: 
	li 	$t4, 0
	addi	$t3, $t5, 0 
	j 	rightLoop 
	
bottomRepeat: 
	li 	$t4, 0 
	addi	$t3, $t5, 0
	j 	bottomLoop 
	
leftRepeat: 
	li 	$t4, 0 
	addi	$t3, $t5, 0
	j 	leftLoop
	
colorStartRes: 
	li	$t5, 0		# Reset $t5 to be 0 
	j	topLoop  
	
 exit:	
	li $v0, 10
	syscall
	
