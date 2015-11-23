.include "ec2_data.asm"

sort:
#STACK Procedures
addi $sp, $sp, -20 #make room on stack for 5 registers
sw $ra, 16($sp) #saves $ra on stack
sw $s3, 12($sp) #saves $s3 on stack
sw $s2, 8($sp) #saves $s2 on stack
sw $s1, 4($sp) #saves $s1 on stack
sw $s0, 0($sp) #saves $s0 on stack

move $s2, $t0 #base address now in s2
move $s3, $t1 #s3=n
addi $s0, $zero, 0 #s0=counter, initialized to 0

loop1: 
slt $t0, $s0, $s3 #t0=0 if s0>=s3 (i>=n)
beq $t0, $zero, reset #resets i and j after going through the loop
addi $s1, $s0, -1 #s1=j=i-1

loop2:
slti $t0, $s1, 0 #t0=1 if s1<0 (j<0)
bne $t0, $zero, exit2 #go to exit2 if s1<0 (j<0)
sll $t1, $s1, 2 #t3=j*4
add $t2, $s2, $t1 #t3=base address+((j*4))
lw $t3, 4($t2) #t4= element j
lw $t4, 8($t2) #t5= element j+1
slt $t0, $t4, $t3 #t0=0 if t4>=t3
beq $t0, $zero, exit2 #go to exit 2 if t4>=t3
move $a0, $t2 #a0=s2=base address
#move $a1, $s1 #a1=s1=j=i-1
jal swap



exit2: #goes to outer loop
addi $s0, $s0, 1 #increments i
addi $s1, $s1, -1 #decrements j
j loop1  #jump to test outer loop


swap:
addi $t5, $zero, 0 #swap counter
lw $t3, 4($a0) #loads the appropriate things in register
lw $t4, 8($a0)

sw $t4, 4($a0) #switches and stores
sw $t3, 8($a0)
addi $t5, $t5, 1
jr $ra

reset:
beq $t5, $zero, MIDIOut #if t0=0, all elements have been sorted
addi $t5, $zero, 0 #swap counter
addi $s0, $zero, 0 #i
addi $s1, $zero, 0 #j
j loop1

MIDIOut:
addi $t0, $zero, 0 # counter
j MIDIloop

MIDIloop:
beq $t0, $s3, loop_exit
sll $t5, $t0, 2 #calculates address of i
add $t5, $s2, $t5 #adds i to base address
addi $v0, $zero, 33 # midi out synchronous
addi $a1, $zero, 250 # ms
addi $a2, $zero, 5 # some instrument-piano
addi $a3, $zero, 64 # some volume 
lw $a0, 4($t5) #loads value of i+4 into $a0
addi $a0, $a0, 60 # Middle-C
syscall #plays MIDI value in a0
addi $t0, $t0, 1 #increments loop counter
j MIDIloop 	
	
loop_exit:
#Restore Stack
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20















