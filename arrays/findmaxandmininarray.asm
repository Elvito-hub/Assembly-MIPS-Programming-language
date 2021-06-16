.data 
array: .word 100,-10,0,23,35,-67,90,10,65,-87
maxMes: .asciiz "The maximum elt is:"
minMes: .asciiz " \nThe minimum elt is:"
 .globl main 
 .text 
main: la $t0, array # *a=array
 lw $t1, ($t0) # max=a[0]
 move $t2, $t1 # min=max
 li $t3, 1 # i=1
 li $t4, 10 # N=10
 addi $t0, $t0, 4 # a++
loop: lw $t5, ($t0) # $t5=*a
 bge $t1, $t5, minck # if(max>=*a) goto minck 
 move $t1, $t5 # max=*a
minck: ble $t2, $t5, next # if (min<=*a) goto next
 move $t2, $t5 # min=*a
next: addi $t0, $t0, 4 # a++
 addi $t3, $t3, 1 # i++ 
 blt $t3, $t4, loop # if (i<N) Branch to loop 
 
 li $v0,4
 la $a0,maxMes
 syscall
 li $v0,1
 move $a0,$t1
 syscall
 
 li $v0,4
 la $a0,minMes
 syscall
 li $v0,1
 move $a0,$t2
 syscall
 
 li $v0, 10 # terminate program run and 
 syscall # return control to system