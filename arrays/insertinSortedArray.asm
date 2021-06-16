.data 
 .word -1 
array: .word 4,8,24,28,35,62,67,78,90,96
 .space 8 
x: .word 31
 .globl main 
 .text 
main: la $t0, array 
 addi $t0, $t0, 36 # $t0 point to last unit of array
 la $t1, x 
 lw $t2, ($t1) # $t2=x ( lw $t2, x($0) )
again: lw $t3, ($t0) # $t3=k 
 ble $t3, $t2, insert # compare k to x?if k<=x,insert 
 sw $t3, 4($t0) # current unit move back 1 unit
 addi $t0, $t0, -4 # $t0 point to previous unit
 b again # next unit 
insert: sw $t2, 4($t0) # $t2 insert to array
 li $v0, 10 # terminate program run and 
 syscall # return control to system
