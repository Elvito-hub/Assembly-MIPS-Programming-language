.data
prompt: .asciiz "\n\n Please input a value: "
result: .ascii "\n The dec is: " 
buf: .space 13 
 .text
main: li $v0, 4
 la $a0, prompt
 syscall 
 li $v0, 5
 syscall 
 move $t0, $v0 
 la $t1, buf
 li $t2, 11
 sb $0,12($t1)
 li $t8,0x20
space: add $t9,$t1,$t2
 sb $t8,($t9)
 addi $t2,$t2,-1 
 bgez $t2,space
abs $t3,$t0
li $t2, 11 
 li $t9,10
 add $t1, $t1, $t2
loop: div $t3,$t9 
 mflo $t3 
 mfhi $t4
 addi $t4,$t4,0x30 
sb $t4,($t1)
 addi $t1, $t1, -1 
 beqz $t3,sign 
 b loop
sign: bgez $t0,exit
 li $t8,0x2d
 sb $t8,($t1)
exit: li $v0, 4
 la $a0, result
 syscall 
 li $v0, 10
 syscall