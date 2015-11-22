xori $t1, $zero, 198
xori $ra, $zero, 908
xori $v0, $zero, 8
sub $sp, $sp, $v0
sw $t1, 4($sp)
sw $ra, 0($sp)
lw $t2, 4($sp)
lw $t3, 0($sp)
add $sp, $sp, $v0

