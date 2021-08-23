                                            
       .data
prompt:	.asciiz "\nInput N : "
error1: .asciiz "\nEmpty input,Try again :"
error2: .asciiz "\nInvalid number?Try again : "
largeinputerror: .asciiz "\nThe value should be less than 47 Enter a 0-46 value :"
error3: .asciiz "\nEnter a 0-46 value:"
tab: .asciiz "\t"
.align 2
store:		.space 188
    .globl main
    .text
main:
	la	$a0,prompt
    	li	$v0,4
    	syscall
    	addiu	$sp,$sp,-4
    	jal	inputFunc
	jal	calculateFibo
	addi 	$sp,$sp,4
	
	jal	printFibo
	li 	$v0,10
    	syscall   

    
    
inputFunc:
	addiu	$sp,$sp,-20
    	move	$a0,$sp
	li	$a1,20
	li	$v0,8
    	syscall
    
    	li	$t4,0x20
    	li	$t5,0x0a
    	li 	$t6,0x2d
    	li 	$t1,0 
    	li 	$t2,0
do_space1:
    	lb 	$t0,($a0)
    	beqz 	$t0,out_2
    	addi 	$a0,$a0,1
    	beq 	$t0,$t4,do_space1
    	beq 	$t0,$t5,out_2
    	bne 	$t0,$t6,do_valid
    	li 	$t1,1
    	lb 	$t0,($a0)
    	addi	$a0,$a0,1
do_valid:
   	li 	$t6,0x30
    	li 	$t7,0x39
    	li 	$v0,0
    	li 	$t3,10
loop:
    	beq 	$t0,$t4,do_space2
    	beqz 	$t0,out_1
    	beq 	$t0,$t5,out_1
    	blt 	$t0,$t6,out_3
    	bgt 	$t0,$t7,out_3
    	addi 	$t2,$t2,1
    	mulo 	$v0,$v0,$t3
    	addi 	$t0,$t0,-0x30
    	add 	$v0,$v0,$t0
    	lb 	$t0,($a0)
    	addi 	$a0,$a0,1
    	b 	loop
check_length:
    	beqz 	$t2,out_2
do_space2:
  	lb 	$t0,($a0)
  	addi 	$a0,$a0,1
    	beqz 	$t0,out_1
    	beq 	$t0,$t5,out_1
    	beq 	$t0,$t4,do_space2
    	b 	out_3
out_1:
 	bnez 	$t1,negativenbr
    	bge 	$v0,47,largenbr
    	bltz 	$v0,negativenbr
    	b 	ret
largenbr:
    	li 	$v0,4
    	la 	$a0,largeinputerror
    	syscall
    	b 	inputFunc
negativenbr:
    	li 	$v0,4
    	la 	$a0,error3
    	syscall
    	b 	inputFunc
out_2:
    	addiu 	$sp,$sp,20
    	li 	$v0,4
    	la 	$a0,error1
    	syscall
    	b 	inputFunc
out_3:
    	addiu 	$sp,$sp,20
    	li 	$v0,4
    	la 	$a0,error2
    	syscall
    	b 	inputFunc
ret:
    	addiu 	$sp,$sp,20
    	sw 	$v0,($sp)
    	jr 	$ra
    
    
    
calculateFibo:
    	lw 	$a0,0($sp)
    	addi	$sp,$sp,-4
    	sw	$ra,0($sp)
    	li 	$t0,0
    	move 	$t1,$a0
    	la 	$a1,store
    	move 	$a2,$a1
generate:
    	jal 	Fibogenerate
    	move 	$a0,$v0
    	sw 	$a0,($a2)
    	addi 	$a2,$a2,4
    	addi 	$t0,$t0,1
    	ble 	$t0,$t1,generate
    	
    	lw	$ra,0($sp)
    	addi	$sp,$sp,4
    	jr	$ra

    
Fibogenerate:
        #load from store
	sll 	$t3,$t0,2
    	la 	$t4,store
    	add 	$t4,$t4,$t3
    	lw 	$t5,($t4)
    	bnez 	$t5,LoadFromStore
    	
    	
    	beqz 	$t0,retn
    	beq 	$t0,1,retn
	    #call for n-1
        
    	addiu 	$sp,$sp,-4
    	sw 	$ra,0($sp)
    
    	addi 	$t0,$t0,-1
    	jal 	Fibogenerate
    	addi 	$t0,$t0,1
    	lw 	$ra,0($sp)
    	addiu 	$sp,$sp,4
    
    	addiu 	$sp,$sp,-4
    	sw 	$v0,0($sp)
    
    #call for n-2    
    
    
    	addiu 	$sp,$sp,-4
    	sw 	$ra,0($sp)
    
    	addi 	$t0,$t0,-2
    	jal 	Fibogenerate
    	addi 	$t0,$t0,2
    
    	lw 	$ra,0($sp)
    	addi 	$sp,$sp,4
    	lw 	$v1,0($sp)
    	addi 	$sp,$sp,4
    
    	add 	$v0,$v0,$v1
    	jr 	$ra
LoadFromStore:
    	move 	$v0,$t5
    	jr 	$ra
retn:
    	move 	$v0,$t0
    	jr 	$ra
    	
    	
    	
printFibo:
    	li 	$t0,0
   	la	$a2,store
print:
    	lw 	$a0,($a2)
    	li 	$v0,1
    	syscall
    	la 	$a0,tab
    	li 	$v0,4
    	syscall
    	addi 	$a2,$a2,4
    	addi 	$t0,$t0,1
    	ble 	$t0,$t1,print
    	
    	jr	$ra
    
