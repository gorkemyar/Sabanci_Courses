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
P: .word 0x1100, 0x3322, 0x5544, 0x7766, 0x9988, 0xBBAA, 0xDDCC, 0xFFEE
C: .word -1, 0, 0, 0, 0, 0, 0, 0 # reserve space
DC: .word -1, 0, 0, 0, 0, 0, 0, 0 # reserve space

S_inv_0: .byte 0xC, 0x3, 0x0, 0xA, 0xB, 0x4, 0x5, 0xF, 0x9, 0xE, 0x6, 0xD, 0x2, 0x7, 0x8, 0x1  
S_inv_1: .byte 0xA, 0x7, 0x6, 0x9, 0x1, 0x2, 0xC, 0x5, 0x3, 0x4, 0x8, 0xF, 0xD, 0xE, 0xB, 0x0
S_inv_2: .byte 0x9, 0x2, 0xF, 0x8, 0x0, 0xC, 0x3, 0x6, 0x4, 0xD, 0x1, 0xE, 0x7, 0xB, 0xA, 0x5
S_inv_3: .byte 0xB, 0x5, 0x4, 0xF, 0xC, 0x6, 0x9, 0x0, 0xD, 0x3, 0xE, 0x8, 0x1, 0xA, 0x2, 0x7  

message: .asciiz "Please enter a 4 byte hexadecimal number: "
buffer: .space 1000
.text
main:
	
##### Print Plain text #####
	li $s0, 0
	li $s1, 8
	la $s2, P
loop_get_plain:
	li $v0, 4
	la $a0, message
	syscall

	li $v0, 8
	la $a0, buffer
	li $a1, 16
	syscall
	
	la $t0, buffer
	li $t1, 0
	li $t3, 16
	li $t7, 0
	jal convert
	
	li $t2, 4
	mul $t1, $t2, $s0
	add $t1, $s2, $t1
	sw $v0, 0($t1)
	addi $t0, $v0, 0
	jal print_hex
	
	addi $s0, $s0, 1
	bne $s0, $s1, loop_get_plain
	jal print_newline
	
##### Init Algorithm Test Phase 3.3 #####
	la $a0, K
	la $a1, IV
	la $a2, R
	jal init_algorithm

##### Encryption Algorithm Test Phase 4 #####
	li $s0, 0
	li $s1, 8
	la $s2, P
	la $s3, C
loop_encrypt:
	li $t2, 4
	mul $t1, $t2, $s0
	add $a0, $s2, $t1
	add $a1, $s3, $t1
	jal encryption
	
	lw $t0, 0($a1)
	jal print_hex
	
	addi $s0, $s0, 1
	bne $s0, $s1, loop_encrypt
	jal print_newline
##### Decryption Algorithm Test Phase 5.2 #####
	la $a0, K
	la $a1, IV
	la $a2, R
	jal init_algorithm
	li $s0, 0
	li $s1, 8
	la $s2, C
	la $s3, DC
loop_decrypt:
	li $t2, 4
	mul $t1, $t2, $s0
	add $a0, $s2, $t1
	add $a1, $s3, $t1
	jal decryption
	
	lw $t0, 0($a1)
	jal print_hex
	
	addi $s0, $s0, 1
	bne $s0, $s1, loop_decrypt
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
	
# PHASE 3

