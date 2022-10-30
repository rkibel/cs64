.data

krabby: .word 1 2 3 4 5 6 7 8 9 10

carray: .word 0:10

marray: .word 0:10

encrypted: .asciiz "Encrypted: "
decrypted: .asciiz "Decrypted: "
commaspace: .asciiz ", "
newline: .asciiz "\n"

.text
main:
	la $a0,krabby
	li $a1,10
	la $a2,carray
	la $a3,marray
	
	move $s0 $a0 # krabby
	move $s1 $a1 # 10
	move $s2 $a2 # carray
	move $s3 $a3 # marray

	li $t0 3 # a
	li $t1 11 # b
	li $t2 0 # i
	
	for_loop:
		bge $t2 $s1 cont1
		move $a0 $t0
		move $a1 $t1
		lw $a2 0($s0)
		jal secret_formula_apply

		sw $v0 0($s2)
		move $a0 $t0
		move $a1 $t1
		move $a2 $v0
		jal secret_formula_remove
		sw $v0 0($s3)

		addiu $s0 $s0 4
		addiu $s2 $s2 4
		addiu $s3 $s3 4
		addiu $t2 $t2 1
		j for_loop

	cont1:
	addiu $s0 $s0 -40
	addiu $s2 $s2 -40
	addiu $s3 $s3 -40

	li $t0 0
	la $a0 encrypted
	li $v0 4
	syscall

	print_arr_c:
		bge $t0 $s1 cont2
		
		lw $a0 0($s2)
		li $v0 1
		syscall
		
		addiu $t0 $t0 1
		addiu $s2 $s2 4
		bge $t0 $s1 cont2
		
		la $a0 commaspace
		li $v0 4
		syscall
		
		j print_arr_c

	cont2:
	
	li $t0 0
	la $a0 newline
	li $v0 4
	syscall
	
	la $a0 decrypted
	li $v0 4
	syscall
	
	print_arr_m:
		bge $t0 $s1 exit
		
		lw $a0 0($s3)
		li $v0 1
		syscall
		
		addiu $t0 $t0 1
		addiu $s3 $s3 4
		bge $t0 $s1 exit
		
		la $a0 commaspace
		li $v0 4
		syscall
		
		j print_arr_m

secret_formula_apply:
	addiu $sp $sp -12
	sw $ra 0($sp)
	sw $t0 4($sp)
	sw $t1 8($sp)

	li $t0 7 # e
	mult $a0 $a1
	mflo $t1 # n

	move $a0 $a2
	move $a1 $t0
	jal pow
	div $v0 $t1
	mfhi $v0

	lw $ra 0($sp)
	lw $t0 4($sp)
	lw $t1 8($sp)
	addiu $sp $sp 12

	jr $ra

secret_formula_remove:
	addiu $sp $sp -12
	sw $ra 0($sp)
	sw $t0 4($sp)
	sw $t1 8($sp)
	
	li $t0 3 # d
	mult $a0 $a1
	mflo $t1 # n

	move $a0 $a2
	move $a1 $t0
	jal pow
	div $v0 $t1
	mfhi $v0

	lw $ra 0($sp)
	lw $t0 4($sp)
	lw $t1 8($sp)
	addiu $sp $sp 12

	jr $ra

pow:
	addiu $sp $sp -12
	sw $ra 0($sp)
	sw $t0 4($sp)
	sw $t1 8($sp)
	
	li $t0 1 # store temp result 
	li $t1 0 # store temp exponent
	jal while_loop
	move $v0 $t0
	
	lw $ra 0($sp)
	lw $t0 4($sp)
	lw $t1 8($sp)
	addiu $sp $sp 12
	
	jr $ra

	while_loop:
		blt $t1 $a1 multiply
		jr $ra

	multiply:
		mult $t0 $a0
		mflo $t0
		addiu $t1 1
		j while_loop
exit:
	li $v0, 10
	syscall


