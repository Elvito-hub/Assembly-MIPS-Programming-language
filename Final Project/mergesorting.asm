	.data
prompt1:	.asciiz  "\nEnter the size of array : "
prompt2:	.asciiz "\nEnter the values : "
error1: 	.asciiz "\nEmpty input,Try again :"
error2: 	.asciiz "\nInvalid number,re-enter the value : "
output1: 	.asciiz "\nBefore Sorting : "
output2: 	.asciiz "\nAfter Sorting : "
tab:		.asciiz "\t"
	.text
main:
	la	$a0,prompt1
	li	$v0,4
	syscall
	addi	$sp,$sp,-4
	jal	inputFunc
	lw	$t2,($sp)
	addi	$sp,$sp,4
	sll	$t3,$t2,2
	sub	$sp,$sp,$t3
	
	la	$a0,prompt2
	li	$v0,4
	syscall
	
	li	$t0,0
inputLoop:
	addi	$sp,$sp,-12
	sw	$t0,4($sp)
	sw	$t2,8($sp)
	jal	inputFunc
	lw	$a0,($sp)
	lw	$t0,4($sp)
	lw	$t2,8($sp)
	addi	$sp,$sp,12

	sll	$t4,$t0,2
	add	$t4,$sp,$t4
	sw	$a0,($t4)
	addi	$t0,$t0,1
	blt	$t0,$t2,inputLoop
	
	move	$t0,$sp
	li	$t1,0
	addi	$t2,$t2,-1
	addi	$sp,$sp,-12
	sw	$t0,0($sp)
	sw	$t1,4($sp)
	sw	$t2,8($sp)
	la	$a0,output1
	li	$v0,4
	syscall
	jal	PrintArray
	jal	mergeSort
	
	la	$a0,output2
	li	$v0,4
	syscall
	jal	PrintArray
	addi	$sp,$sp,12
	li	$v0,10
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
    	bltz 	$v0,negativenbr
    	b 	ok_ret


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
negativenbr:
	neg	$v0,$v0
ok_ret:
    	addiu 	$sp,$sp,20
    	sw 	$v0,($sp)
    	jr 	$ra
	
	
	
	
	
	
	
	
	
mergeSort:
	lw	$t0,0($sp)
	lw	$t1,4($sp)
	lw	$t2,8($sp)
	bge	$t1,$t2,ret
	sub	$t4,$t2,$t1
	srl	$t4,$t4,1
	add	$t4,$t4,$t1
	
	#call for part 1
	addi	$sp,$sp,-20
	sw	$t0,0($sp)
	sw	$t1,4($sp)
	sw	$t4,8($sp)
	sw	$t2,12($sp)
	sw	$ra,16($sp)
	jal	mergeSort
	
	lw	$ra,16($sp)
	lw	$t1,4($sp)
	lw	$t4,8($sp)
	lw	$t2,12($sp)
	addi	$sp,$sp,20

	addi	$sp,$sp,-8
	sw	$t1,0($sp)
	sw	$t4,4($sp)
	
	#call for part 2
	addi	$t5,$t4,1
	addi	$sp,$sp,-16
	sw	$t0,0($sp)
	sw	$t5,4($sp)
	sw	$t2,8($sp)
	sw	$ra,12($sp)
	jal	mergeSort
	
	lw	$ra,12($sp)
	lw	$t0,0($sp)
	lw	$t2,8($sp)
	addi	$sp,$sp,16
	
	lw	$t1,0($sp)
	lw	$t4,4($sp)
	addi	$sp,$sp,8
	
	addi	$sp,$sp,-20
	sw	$t0,0($sp)
	sw	$t1,4($sp)
	sw	$t4,8($sp)
	sw	$t2,12($sp)
	sw	$ra,16($sp)
	jal	merge
	lw	$t1,4($sp)
	lw	$t4,8($sp)
	lw	$t2,12($sp)
	lw	$ra,16($sp)
	addi	$sp,$sp,20
ret:	jr	$ra