encryption:
	addi $sp, $sp, -44
	sw $ra, 0($sp)
	sw $a0, 4($sp) # address of p
	sw $a1, 8($sp) # address of c
	
	sw $s0, 12($sp) # save the registers that are going to used
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	sw $s5, 32($sp)
	sw $s6, 36($sp)
	sw $s7, 40($sp)
	
	#load addresses
	la $s0, K
	la $s1, R
	add $s2, $a0, $zero # p
	add $s3, $a1, $zero # c

	#calculations
	addi $sp, $sp, -12 ## memory allocation for t0, t1, t2
	# t0
	lw $t0, 0($s1)
	lw $t1, 0($s2)
	add $s5, $t0, $t1
	andi $s5, $s5, 0x0000ffff
	
	lw $t0, 0($s0)
	lw $t1, 0($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s6, $v0, $zero
	
	lw $t0, 4($s0)
	lw $t1, 4($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s7, $v0, $zero
	
	add $a0, $s5, $zero
	add $a1, $s6, $zero
	add $a2, $s7, $zero
	
	jal w_function
	sw $v0, 0($sp)
	
	# t1
	lw $t0, 4($s1)
	add $s5, $t0, $v0
	andi $s5, $s5, 0x0000ffff
	
	lw $t0, 8($s0)
	lw $t1, 8($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s6, $v0, $zero
	
	lw $t0, 12($s0)
	lw $t1, 12($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s7, $v0, $zero
	
	add $a0, $s5, $zero
	add $a1, $s6, $zero
	add $a2, $s7, $zero
	
	jal w_function
	sw $v0, 4($sp)
	
	# t2
	lw $t0, 8($s1)
	add $s5, $t0, $v0
	andi $s5, $s5, 0x0000ffff
	
	lw $t0, 16($s0)
	lw $t1, 16($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s6, $v0, $zero
	
	lw $t0, 20($s0)
	lw $t1, 20($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s7, $v0, $zero
	
	add $a0, $s5, $zero
	add $a1, $s6, $zero
	add $a2, $s7, $zero
	
	jal w_function
	sw $v0, 8($sp)
	
	# C
	lw $t0, 12($s1)
	add $s5, $t0, $v0
	andi $s5, $s5, 0x0000ffff
	
	lw $t0, 24($s0)
	lw $t1, 24($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s6, $v0, $zero
	
	lw $t0, 28($s0)
	lw $t1, 28($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s7, $v0, $zero
	
	add $a0, $s5, $zero
	add $a1, $s6, $zero
	add $a2, $s7, $zero
	
	jal w_function
	lw $t0, 0($s1)
	add $t0, $v0, $t0
	andi $t0, $t0, 0x0000ffff
	sw $t0, 0($s3) # save C (encrypted message)
	
	##### calculation for T array to update R #####
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	addi $sp, $sp, 12 #### release memory for allocated t0, t1, t2
	
	addi $sp, $sp -32 # allocate memory for T array
	# T0
	lw $t3, 0($s1)
	add $t3, $t3, $t2
	and $t3, 0x0000ffff
	sw $t3, 0($sp)
	# T1
	lw $t3, 4($s1)
	add $t3, $t3, $t0
	and $t3, 0x0000ffff
	sw $t3, 4($sp)
	# T2
	lw $t3, 8($s1)
	add $t3, $t3, $t1
	and $t3, 0x0000ffff
	sw $t3, 8($sp)
	# T3
	lw $t3, 0($s1)
	lw $t4, 12($s1)
	add $t3, $t3, $t4
	add $t3, $t3, $t0
	add $t3, $t3, $t2
	and $t3, 0x0000ffff
	sw $t3, 12($sp)
	# T4
	lw $t4, 16($s1)
	xor $t3, $t3, $t4
	sw $t3, 16($sp)
	# T5
	lw $t3, 4($sp)
	lw $t4, 20($s1)
	xor $t3, $t3, $t4
	sw $t3, 20($sp)
	# T6
	lw $t3, 8($sp)
	lw $t4, 24($s1)
	xor $t3, $t3, $t4
	sw $t3, 24($sp)
	# T7
	lw $t3, 0($sp)
	lw $t4, 28($s1)
	xor $t3, $t3, $t4
	sw $t3, 28($sp)
	
	li $t0, 0
	li $t1, 8
	li $t2, 4	
loop_update_r:
	mul $t3, $t0, $t2
	add $t4, $t3, $sp
	lw $t4, 0($t4)
	
	add $t5, $t3, $s1
	sw $t4, 0($t5)
	
	addi $t0, $t0, 1
	bne $t0, $t1, loop_update_r
	addi $sp, $sp, 32 #### delete T array
	
	#### get the initial values back ######
	lw $ra, 0($sp)
	lw $a0, 4($sp) 
	lw $a1, 8($sp) 
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s4, 28($sp)
	lw $s5, 32($sp)
	lw $s6, 36($sp)
	lw $s7, 40($sp)	
	addi $sp, $sp, 44
	
	jr $ra

# Phase 4
subs_inv_func:
	andi $t0, $a0, 0xF000
	andi $t1, $a0, 0x0F00
	andi $t2, $a0, 0x00F0
	andi $t3, $a0, 0x000F

	la $t4, S_inv_0
	la $t5, S_inv_1
	la $t6, S_inv_2
	la $t7, S_inv_3
	
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

linear_inv_func:
	sll $t1, $a0, 10
	andi $t1, $t1, 0xFFFF       
	srl $t2, $a0, 6         
	or $t3, $t1, $t2 
	
	srl $t1, $a0, 10           
	sll $t2, $a0, 6
	andi $t2, $t2, 0xFFFF    
	or $t4, $t1, $t2

	xor $t5, $a0, $t3
	xor $t5, $t5, $t4
	
	sll $t1, $t5, 4
	andi $t1, $t1, 0xFFFF       
	srl $t2, $t5, 12         
	or $t3, $t1, $t2 
	
	srl $t1, $t5, 4           
	sll $t2, $t5, 12
	andi $t2, $t2, 0xFFFF    
	or $t4, $t1, $t2
	
	xor $t5, $t5, $t3
	xor $t5, $t5, $t4	
	
	addi $v0, $t5, 0
	jr $ra

perm_inv_func:
	li $v0, 0
	
	andi $t0, $a0, 0x00000080
	andi $t1, $a0, 0x00000040
	andi $t2, $a0, 0x00000020
	andi $t3, $a0, 0x00000010
	andi $t4, $a0, 0x00000008
	andi $t5, $a0, 0x00000004
	andi $t6, $a0, 0x00000002
	andi $t7, $a0, 0x00000001
	
	srl $t0, $t0, 7
	srl $t1, $t1, 5
	srl $t2, $t2, 2
	sll $t3, $t3, 1
	sll $t4, $t4, 1
	sll $t5, $t5, 5
	sll $t6, $t6, 1
	sll $t7, $t7, 6
	
	or $t0, $t0, $t1
	or $t2, $t2, $t3
	or $t4, $t4, $t5
	or $t6, $t6, $t7
	
	or $t0, $t0, $t2
	or $t4, $t4, $t6
	
	or $v0, $t0, $t4
	jr $ra

f_inv_function:
	addi $sp, $sp, -12
	sw   $a0, 0($sp)
	sw   $ra, 4($sp)
	sw   $s0, 8($sp)
	
	jal linear_inv_func
	add $a0, $v0, $zero
	jal subs_inv_func
	
	andi $a0, $v0, 0x00ff
	andi $s0, $v0, 0xff00
	
	jal perm_inv_func
	
	sll $v0, $v0, 8
	srl $s0, $s0, 8
	
	or $v0, $v0, $s0
	
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	lw $s0, 8($sp)
	addi $sp, $sp, 12
	
	jr $ra
	
w_inv_function:
	addi $sp, $sp, -16
	sw   $ra, 0($sp)
	sw   $a0, 4($sp) # X
	sw   $a1, 8($sp) # A
	sw   $a2, 12($sp) # B
	
	jal f_inv_function
	xor $a0, $v0, $a2 # xor X and A
	jal f_inv_function # call F function obtain result in v0
	xor $v0, $v0, $a1 # xor result with B
	
	lw   $ra, 0($sp)
	lw   $a0, 4($sp)
	lw   $a1, 8($sp) 
	lw   $a2, 12($sp) 
	addi $sp, $sp, 16
	jr $ra
	
##### Phase 4 Decryption

decryption:
	addi $sp, $sp, -44
	sw $ra, 0($sp)
	sw $a0, 4($sp) # address of c
	sw $a1, 8($sp) # address of p
	
	sw $s0, 12($sp) # save the registers that are going to used
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	sw $s3, 24($sp)
	sw $s4, 28($sp)
	sw $s5, 32($sp)
	sw $s6, 36($sp)
	sw $s7, 40($sp)
	
	#load addresses
	la $s0, K
	la $s1, R
	add $s2, $a0, $zero # c
	add $s3, $a1, $zero # dc

	#calculations
	addi $sp, $sp, -12 ## memory allocation for t0, t1, t2
	# t2
	lw $t0, 0($s1)
	lw $t1, 0($s2)
	sub $s5, $t1, $t0
	andi $s5, $s5, 0x0000ffff
	
	lw $t0, 24($s0)
	lw $t1, 24($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s6, $v0, $zero
	
	lw $t0, 28($s0)
	lw $t1, 28($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s7, $v0, $zero
	
	add $a0, $s5, $zero
	add $a1, $s6, $zero
	add $a2, $s7, $zero
	
	jal w_inv_function
	
	lw $t0, 12($s1)
	sub $v0, $v0, $t0
	and $v0, $v0, 0x0000ffff
	sw $v0, 0($sp)
	
	# t1
	add $s5, $zero, $v0
	
	lw $t0, 16($s0)
	lw $t1, 16($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s6, $v0, $zero
	
	lw $t0, 20($s0)
	lw $t1, 20($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s7, $v0, $zero
	
	add $a0, $s5, $zero
	add $a1, $s6, $zero
	add $a2, $s7, $zero
	
	jal w_inv_function
	lw $t0, 8($s1)
	sub $v0, $v0, $t0
	and $v0, $v0, 0x0000ffff
	sw $v0, 4($sp)
	
	# t0
	add $s5, $zero, $v0
	
	lw $t0, 8($s0)
	lw $t1, 8($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s6, $v0, $zero
	
	lw $t0, 12($s0)
	lw $t1, 12($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s7, $v0, $zero
	
	add $a0, $s5, $zero
	add $a1, $s6, $zero
	add $a2, $s7, $zero
	
	jal w_inv_function
	lw $t0, 4($s1)
	sub $v0, $v0, $t0
	and $v0, $v0, 0x0000ffff
	sw $v0, 8($sp)
	
	# C
	add $s5, $zero, $v0
	
	lw $t0, 0($s0)
	lw $t1, 0($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s6, $v0, $zero
	
	lw $t0, 4($s0)
	lw $t1, 4($s1) 
	xor $a0, $t0, $t1
	jal linear_func
	add $s7, $v0, $zero
	
	add $a0, $s5, $zero
	add $a1, $s6, $zero
	add $a2, $s7, $zero
	
	jal w_inv_function
	lw $t0, 0($s1)
	sub $t0, $v0, $t0
	andi $t0, $t0, 0x0000ffff
	sw $t0, 0($s3) # save p (decrypted message)
	
	##### calculation for T array to update R #####
	lw $t2, 0($sp)
	lw $t1, 4($sp)
	lw $t0, 8($sp)
	addi $sp, $sp, 12 #### release memory for allocated t0, t1, t2
	
	addi $sp, $sp -32 # allocate memory for T array
	# T0
	lw $t3, 0($s1)
	add $t3, $t3, $t2
	and $t3, 0x0000ffff
	sw $t3, 0($sp)
	# T1
	lw $t3, 4($s1)
	add $t3, $t3, $t0
	and $t3, 0x0000ffff
	sw $t3, 4($sp)
	# T2
	lw $t3, 8($s1)
	add $t3, $t3, $t1
	and $t3, 0x0000ffff
	sw $t3, 8($sp)
	# T3
	lw $t3, 0($s1)
	lw $t4, 12($s1)
	add $t3, $t3, $t4
	add $t3, $t3, $t0
	add $t3, $t3, $t2
	and $t3, 0x0000ffff
	sw $t3, 12($sp)
	# T4
	lw $t4, 16($s1)
	xor $t3, $t3, $t4
	sw $t3, 16($sp)
	# T5
	lw $t3, 4($sp)
	lw $t4, 20($s1)
	xor $t3, $t3, $t4
	sw $t3, 20($sp)
	# T6
	lw $t3, 8($sp)
	lw $t4, 24($s1)
	xor $t3, $t3, $t4
	sw $t3, 24($sp)
	# T7
	lw $t3, 0($sp)
	lw $t4, 28($s1)
	xor $t3, $t3, $t4
	sw $t3, 28($sp)
	
	li $t0, 0
	li $t1, 8
	li $t2, 4	
loop_update_inv_r:
	mul $t3, $t0, $t2
	add $t4, $t3, $sp
	lw $t4, 0($t4)
	
	add $t5, $t3, $s1
	sw $t4, 0($t5)
	
	addi $t0, $t0, 1
	bne $t0, $t1, loop_update_inv_r
	addi $sp, $sp, 32 #### delete T array
	
	#### get the initial values back ######
	lw $ra, 0($sp)
	lw $a0, 4($sp) 
	lw $a1, 8($sp) 
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s3, 24($sp)
	lw $s4, 28($sp)
	lw $s5, 32($sp)
	lw $s6, 36($sp)
	lw $s7, 40($sp)	
	addi $sp, $sp, 44
	
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
    
    
convert:

    lb $t4, 0($t0)       # Load the current byte from the buffer
    beq $t7, 4, done     # If the current byte is null (end of string), we're done

    # Convert ASCII character to integer
    li $t5, '0'          # Load ASCII value of '0'
    li $t6, '9'          # Load ASCII value of '9'

    # Check if character is a digit
    blt $t4, $t5, check_uppercase # If less than '0', check for uppercase letters
    bgt $t4, $t6, check_uppercase # If greater than '9', check for uppercase letters
    sub $t4, $t4, $t5   # Convert '0'-'9' to 0-9
    j process_digit     # Jump to process_digit

check_uppercase:
    li $t5, 'A'          
    li $t6, 'F'
    blt $t4, $t5, check_lowercase # If less than 'A', check for lowercase letters
    bgt $t4, $t6, check_lowercase # If greater than 'F', check for lowercase letters
    sub $t4, $t4, $t5   # Convert 'A'-'F' to 10-15
    addi $t4, $t4, 10   # Adjust value for 'A'-'F'
    j process_digit     # Jump to process_digit

check_lowercase:
    li $t5, 'a'          # Load ASCII value of 'a'
    li $t6, 'f'         # Load ASCII value of 'f'
    blt $t4, $t5, exit 
    bgt $t4, $t6, exit 
    sub $t4, $t4, $t5  
    addi $t4, $t4, 10   

process_digit:
    mul $t1, $t1, $t3   
    add $t1, $t1, $t4 

    addi $t0, $t0, 1  
    addi $t7, $t7, 1
    j convert           

done:
    addi $v0, $t1, 0 
    jr $ra
   
