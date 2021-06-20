    .data
prompt: .asciiz "\nEnter a string :"
sizeOut: .asciiz "\nThe string's size is: "
palOut: .asciiz "\n Is Palindrome: "
    .globl main
    .text
main:
    li $v0,4
    la $a0,prompt
    syscall
    addi $sp,$sp,-4
    jal palindro
    lw $t0,($sp)
    la	$a0,palOut
    li	$v0,4
    syscall
    move $a0,$t0
    li $v0,1
    syscall
    addiu $sp,$sp,4
    li $v0,10
    syscall
    
    
    
palindro:
    addiu $sp,$sp,-16
    move $a0,$sp
    li $a1,16
    li $v0,8
    syscall
    addi $sp,$sp,-20
    sw $a0,0($sp)
    sw $a1,4($sp)
    li $t1,0x0a
    sw $t1,8($sp)
    sw $ra,16($sp)
    jal search
    
    lw $ra,16($sp)
    lw $t8,12($sp)
    addiu $sp,$sp,20
    
    move $t7,$sp
    add $t8,$t7,$t8
    addi $t8,$t8,-2
    li $t2,1
loop1:
    bge $t7,$t8,end
    lb $t0,($t7)
    lb $t1,($t8)
    addi $t7,$t7,1
    addi $t8,$t8,-1
    beq $t0,$t1,loop1
    li $t2,0
    
end:
    addiu $sp,$sp,16
    sw $t2,0($sp)
    jr $ra    
    
    
search:
    lw $a0,0($sp)
    move $a1,$a0
    lw $t0,4($sp)
    lw $t1,8($sp)
loop:
    lb $t2,($a0)
    addi $a0,$a0,1
    sub $v0,$a0,$a1
    beq $t2,$t1,checkaddr
    blt $v0,$t0,loop
    b ret
    
checkaddr:
    sw $v0,12($sp)
    move	$a1,$v0
    la	$a0,sizeOut
    li	$v0,4
    syscall
    move	$a0,$a1
    addi	$a0,$a0,-1
    li	$v0,1
    syscall
ret:
    jr $ra
