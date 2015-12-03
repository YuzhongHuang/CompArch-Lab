# Selina, Yuzhong, Hieu

xori $a0, $zero, 4 # Set a0
xori $a1, $zero, 8 # Set a1
add $v1, $a0, $a1 #random result. Should be 7
slt $v0, $a0, $v1 #random result. Should be 1

jal FIRST_STEP # Jumps to 9
j END # Jumps to 21
	
NEXT_STEP:
	lw $t1, 4($sp) # Loading data saved to stack
	lw $ra, 0($sp)
	add $sp, $sp, $a1
	jr $ra #Jumps to end of line 6
	
FIRST_STEP:
	sub $sp, $sp, $a1 # Move stack pointer to add new data
	sw $a1, 4($sp)
	sw $ra, 0($sp) # Actual target address of JAL
	bne $a0, $a1, NEXT_STEP # a0 and a1 should not be the same (6 and 8). Branches to 15
	
xori $t7, $zero, 208	
	
END: 
