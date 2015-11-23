.data
.word 4
.word 7
.word 9
.word 1
.word 3
.text

addi $t0, $zero, 0x10010000
lw $t1, 0($t0)
lw $t2, 4($t0)

.data
.float 5.125
.text
