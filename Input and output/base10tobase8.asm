.data
buf: .space 12
 .globl main 
 .text
main: 
li $v0,5
syscall
move $a1,$v0
 li $t1, 8 
 li $t2, 1 
 la $a0, buf 
 addi $t0, $a0, 11  
 sb $0, ($t0)  
loop: 
div $a1, $t1
 mflo $a1 
 mfhi $t3 
 addi $t3, $t3, 0x30 
 addi $t0, $t0, -1 
 sb $t3, ($t0) 
 beqz $a1, out 
 addi $t2, $t2, 1 
 b loop 
out: 
 addi $a0, $a0,10
 sub $a0, $a0, $t2
 li $t4, 0x20 
 sb $t4, ($a0) 
 li $v0, 4 
 syscall 
 li $v0, 10 
 syscall 
