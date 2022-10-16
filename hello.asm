# hello.asm
# A "Hello World" program in MIPS Assembly for CS64
#
#  Data Area - allocate and initialize variables
.data
	prompt: .asciiz "Enter an integer: "

#Text Area (i.e. instructions)
.text
main:

	li $v0 4
	la $a0 prompt
	syscall

	li $v0 5
	syscall
	move $t0 $v0

	andi $t1 $t0 1
	li $t2 1
	beq $t1 $t2 is_odd
	bne $t1 $t2 is_even

is_odd:
	li $t3 2
	mult $t0 $t3
	mflo $t0

	li $v0 1
	move $a0 $t0
	syscall

	j exit

is_even:
	li $t3 3
	mult $t0 $t3
	mflo $t0

	li $v0 1
	move $a0 $t0
	syscall

	j exit
	
exit:
	li $v0 10
	syscall
