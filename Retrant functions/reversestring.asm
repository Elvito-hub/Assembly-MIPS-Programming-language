    .data
prompt: .asciiz "\nPlease enter a string: "
result: .asciiz "\nIts reverse is :"
    .globl main
    .text
main:
    li $v0,4
    la $a0,prompt
    syscall
    jal reverseString
    li $v0,10
    syscall
    
    
reverseString:
    addiu $sp,$sp,-60
    move $a0,$sp
    li $a1,60
    li $v0,8
    syscall
    addi $t0,$a0,59
    li $v0,4
    la $a0,result
    syscall
loop:
    lb $t1,($t0)
    li $v0,11
    move $a0,$t1
    syscall
    addi $t0,$t0,-1
    bge $t0,$sp,loop
    
    jr $ra
