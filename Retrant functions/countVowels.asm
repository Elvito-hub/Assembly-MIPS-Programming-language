.data 
str : .asciiz " long time ago in a galaxy far away "
endl: .asciiz " \n"
 .globl main
 .text
main: 
la $a0,str 
 addiu $sp,$sp,-12 
 sw $a0, 0($sp)
 sw $ra, 8($sp)
 jal vcount 
 lw $ra, 8($sp) 
 lw $v0, 4($sp)
 addiu $sp, $sp, 12
move $a0,$v0 
 li $v0,1 
 syscall 
 la $a0,endl 
 li $v0,4 
 syscall 
 li $v0,10 
 syscall
 vcount:
lw $a0, 0($sp)
 addiu $sp, $sp, -24 
 sw $a0, 0($sp)
 sw $s0, 4($sp) 
 sw $s1, 8($sp)
 sw $ra, 20($sp)
 li $s0, 0 
 move $s1, $a0 
nextc: lb $a0, ($s1) 
 beqz $a0, done 
 sw $a0, 12($sp) 
 jal vowelp 
 lw $v0, 16($sp)
 add $s0, $s0, $v0 
 add $s1, $s1, 1 
 b nextc 
done: move $v0,$s0
 lw $a0, 0($sp)
 lw $s0, 4($sp)
 lw $s1, 8($sp)
 lw $ra, 20($sp)
 add $sp, $sp, 24
 sw $v0, 4($sp)
 jr $ra 
vowelp: 
lw $a0, 12($sp)
 li $v0, 0
 beq $a0, 'a', yes
 beq $a0, 'e', yes
 beq $a0, 'i', yes
 beq $a0, 'o', yes
 beq $a0, 'u', yes
 beq $a0, 'A', yes
 beq $a0, 'E', yes
 beq $a0, 'I', yes
 beq $a0, 'O', yes
 beq $a0, 'U', yes
 j ret
yes: li $v0, 1
ret: sw $v0, 16($sp)
 jr $ra