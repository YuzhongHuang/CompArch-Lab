xori $t1, $zero, 198
xori $v0, $zero, 4
sub $sp, $sp, $v0
sw $t1, 4($sp)
sw $v0, 0($sp)
lw $a0, 4($sp)
lw $a1, 0($sp)
