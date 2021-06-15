.data
prompt: .asciiz "\n\n Please Input a value: "
result: .asciiz "\n The square root is: "
 .globl main
 .text
main: li $v0, 4 
 la $a0, prompt 
 syscall 
 li $v0, 5 
 syscall 
 li $t0,0 
 move $t1,$v0
 srl $t2,$t1,1
 addi $t2,$t2,1 
loop: bgt $t0,$t2,outj 
 add $t3,$t0,$t2 
 srl $t3,$t3,1
 mul $t4,$t3,$t3 
 beq $t4,$t1,end
 blt $t4,$t1,first
 addi $t2,$t3,-1
 b loop
first: addi $t0,$t3,1
 b loop 
outj: li $v0,4 
 la $a0,result 
 syscall 
 move $a0,$t2
 li $v0,1
 syscall 
 b exit 
end: li $v0,4 
 la $a0,result 
 syscall 
 move $a0,$t3
 li $v0,1
 syscall 
exit: li $v0,10 
 syscall