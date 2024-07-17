.data
# small data table
S0: .byte 0x2, 0xF, 0xC, 0x1, 0x5, 0x6, 0xA, 0xD, 0xE, 0x8, 0x3, 0x4, 0x0, 0xB, 0x9, 0x7
S1: .byte 0xF, 0x4, 0x5, 0x8, 0x9, 0x7, 0x2, 0x1, 0xA, 0x3, 0x0, 0xE, 0x6, 0xC, 0xD, 0xB
S2: .byte 0x4, 0xA, 0x1, 0x6, 0x8, 0xF, 0x7, 0xC, 0x3, 0x0, 0xE, 0xD, 0x5, 0x9, 0xB, 0x2
S3: .byte 0x7, 0xC, 0xE, 0x9, 0x2, 0x1, 0x5, 0xF, 0xB, 0x6, 0xD, 0x0, 0x4, 0x8, 0xA, 0x3

large: .byte 0x2, 0xF, 0xC, 0x1, 0x5, 0x6, 0xA, 0xD, 0xE, 0x8, 0x3, 0x4, 0x0, 0xB, 0x9, 0x7, 0xF, 0x4, 0x5, 0x8, 0x9, 0x7, 0x2, 0x1, 0xA, 0x3, 0x0, 0xE, 0x6, 0xC, 0xD, 0xB, 0x4, 0xA, 0x1, 0x6, 0x8, 0xF, 0x7, 0xC, 0x3, 0x0, 0xE, 0xD, 0x5, 0x9, 0xB, 0x2, 0x7, 0xC, 0xE, 0x9, 0x2, 0x1, 0x5, 0xF, 0xB, 0x6, 0xD, 0x0, 0x4, 0x8, 0xA, 0x3

newline: .asciiz "\n"
hexChars: .asciiz "0123456789ABCDEF"

K: .word 0x00002301, 0x00006745, 0x0000AB89, 0x0000EFCD, 0x0000DCFE, 0x000098BA, 0x00005476, 0x00001032
IV: .word 0x00003412, 0x00007856, 0x0000BC9A, 0x0000F0DE
R: .word 0, 0, 0, 0, 0, 0, 0, 0 # reserve space


.text
main:
##### Subs - Small Test Phase 2.1.0 #####
#	li $a0, 0xabcd
#	jal subs_small_func
#	add $t0, $zero, $v0
#	jal print_hex

#	li $a0, 0xFDCA
#	jal subs_small_func
#	add $t0, $zero, $v0
#	jal print_hex

##### Subs - Large Test Phase 2.1.1 #####
#	li $a0, 0x1111
#	jal subs_large_func
#	add $t0, $zero, $v0
#	jal print_hex

#	li $a0, 0xFDCA
#	jal subs_large_func
#	add $t0, $zero, $v0
#	jal print_hex
	
##### Subs - Cache Test Phase 2.1.2 #####

#	li $s0, 100
#	li $s1, 0
#loop_cache:
#	li $a0, 0              # Lower bound of the random number
#    	li $a1, 65535            # Upper bound of the random number
#    	li $v0, 42             # System call number for random number generation
#    	syscall                # Generates a random number between 0 and 255
    	
#    	add $t0, $zero, $a0
#    	add $s2, $zero, $a0
    	#jal print_hex
#    	add $a0, $s2, $zero
#    	jal subs_large_func
    	#jal subs_small_func
#    	add $t0, $zero, $v0
 #   	jal print_hex
    	
 #   	la $a0, newline       
 #   	li $v0, 4             
 #   	syscall
    	
#    	addi $s1, $s1, 1
#    	bne $s1, $s0, loop_cache


##### Linear Test Phase 2.2 ######
#	li $a0, 0xbbaa
#	jal linear_func
#	add $t0, $zero, $v0
#	jal print_hex
	
#	li $a0, 0x1111
#	jal linear_func
#	add $t0, $zero, $v0
#	jal print_hex


