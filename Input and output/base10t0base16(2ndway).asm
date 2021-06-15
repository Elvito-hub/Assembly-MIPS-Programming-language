.data
prompt: .asciiz "\n\n Please input a value: "
result: .ascii "\n The hex is: " 
buf: .space 12 
 .text
main: li $v0, 4 
 la $a0, prompt 
 syscall 
 li $v0, 5 
 syscall 
 move $t0, $v0 
 la $t1, buf 
 li $t2, 8 
 addi $t3, $t1, 10 
loop: blez $t2, end 
 andi $t4, $t0, 0x0f 
 srl $t0, $t0, 4 
 bge $t4, 10, char 
 addi $t4, $t4, 0x30 
 b put
char: addi $t4, $t4, 0x37 
put: sb $t4, ($t3) 
 addi $t3, $t3, -1 
 addi $t2, $t2, -1 
 b loop 
end: sb $0, 11($t1) 
 li $t0, 0x78
 sb $t0, 2($t1) 
 li $t0, 0x30
 sb $t0, 1($t1) 
 li $t0, 0x20
 sb $t0, ($t1) 
li $v0, 4
la $a0, result
syscall 
li $v0, 10
 syscall