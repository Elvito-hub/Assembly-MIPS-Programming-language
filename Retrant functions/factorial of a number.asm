.data 
prompt: .asciiz " \n\n Input 'N' : "
result: .asciiz " N factorial is : "
bye: .asciiz " \n ### Bye ### "
msg: .asciiz "Number is too big. "
 .text 
main: 
# ??????
addiu $sp, $sp, -8 
loop: li $v0, 4
 la $a0, prompt
 syscall 
 li $v0, 5 # ??? N
 syscall 
 bltz $v0, exit
 li $t0,13
 bge $v0,$t0, enter 
 sw $v0, 0($sp)
jal fac 
 li $v0, 4
 la $a0, result
 syscall 
 lw $a0, 4($sp)
 li $v0, 1
 syscall 
 b loop
enter: li $v0, 4
 la $a0, msg 
 syscall 
 b loop
exit: addiu $sp, $sp, 8 
 li $v0, 4
 la $a0, bye
 syscall 
 li $v0, 10
 syscall 
 
 fac: 
 lw $a0, 0($sp) 
 bltz $a0, out_e 
 addiu $sp, $sp, -16 
 sw $ra, 12 ($sp )
 sw $a0, 8($sp)  
 slti $t0, $a0, 2 
 beqz $t0, go
 li $v0, 1
 b ret
go: 
addi $a0, $a0, -1 
 sw $a0, 0($sp)
 jal fac 
 lw $v0, 4 ($sp)
 lw $ra, 12 ($sp) 
 lw $a0, 8 ($sp) 
 mult $v0, $a0 
 mflo $v0
ret : 
addiu $sp, $sp, 16 
 sw $v0, 4 ($sp)
 jr $ra 
out_e:
 sw $0, 4 ($sp)
 jr $ra 