##### PERM TEST Phase 2.3 ######
#	li $a0, 0xd6
#	jal perm_func
#	add $t0, $zero, $v0
#	jal print_binary
	
#	li $a0, 0xb1
#	jal perm_func
#	add $t0, $zero, $v0
#	jal print_binary

##### F_Function Test Phase 3.1 ######
	li $a0, 0xbbaa
	jal f_function
	add $t0, $zero, $v0
	jal print_hex
	
	li $a0, 0x1111
	jal f_function
	add $t0, $zero, $v0
	jal print_hex
	jal print_newline

##### W_Function Test Phase 3.2 ######
	li $a0, 0xbbaa
	li $a1, 0xcccc
	li $a2, 0xdddd
	jal w_function
	add $t0, $zero, $v0
	jal print_hex
	jal print_newline
	
##### Init Algorithm Test Phase 3.3 #####
	la $a0, K
	la $a1, IV
	la $a2, R
	jal init_algorithm
	li $s0, 0
	li $s1, 8
	la $s2, R
loop_print:
	li $t2, 4
	mul $t1, $t2, $s0
	add $t1, $s2, $t1
	lw $t0, 0($t1)
	jal print_hex
	
	addi $s0, $s0, 1
	bne $s0, $s1, loop_print
	jal print_newline

	
	j exit
exit:
	li $v0, 10
	syscall

############## functions ############
subs_small_func:
	andi $t0, $a0, 0xF000
	andi $t1, $a0, 0x0F00
	andi $t2, $a0, 0x00F0
	andi $t3, $a0, 0x000F

	la $t4, S0
	la $t5, S1
	la $t6, S2
	la $t7, S3
	
	srl $t0, $t0, 12
	srl $t1, $t1, 8
	srl $t2, $t2, 4

	add $t0, $t0, $t4
	add $t1, $t1, $t5
	add $t2, $t2, $t6
	add $t3, $t3, $t7
	
	lbu $t0, 0($t0)
	lbu $t1, 0($t1)
	lbu $t2, 0($t2)
	lbu $t3, 0($t3)
	
	sll $t0, $t0, 12
	sll $t1, $t1, 8
	sll $t2, $t2, 4
	
	or $t0, $t0, $t1
	or $t2, $t2, $t3
	or $v0, $t0, $t2
	
	jr $ra 

subs_large_func:

	andi $t0, $a0, 0xF000
	andi $t1, $a0, 0x0F00
	andi $t2, $a0, 0x00F0
	andi $t3, $a0, 0x000F

	la $t5, large
	
	srl $t0, $t0, 12
	srl $t1, $t1, 8
	srl $t2, $t2, 4

	addi $t1, $t1, 16
	addi $t2, $t2, 32
	addi $t3, $t3, 48

	add $t0, $t0, $t5
	add $t1, $t1, $t5
	add $t2, $t2, $t5
	add $t3, $t3, $t5
	
	lbu $t0, 0($t0)
	lbu $t1, 0($t1)
	lbu $t2, 0($t2)
	lbu $t3, 0($t3)
	
	sll $t0, $t0, 12
	sll $t1, $t1, 8
	sll $t2, $t2, 4
	
	or $t0, $t0, $t1
	or $t2, $t2, $t3
	or $v0, $t0, $t2
	
	jr $ra 

linear_func:
	sll $t1, $a0, 6
	andi $t1, $t1, 0xFFFF       
	srl $t2, $a0, 10          
	or $t3, $t1, $t2 
	
	srl $t1, $a0, 6           
	sll $t2, $a0, 10
	andi $t2, $t2, 0xFFFF    
	or $t4, $t1, $t2

	xor $t5, $a0, $t3
	xor $t5, $t5, $t4
	
	addi $v0, $t5, 0
	jr $ra
	
