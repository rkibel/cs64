# arithmetic.asm
# A simple calculator program in MIPS Assembly for CS64
#

.text
main:
	li $v0 5
	syscall
	move $t0 $v0
	
	li $v0 5
	syscall
	move $t1 $v0

	sub $t0 $t0 $t1
	sll $t0 $t0 4
	addi $t0 $t0 8

	li $v0 1
	move $a0 $t0
	syscall
	 
	j exit

exit:
	li $v0 10
	syscall

