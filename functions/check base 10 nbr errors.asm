.data
prompt: .asciiz "\n Please input a dec value: "
result: .ascii "\n The value is: "
buffer: .space 20 
endl: .asciiz "\n"
 .text
main: li $v0,4
 la $a0, prompt
 syscall 
 jal Decin 
 move $t0, $v0 
 li $v0,4
 la $a0, result
 syscall 
li $v0,4
 la $a0, endl 
 syscall 
 move $a0, $t0
 li $v0, 1 
 syscall 
 li $v0,4
 la $a0, endl 
 syscall 
 move $a0, $v1 
 li $v0, 1
 syscall 
 li $v0, 10
 syscall
 
 Decin: la $a0, buffer 
 li $a1, 20 
 li $v0, 8 
 syscall 
 li $t4, 0x20 
 li $t5, 0x0a
 li $t6, 0x2d 
 li $t1, 0 
 
 do_space1: 
 lb $t0, ($a0)
 beqz $t0, out_1 
 addi $a0, $a0, 1 
 beq $t0, $t4, do_space1 
 beq $t0, $t5, out_1 
bne $t0, $t6, do_valid 
li $t1, 1 
lb $t0, ($a0)
 addi $a0, $a0, 1 
do_valid: 
li $t6, 0x30 
 li $t7, 0x39 
 li $v0, 0
 li $t3, 10 
loop: 
beq $t0, $t4, do_space2 
 beqz $t0, out_3 
 beq $t0, $t5, out_3 
 blt $t0, $t6, out_2 
 bgt $t0, $t7, out_2 
 mulo $v0, $v0, $t3 
 addi $t0, $t0, -48
 add $v0, $v0, $t0 
 lb $t0, ($a0) 
 addi $a0, $a0, 1
 b loop
do_space2: 
 lb $t0, ($a0)
 addi $a0, $a0, 1
 beqz $t0, out_3 
 beq $t0, $t5, out_3 
 beq $t0, $t4, do_space2 
 b out_2 
out_1: li $v1, 2 
 li $v0,0
 b ret 
out_2: li $v1, 3 
 li $v0,0
 b ret 
out_3: li $v1, 1 
 beqz $t1, ret 
 neg $v0, $v0
ret: jr $ra 