perm_func:
	li $v0, 0
	
	andi $t0, $a0, 0x00000080
	andi $t1, $a0, 0x00000040
	andi $t2, $a0, 0x00000020
	andi $t3, $a0, 0x00000010
	andi $t4, $a0, 0x00000008
	andi $t5, $a0, 0x00000004
	andi $t6, $a0, 0x00000002
	andi $t7, $a0, 0x00000001
	
	srl $t0, $t0, 5
	srl $t1, $t1, 6
	srl $t2, $t2, 1
	srl $t3, $t3, 1
	sll $t4, $t4, 2
	srl $t5, $t5, 1
	sll $t6, $t6, 5
	sll $t7, $t7, 7
	
	
	or $t0, $t0, $t1
	or $t2, $t2, $t3
	or $t4, $t4, $t5
	or $t6, $t6, $t7
	
	or $t0, $t0, $t2
	or $t4, $t4, $t6
	
	or $v0, $t0, $t4
	jr $ra

# PHASE 2

f_function:
	addi $sp, $sp, -8
	sw   $a0, 0($sp)
	sw   $ra, 4($sp)
	
	andi $t0, $a0, 0xFF00 
	srl $a0, $t0, 8
	
	jal perm_func
	add $t0, $v0, $zero
	
	lw $a0, 0($sp)
	andi $t1, $a0, 0x00FF
	sll $t1, $t1, 8
	or $a0, $t0, $t1
	
	jal subs_large_func
	add $a0, $v0, $zero
	jal linear_func
	
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
w_function:
	addi $sp, $sp, -16
	sw   $ra, 0($sp)
	sw   $a0, 4($sp) # X
	sw   $a1, 8($sp) # A
	sw   $a2, 12($sp) # B
	
	xor $a0, $a0, $a1 # xor X and A
	jal f_function # call F function obtain result in v0
	xor $a0, $v0, $a2 # xor result with B
	jal f_function
	
	lw   $ra, 0($sp)
	lw   $a0, 4($sp)
	lw   $a1, 8($sp) 
	lw   $a2, 12($sp) 
	addi $sp, $sp, 16
	jr $ra
	

init_algorithm:
	addi $sp, $sp, -48
	sw $ra, 0($sp)
	sw $a0, 4($sp) # K
	sw $a1, 8($sp) # IV
	sw $a2, 12($sp) # R
	
	sw $s0, 16($sp)
	sw $s1, 20($sp)
	sw $s2, 24($sp)
	sw $s3, 28($sp)
	sw $s4, 32($sp)
	sw $s5, 36($sp)
	sw $s6, 40($sp)
	sw $s7, 44($sp)
	
	add $s0, $a0, $zero
	add $s1, $a1, $zero
	add $s2, $a2, $zero
	
	li $s3, 0
	li $s4, 8
	li $s5, 4
	
init_first_loop:
	div $t0, $s3, $s5 # find the address of IV
	mfhi $t0
	mul $t0, $t0, $s5
	add $t0, $t0, $s1
	lw $t2, 0($t0)
	
	mul $t1, $s3, $s5 # find the address of R
	add $t1, $t1, $s2
	sw $t2, 0($t1)
	
	addi $s3, $s3, 1
	bne $s3, $s4, init_first_loop
	
	li $s3, 0
	li $s4, 4
