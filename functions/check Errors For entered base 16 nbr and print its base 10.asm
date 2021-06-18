.data
prompt: .asciiz "\n Please input a hex value: "
result: .ascii "\n The hex value is: "
buf: .space 20
result0: .asciiz " The dec value is: " 
mess0: .asciiz " \n Correct input "
mess1: .asciiz " \n Error: Not start with 0x "
mess2: .asciiz " \n Error: Invalid number " 
mess3: .asciiz " \n Error: The length is great than 8 "
.text
main: li $v0,4
 la $a0, prompt
 syscall 
 la $a0,buf
 li $a1,20
 li $v0,8
 syscall 
 jal Hexin 
 li $v0,10
syscall

Hexin: li $t1,0x20
do_space: 
 lb $t2,($a0) 
 bne $t2,$t1,do_0x 
 addi $a0,$a0,1
 b do_space 
do_0x: li $t1,0x30 
 bne $t2,$t1,out_e1 
 li $t1,0x78
 addi $a0,$a0,1 
 lb $t2,($a0)
 bne $t2,$t1,out_e1 
li $t0,0 
 li $t3,0 
do_valid: addi $a0,$a0,1 
 lb $t2,($a0)
 li $t1,0x0a
 beq $t2,$t1,do_length
li $t1,0x20
 beq $t2,$t1,do_space2
 li $t1,0x30 
 blt $t2,$t1,out_e2 
 li $t1,0x39 
 ble $t2,$t1,do_dascii
li $t1,0x41 
 blt $t2,$t1,out_e2 
 li $t1,0x46 
 ble $t2,$t1,do_ucascii 
 li $t1,0x61 
 blt $t2,$t1,out_e2 
 li $t1,0x66 
 ble $t2,$t1,do_lcascii
 b out_e2 
do_dascii: 
 li $t1,0x30 
 sub $t4,$t2,$t1 
 b do_incre
do_ucascii: 
 li $t1,0x37 
 sub $t4,$t2,$t1 
 b do_incre 
do_lcascii: 
 li $t1,0x57 
 sub $t4,$t2,$t1 
 
 do_incre: 
 addi $t0,$t0,1 
 sll $t3,$t3,4 
 add $t3,$t3,$t4 
 b do_valid 
do_length: 
 li $t1,8 
 bgt $t0,$t1,out_e3 
 b out_value 
do_space2:
 addi $a0, $a0, 1
lb $t2, ($a0)
 beqz $t2, do_length 
 li $t1,0x0a
 beq $t2, $t1, do_length 
 li $t1,0x20
 beq $t2, $t1, do_space2 
 b out_e2 
out_e1: li $v0, 4
 la $a0,mess1
 syscall 
 b out_r 
out_e2: li $v0, 4
 la $a0,mess2
 syscall 
 b out_r 
out_e3: li $v0, 4
 la $a0,mess3
 syscall 
 b out_r
out_value:
 li $v0, 4
 la $a0,mess0
 syscall 
 li $v0, 4
 la $a0,result
 syscall 
 li $v0, 4
 la $a0,result0
 syscall 
 move $a0,$t3
 li $v0,1
 syscall 
out_r: jr $ra 