merge:
	lw	$t0,0($sp)
	lw	$t1,4($sp)
	lw	$t4,8($sp)
	lw	$t2,12($sp)
	
	sub	$t6,$t4,$t1
	addi	$t6,$t6,1   #size of Left array n1
	
	sub	$t7,$t2,$t4  #size of right array n2
	
	add	$t8,$t6,$t7
	sll	$t8,$t8,2
	addi	$sp,$sp,-4
	sw	$fp,($sp)
	sub	$sp,$sp,$t8
	#store the left array
	li	$s0,1				#we will count from 1, after fp which is at 0
loop1:
	addi	$s0,$s0,-1			#load from array (it must be from 0 index)
	add	$s1,$t1,$s0
	sll	$s1,$s1,2
	add	$t5,$t0,$s1
	lw	$s2,($t5)
	
	addi	$s0,$s0,1			#bounce back to from fp 0
	sll	$s3,$s0,2
	sub	$s3,$fp,$s3
	sw	$s2,($s3)
	
	addi	$s0,$s0,1
	ble	$s0,$t6,loop1
	
	li	$s0,1
loop2:
	addi	$s0,$s0,-1				#load from array (it must be from 0 index)
	addi	$s1,$t4,1
	add	$s1,$s1,$s0
	sll	$s1,$s1,2
	add	$t5,$t0,$s1
	lw	$s2,($t5)
	
	addi	$s0,$s0,1				#bounce back to from fp 0
	sll	$s3,$s0,2
	sll	$s4,$t6,2
	add	$s3,$s3,$s4
	sub	$s3,$fp,$s3
	
	sw	$s2,($s3)
	addi	$s0,$s0,1
	ble	$s0,$t7,loop2
	
	li	$s0,1   #Initial index of first subarray i
	li	$s1,1 #Initial index of second subarray j
	move	$s2,$t1 #Initial index of merged subarray k
	
	
#while(i<n1&&j<n2)
whileLoop:
	bgt	$s0,$t6,copyRemLeft
	bgt	$s1,$t7,copyRemLeft
	
	#load left L[i] 
	sll	$s3,$s0,2
	sub	$s3,$fp,$s3
	lw	$s4,($s3)
	
	#Load right R[j]
	sll	$s3,$s1,2
	sll	$s6,$t6,2
	add	$s3,$s3,$s6
	sub	$s3,$fp,$s3
	lw	$s5,($s3)
	
	
	#load arr[k]
	sll	$s7,$s2,2
	add	$s7,$t0,$s7
	#compare L[i] and R[j] and store in array
	bgt	$s4,$s5,RightLess
	sw	$s4,($s7)
	addi	$s0,$s0,1
	b	next
RightLess:
	sw	$s5,($s7)
	addi	$s1,$s1,1
next:
	addi	$s2,$s2,1
	b	whileLoop
	
	#CopyRemainig elements if any
copyRemLeft:
	bgt	$s0,$t6,copyRemRight
	#load left L[i] 
	sll	$s3,$s0,2
	sub	$s3,$fp,$s3
	lw	$s4,($s3)
	#store it in arr[k]
	sll	$s7,$s2,2
	add	$s7,$t0,$s7
	sw	$s4,($s7)
	addi	$s0,$s0,1
	addi	$s2,$s2,1
	b	copyRemLeft
copyRemRight:
	bgt	$s1,$t7,retr
	#load right R[j]
	sll	$s3,$s1,2
	sll	$s6,$t6,2
	add	$s3,$s3,$s6
	sub	$s3,$fp,$s3
	lw	$s5,($s3)
	#store it in arr[k]
	sll	$s7,$s2,2
	add	$s7,$t0,$s7
	sw	$s5,($s7)
	addi	$s1,$s1,1
	addi	$s2,$s2,1
	b	copyRemRight

retr:
	add	$sp,$sp,$t8	
	addi	$sp,$sp,4
	jr	$ra
	
	
	
PrintArray:
	lw	$a1,0($sp)
	lw	$a2,8($sp)
	li	$t0,0
Printloop:
	sll	$t1,$t0,2
	add	$t1,$a1,$t1
	lw	$a0,($t1)
	li	$v0,1
	syscall
	la	$a0,tab
	li	$v0,4
	syscall
	addi	$t0,$t0,1
	ble	$t0,$a2,Printloop
finishPrint:
	jr	$ra
	
	
	
	
	
	
