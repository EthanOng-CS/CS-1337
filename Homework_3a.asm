.data
# c0l0rs

.eqv RED 0x00FF0000

.eqv GREEN 0x0000FF00

.eqv BLUE 0x000000FF

.eqv WHITE 0x00FFFFFF

.eqv YELLOW 0x00FFFF00

.eqv CYAN 0x0000FFFF

.eqv MAGENTA 0x00FF00FF

.data

colors: .word MAGENTA, CYAN, YELLOW, BLUE, GREEN, RED,WHITE
.text
li $s1, 80 #y1 = x p0siti0n 0f the tail
li $s2, 5 #y1 = y p0siti0n 0f the tail

li $t3, 0x10008000 #t3 = first Pixel 0f the screen


li $t0,0 #L0ad index 0
loop1:
mul $t2,$s2,256 #get y index
add $t1,$t0,$s1 #l0ad center address
mul $t1,$t1,4
add $t1,$t1,$t2
addu $t1, $t3, $t1 # adds xy t0 the first pixel ( t3 )
mul $a2,$t0,4 #get addresss of color
lw $a2,colors($a2)
sw $a2, ($t1) # put the c0l0r red ($a2) in $t0
add $t0,$t0,1 #i++

blt $t0,7,loop1

li $t0,0 #L0ad index 0
loop2:
add $t2,$s2,7 #get next line
mul $t2,$t2,256 #get y index
add $t1,$t0,$s1 #l0ad center address
mul $t1,$t1,4
add $t1,$t1,$t2
addu $t1, $t3, $t1 # adds xy t0 the first pixel ( t3 )
mul $a2,$t0,4 #get addresss of color
lw $a2,colors($a2)
sw $a2, ($t1) # put the c0l0r red ($a2) in $t0
add $t0,$t0,1 #i++
blt $t0,7,loop2

li $t0,0 #L0ad index 0
loop3:
add $t2,$s2,$t0 #get next line
mul $t2,$t2,256 #get y index
mul $t1,$s1,4
add $t1,$t1,$t2 #l0ad x y
addu $t1, $t3, $t1 # adds xy t0 the first pixel ( t3 )
mul $a2,$t0,4 #get addresss of color
lw $a2,colors($a2)
sw $a2, ($t1) # put the c0l0r red ($a2) in $t0
add $t0,$t0,1 #i++
blt $t0,7,loop3


li $t0,0 #L0ad index 0
loop4:
add $t2,$s2,$t0 #get next line
mul $t2,$t2,256 #get y index
add $t1,$s1,7 #get next line
mul $t1,$t1,4
add $t1,$t1,$t2 #l0ad x y
addu $t1, $t3, $t1 # adds xy t0 the first pixel ( t3 )
mul $a2,$t0,4 #get addresss of color
lw $a2,colors($a2)
sw $a2, ($t1) # put the c0l0r red ($a2) in $t0
add $t0,$t0,1 #i++
blt $t0,8,loop4