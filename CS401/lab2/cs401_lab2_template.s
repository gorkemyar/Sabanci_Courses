##
## template for your assembly programs
##
##

#################################################
#					 	#
#		text segment			#
#						#
#################################################

	.text		
       .globl __start 
__start:		# execution starts here

	
	# say hello
	la $a0,starting
	li $v0,4
	syscall
	
	######################
	# Printing out the largest double-precision floating-point number in IEEE 754
	l.d $f0, Largest_Norm_Double
	
	# Print Largest Number
	mov.d $f12, $f0
	li $v0, 3
	syscall
	
	# print carriage return (i.e., enter)
	la $a0,cr
	li $v0,4
	syscall
	
	######################
	######################
	# Question 1
	# put the smallest double-precision normalized number in $f2; the code below will print it out
	
	move $t0, $zero # lower
	move $t1, $zero # upper 
	#exponent
	ori $t1, $t1, 0x00100000
	mtc1 $t0, $f2
	mtc1 $t1, $f3
	
	# Print Smallest Normalized Number
	mov.d $f12, $f2
	li $v0, 3
	syscall
	
	# print carriage return (i.e., enter)
	la $a0,cr
	li $v0,4
	syscall
	
	######################
	######################
	# Question 2
	# put the result in $f8; the code below will print it out
	
	### Biggest Number
	move $t0, $zero # lower
	move $t1, $zero # upper
	#exponent
	ori $t1, $t1, 0x7FE00000
	#significand
	ori $t1, $t1, 0x000FFFFF
	ori $t0, $t0, 0xFFFFFFFF
	mtc1 $t0, $f8
	mtc1 $t1, $f9
	
	### 1.5
	move $t0, $zero # lower
	move $t1, $zero # upper
	#exponent
	ori $t1, $t1, 0x3FF00000
	#significand
	ori $t1, $t1, 0x00080000
	mtc1 $t0, $f2
	mtc1 $t1, $f3
	
	mul.d $f8, $f8, $f2
	
	# Print Larger than Largest
	mov.d $f12, $f8
	li $v0, 3
	syscall
	
	# print carriage return (i.e., enter)
	la $a0,cr
	li $v0,4
	syscall
	
	######################
	# Question 3
	# put the result in $f10; the code below will print it out
	
	### Smallest Number
	move $t0, $zero # lower
	move $t1, $zero # upper
	#exponent
	ori $t1, $t1, 0x00100000
	mtc1 $t0, $f10
	mtc1 $t1, $f11
	
	### 2.0
	move $t0, $zero # lower
	move $t1, $zero # upper
	#exponent
	ori $t1, $t1, 0x40000000
	mtc1 $t0, $f2
	mtc1 $t1, $f3
	
	div.d $f10, $f10, $f2
	
	# print Smaller than Smallest
	mov.d $f12, $f10
	li $v0, 3
	syscall
	
	# print carriage return (i.e., enter)
	la $a0,cr
	li $v0,4
	syscall

	#############################
	# Question 4
	# put the result in $f10; the code below will print it out
	
	### Smallest Normalized Number + minimum amount
	move $t0, $zero # lower
	move $t1, $zero # upper
	#exponent
	ori $t0, $t0, 0x0000001
	ori $t1, $t1, 0x0010000
	mtc1 $t0, $f10
	mtc1 $t1, $f11
	### Smallest Normalized Number 
	move $t0, $zero # lower
	move $t1, $zero # upper
	#exponent
	ori $t0, $t0, 0x0000000
	ori $t1, $t1, 0x0010000
	mtc1 $t0, $f2
	mtc1 $t1, $f3
	
	sub.d $f10, $f10, $f2
	
	
	# Print Smallest Denormalized Number
	mov.d $f12, $f10
	li $v0, 3
	syscall
	
	# print carriage return (i.e., enter)
	la $a0,cr
	li $v0,4
	syscall						
	
	#############################
	# Question 5	
	# load the fp number in a fp register (just for printing)
	l.d $f0, X
	
	# print X
	mov.d $f12, $f0
	li $v0, 3
	syscall
	
	# print carriage return (i.e., enter)
	la $a0,cr
	li $v0,4
	syscall

	# load the fp number in an integer register $t0 and $t1 (the operations must be performed on $t0 and $t1)
	mfc1 $t0, $f0
	mfc1 $t1, $f1
	
	#########
	# Write your program here; you need to work on $t0 and $t1
	#########
	
	move $t2, $zero
	ori $t2, $t2, 0x80000000
	move $s0, $zero
	sltu $s0, $t2, $t1 # if negative t3 is 1
	
	andi $t1, 0x7FFFFFFF # make sign bit 0 firstly

	move $t2, $zero
	ori $t2, $t2, 0x00300000
	slt $t4, $t1, $t2 # check whether the exponent smaller than 3
	beq $t4, $zero, exponent_bigger_equal_3
	
	move $t2, $zero
	ori $t2, $t2, 0x00200000
	slt $t4, $t1, $t2 # check whether the exponent smaller than 2
	beq $t4, $zero, exponent_equal_2
	
	move $t2, $zero
	ori $t2, $t2, 0x00100000
	slt $t4, $t1, $t2 # check whether the exponent smaller than 1
	beq $t4, $zero, exponent_equal_1
	j exponent_equal_0
	
exponent_bigger_equal_3:
	subi $t1, $t1, 0x00200000
	j sign	
exponent_equal_2:
	andi $t6, $t1, 0x00000001 # get last bit
	andi $t1, $t1, 0x000FFFFF # destroy the exponent
	srl $t1, $t1, 1
	ori $t1, $t1,  0x00080000
	
	sll $t6, $t6, 31 # shift it for the t0
	srl $t0, $t0, 1
	or $t0, $t0, $t6
	j sign

exponent_equal_1:
	andi $t6, $t1, 0x00000003 # get last two bits
	andi $t1, $t1, 0x000FFFFF
	srl $t1, $t1, 2
	ori $t1, $t1, 0x00040000
	
	sll $t6, $t6, 30 # shift it for the t0
	srl $t0, $t0, 2
	or $t0, $t0, $t6
	j sign

exponent_equal_0:
	andi $t6, $t1, 0x00000003 # get last two bits
	andi $t1, $t1, 0x000FFFFF
	srl $t1, $t1, 2
	
	sll $t6, $t6, 30 # shift it for the t0
	srl $t0, $t0, 2
	or $t0, $t0, $t6
	j sign

sign:
	bne $s0, $zero, result
	ori $t1, 0x80000000 
result:
	mtc1 $t0, $f0
	mtc1 $t1, $f1	

	# store the $f0 result in memory
	# print X/(-4)
	mov.d $f12, $f0
	li $v0, 3
	syscall
	
	
	#######################
	#######################
	# say good bye
	la $a0,endl
	li $v0,4
	syscall

	# exit call
	li $v0,10
	syscall		# au revoir...


#################################################
#					 	#
#     	 	data segment			#
#						#
#################################################

	.data
starting:	.asciiz "\n\nProgram Starts Here ...\n\n"
endl:	.asciiz "\n\nexiting ..."
cr: .asciiz "\n\n"
Largest: .float 340282346638528859811704183484516925440
Smallest_Norm: .float 1.1754943508222875079687365372222456778186655567720875215087517062784172594547271728515625E-38
Largest_Norm_Double: .double 179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368
#X: .double 10.00
X: .double 1.0E-308

##
## end of file
