.data

array: .word 3, 34, 4, 12, 5, 2, 0 # final 0 indicates the end of the array; 0 is excluded; it should return TRUE for this array
sum: .word 29

true: .asciiz "TRUE\n"
false: .asciiz "FALSE\n"
default: .asciiz "This is just a template. It always returns "

.text

main:
      la $a0, array 	# $a0 has the address of the array "arr"
      lw $a1, sum   	# $a1 has the "sum"
      
      jal lenArray  	# Find the lenght of the array
      
      move $a2, $v0  	# $a2 has the length of the array, "n"
        
      jal subsetSum

      bne $v0, 0,  yes
      la  $a0, false
      li $v0, 4
      syscall
      j exit

yes:  la    $a0, true
      li $v0, 4
      syscall

exit:
      li $v0, 10
      syscall


subsetSum:
###############################################
#   Your code goes here
###############################################
      li $v0, 0
      addi $sp, $sp, -16
      sw $ra,0($sp)
      sw $a0,4($sp)
      sw $a1,8($sp)
      sw $a2,12($sp)
 
      beq $a2, $zero, end

left:
      addi $a2, $a2, -1 
      jal subsetSum

      beq  $v0, 1, end
      beq  $a1, $zero, sol

right: 
      add $t0, $a2, $a2
      add $t0, $t0, $t0
      add $t0, $t0, $a0
      lw $t1, 0($t0)
      sub $a1, $a1, $t1
      jal subsetSum

      beq  $v0, 1, end
      beq  $a1, $zero, sol
      j end 

sol:
      li $v0, 1 
end:
      lw $ra,0($sp)
      lw $a0,4($sp)
      lw $a1,8($sp)
      lw $a2,12($sp)
      addi $sp, $sp, 16
      jr $ra	

lenArray:       #Fn returns the number of elements in an array
      addi $sp, $sp, -8
      sw $ra,0($sp)
      sw $a0,4($sp)
      li $t1, 0

laWhile:       
      lw $t2, 0($a0)
      beq $t2, $0, endLaWh
      addi $t1,$t1,1
      addi $a0, $a0, 4
      j laWhile

endLaWh:
      move $v0, $t1
      lw $ra, 0($sp)
      lw $a0, 4($sp)
      addi $sp, $sp, 8
      jr $ra
