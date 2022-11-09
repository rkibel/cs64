disaggregate:
        addiu $sp, $sp, -32 # ?? = the negative of how many values we store in (stack * 4)
        sw $s0 0($sp)
        sw $s1 4($sp)
        sw $s2 8($sp)
        sw $s3 12($sp)
        sw $s4 16($sp)
        sw $s5 20($sp)
        sw $s6 24($sp)
        sw $s7 28($sp)
        sw $ra 32($sp)

        move $s0, $a0
        move $s1, $a1
        move $s2, $a2
        move $s3, $a3
        
        # store all required values that need to be preserved across function calls
        
        # store array address on stack
        # store n on stack
        # store buffer pointer on stack
        # store length of array on stack

        # Since our array_len parameter becomes small/big array len
        # We need them to be what they were before the next recursive call!

        # store small array length on stack
        # store big array length on stack

        # multiple function calls overwrite ra, therefore must be preserved
        # store return address

        # print depth value, according to expected format
        la $a0, depth    
        li $v0, 4
        syscall
        li $v0, 1
        move $a0, $s1
        syscall
        la $a0, colon    
        li $v0, 4
        syscall
        
        # Don't forget to define your variables!

        # It's dangerous to go alone, take this one loop for free
        # please enjoy and use carefully
        # this code makes no assumptions on your code
        # fix this code to work with yours or vice versa
        # don't have to use this loop either can make your own too
        li $t2 0 # sum
        li $t7 0 # i
        loop:
            li $t5 4
            mult $s3 $t5
            mflo $t6
            # find sum
            bge $t7, $t6, func_check # this is the loop exit condition
            addu $s0 $t7
            lw $t6, 0($s0)
            subu $s0 $t7
            
            # print array entry
            li $v0, 1
            move $a0, $t6
            syscall
            li $v0, 4
            la $a0, comma
            syscall
            
            addi $t7, $t7, 4
            add $t2, $t2, $t6
            j loop

        func_check:
            # Add the recursive function end condition
            # Needs to exist so that we don't end up recursing to infinity!
            # This is the recursive equivalent to our iteration condition
            # for example the i < 10 in a for/while loop
            # We have two recursive conditions: depth == 0, arr_len == 1
            # They are OR'd in the C/C++ template
            # Do you need to OR them in MIPs too? 
            beq $s1 $0 $ra
            li $t7 1
            beq $s3 $t7 $ra
        # calculate the average 
        div $t2, $s3 # what register do we divide by? 
        mflo $t3 # avg 

        move $s4 $s2 # small_arr
        addiu $s5 $s2 40 # big_arr

        li $t0 0 # j*4
        li $t1 0 # k*4
        li $t7 0 # i*4
        # This is the main loop, not for free :/
        loop2:
            li $t5 4
            mult $s3 $t5
            mflo $t6
            
            bge $t7 $t6 closing
            
            addu $s0 $s0 $t7
            lw $t6 0($s0) # arr[i]
            subu $s0 $s0 $t7
            
            ble $t6 $t3 set_small_arr
            
            addu $s5 $s5 $t1
            sw $t6 0($s5)
            subu $s5 $s5 $t1
            
            addi $t1 $t1 4
            addi $t7 $t7 4
            j loop2
            # find big and small array
            # Remember the conditions for splitting
            # if entry <= average put in small array
            # if entry > average put in big array
            set_small_arr:
                addu $s4 $s4 $t0
                sw $t6 0($s4)
                subu $s4 $s4 $t0

                addi $t0 $t0 4
                addi $t7 $t7 4
                j loop2
        closing:
        # This is the section where we prepare to call the function recursively.
            li $t5 4
            div $t0 $t5
            mflo $s6 # small_arr_len

            div $t1 $t5
            mflo $s7 # big_arr_len 
            
            jal ConventionCheck # DO NOT REMOVE 

            # Make sure your $s registers have the correct values before calling
            # Remember we recursively call with small array first
            # So load small array arguments in $s registers
            
            # This is updating the buffer so that we don't overwrite our old values
            addi $s2, $s2, 80
            addi $s1 $s1 -1
            move $a0 $s4
            move $a1 $s1
            move $a2 $s2
            move $a3 $s6
            # We call small array first so we load small array length as arr_len
            
            jal disaggregate

            jal ConventionCheck # DO NOT REMOVE
            
            # Similarly for big array, we mirror the call structure of small array as above
            # But with the values appropriate for big array. 

            addi $s2, $s2, 80
            move $a0 $s5
            move $a1 $s1
            move $a2 $s2
            move $a3 $s7
            
            jal disaggregate

            j function_end
        
        function_end:
        # Here we reset our values from previous iterations
        # Be careful on which values you load before and after the $sp update if you have to 
        # We can accidentally end up loading values of current calls instead of previous calls
        # Manually drawing out the stack changes helps figure this step out
            lw $s0 0($sp)
            lw $s1 4($sp)
            lw $s2 8($sp)
            lw $s3 12($sp)
            lw $s4 16($sp)
            lw $s5 20($sp)
            lw $s6 24($sp)
            lw $s7 28($sp)
            lw $ra 32($sp)
            # Load values before update if you have to
            addiu $sp, $sp, 32 # ?? = the positive of how many values we store in (stack * 4)
            # Load values after update if you have to
            jr $ra