xori $t1, $zero, 198
xori $v0, $zero, 8
bne $zero, $v0, END

FIRST:
#xori $ra, $zero, 7
sub $v1, $sp, $v0
jr $ra
add $t3, $v1, $t1
add $t4, $v1, $t1
xori $t5, $zero, 205

END:
sub $s1, $t1, $v0