init_second_loop:
	addi $sp, $sp, -16
	
	lw $t0, 0($s2) ### calculate and save t0
	add $t0, $t0, $s3
	and $a0, $t0, 0x0000ffff
	lw $a1, 4($s0)
	lw $a2, 12($s0)
	jal w_function
	sw $v0, 0($sp)
	
	lw $t0, 4($s2)  ### calculate and save t1
	add $t0, $t0, $v0
	and $a0, $t0, 0x0000ffff
	lw $a1, 20($s0)
	lw $a2, 28($s0)
	jal w_function
	sw $v0, 4($sp)
	
	lw $t0, 8($s2)  ### calculate and save t2
	add $t0, $t0, $v0
	and $a0, $t0, 0x0000ffff
	lw $a1, 0($s0)
	lw $a2, 8($s0)
	jal w_function
	sw $v0, 8($sp)
	
	lw $t0, 12($s2)  ### calculate and save t3
	add $t0, $t0, $v0
	and $a0, $t0, 0x0000ffff
	lw $a1, 16($s0)
	lw $a2, 24($s0)
	jal w_function
	sw $v0, 12($sp)
		
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)	
	
	lw $t4, 0($s2)
	lw $t5, 4($s2)
	lw $t6, 8($s2)
	lw $t7, 12($s2)

	# Score of r0 in t3
	add $t3, $t3, $t4
	andi $t3, $t3, 0x0000ffff	
	sll $t8, $t3, 7
	andi $t8, $t8 0x0000ffff
	srl $t9, $t3, 9
	or $t3, $t8, $t9
	
	# Score of r1 in t0
	add $t0, $t0, $t5
	andi $t0, $t0, 0x0000ffff
	sll $t8, $t0, 12
	andi $t8, $t8 0x0000ffff
	srl $t9, $t0, 4
	or $t0, $t8, $t9
	
	# Score of r2 in t1
	add $t1, $t1, $t6
	andi $t1, $t1, 0x0000ffff
	sll $t8, $t1, 2
	andi $t8, $t8 0x0000ffff
	srl $t9, $t1, 14
	or $t1, $t8, $t9
	
	# Score of r3 in t2
	add $t2, $t2, $t7
	andi $t2, $t2, 0x0000ffff
	sll $t8, $t2, 7
	andi $t8, $t8 0x0000ffff
	srl $t9, $t2, 9
	or $t2, $t8, $t9

	lw $t4, 16($s2)
	xor $t4, $t4, $t2
	lw $t5, 20($s2)
	xor $t5, $t5, $t0
	lw $t6, 24($s2)
	xor $t6, $t6, $t1
	lw $t7, 28($s2)
	xor $t7, $t7, $t3
	
	sw $t3, 0($s2)
	sw $t0, 4($s2)
	sw $t1, 8($s2)
	sw $t2, 12($s2)
	sw $t4, 16($s2)
	sw $t5, 20($s2)
	sw $t6, 24($s2)
	sw $t7, 28($s2)	
	
	addi $s3, $s3, 1
	addi $sp, $sp, 16
	bne $s3, $s4, init_second_loop
	

	lw $ra, 0($sp)
	lw $a0, 4($sp) 
	lw $a1, 8($sp) 
	lw $a2, 12($sp) 
	
	lw $s0, 16($sp)
	lw $s1, 20($sp)
	lw $s2, 24($sp)
	lw $s3, 28($sp)
	lw $s4, 32($sp)
	lw $s5, 36($sp)
	lw $s6, 40($sp)
	lw $s7, 44($sp)
	addi $sp, $sp, 48
	jr $ra
	

####### JUST FOR PRINT ########

print_binary:
    li $t1, 8             
    li $t2, 0x80
loop_binary:
    and $t3, $t0, $t2     
    beqz $t3, print_zero  
    li $a0, '1'           
    j print_char
print_zero:
    li $a0, '0'           
print_char:
    li $v0, 11            
    syscall
    srl $t2, $t2, 1       
    subi $t1, $t1, 1     
    bnez $t1, loop_binary

    la $a0, newline     
    li $v0, 4         
    syscall
    
    jr $ra


#### Print Hex format
print_hex:
    li $t1, 4             
    li $t2, 0xF000        

loop_hex:
    and $t3, $t0, $t2  
    srl $t3, $t3, 12
    la $t5, hexChars
    add $t3, $t3, $t5
    lb $a0, 0($t3)
    li $v0, 11
    syscall
    sll $t0, $t0, 4      
    subi $t1, $t1, 1
    bnez $t1, loop_hex

    la $a0, newline       
    li $v0, 4             
    syscall

    jr $ra                
   
print_newline:
    la $a0, newline       
    li $v0, 4             
    syscall          
    jr $ra