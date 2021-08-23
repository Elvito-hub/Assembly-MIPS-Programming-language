	.data
prompt:	.asciiz	"\nEnter The year to check: "
error1:	.asciiz "\nEmpty input,Try again :"
error2:	.asciiz "\nInvalid year,re-enter the year : "
error3:	.asciiz "\nPlz Enter a non-negative year,We count from year 1, Retry: "
monthname:	.asciiz "JanFebMarAprMayJunJulAugSepOctNovDec"
weekday:	.asciiz "SMTWTFS"
title:		.asciiz	"\n	         The Calendar of Year "
underline:	.asciiz	"\n                ___________________________"
.align	2
year:		.space 4
cal:	.space	2660
	.globl main
	.text
main:
	la	$a0,prompt
	li	$v0,4
	syscall
	jal	inputFunc
	la	$a1,year
	sw	$v0,($a1)
	jal	 calendarBuilder
	jal	printCalendar
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
	addiu	$sp,$sp,20
 	li	$v0,4
    	la	$a0,error3
    	syscall
    	b	inputFunc
ok_ret:
    	addiu 	$sp,$sp,20
    	jr 	$ra
 
 
 calendarBuilder:
 	addi	$sp,$sp,-4
 	sw	$ra,($sp)
 	la	$a1,year
 	lw	$a0,($a1)
 	jal	isLeapYear
 	move	$a1,$v0
 	jal	firstDayDetect
 	move	$a2,$v0
 	
 	#spacing all calendar
 	li	$t0,0x20
 	la	$a0,cal
 	li	$t1,0
 loopSpacing:
 	sb	$t0,($a0)
 	addi	$a0,$a0,1
 	addi	$t1,$t1,1
 	ble	$t1,2660,loopSpacing
 	#upperBorder
 	la	$a0,cal
 	li	$t0,0x5f
 	li	$t1,1
loop_UpperBorder:
	sb	$t0,($a0)
	addi	$a0,$a0,1
	addi	$t1,$t1,1
	ble	$t1,68,loop_UpperBorder
	addi	$sp,$sp,-12
	sw	$a2,4($sp)
	sw	$a1,8($sp)
	#prepare loop to call month function
	li	$a1,1
	la	$a3,monthname
moonLoop:
	jal	numberOfDaysDetect
	jal	monthFunc
	move	$a0,$v0
	blt	$a0,7,noNewLine
 	addi	$a0,$a0,-7
noNewLine:
 	addi	$a1,$a1,1
 	sw	$a0,4($sp)
 	ble	$a1,12,moonLoop
 	#set left/right borders and newline
 end:
	li	$t0,0x0a	
	li	$t3,0x7c
	la 	$t1,cal
	addi $t1,$t1,69
	li 	$t2,1
loop_dividers:
	sb 	$t0,($t1)
	addi $t2,$t2,1
	addi	$t1,$t1,1
	sb	$t3,($t1)
	addi	$t4,$t1,23
	sb	$t3,($t4)
	addi	$t4,$t1,45
	sb	$t3,($t4)
	addi $t1,$t1,67
	sb	$t3,($t1)
	addi	$t1,$t1,2
	bgt $t2,36,lowerBorder
	b	loop_dividers
	
lowerBorder:
	sb	$t0,($t1)
	addi	$t1,$t1,1
	sb	$t3,($t1)
	li	$t0,0x5f
	li	$t2,1
loop_lowerBorder:
	addi	$t1,$t1,1
	sb	$t0,($t1)
	addi	$t2,$t2,1
	ble	$t2,66,loop_lowerBorder
	addi	$t1,$t1,1
	sb	$t3,($t1)
	
	#End 
 	addi	$sp,$sp,12
 	lw	$ra,($sp)
 	addi	$sp,$sp,4
 	jr	$ra
 	
    	
    	
    	
isLeapYear:
	move	$t1,$a0
	li	$t5,4
	div	$t1,$t5
	mfhi	$t2
	li	$t5,100
	div	$t1,$t5
	mfhi	$t3
	li	$t5,400
	div	$t1,$t5
	mfhi	$t4
	bnez	$t2,notLeap
	bnez	$t3,isLeap
	bnez	$t4,notLeap
isLeap:
	li	$v0,1
	b 	ret
notLeap:
	li	$v0,0
ret:
	jr	$ra
	
	
	
firstDayDetect:
	move	$t1,$a0
	addi	$t1,$t1,-1
	li	$t2,37
	li	$t3,100
	div	$t1,$t3
	mfhi	$t3
	mflo	$t4
	srl	$t5,$t3,2
	srl	$t6,$t4,2
	mul	$t7,$t4,5
	add	$t8,$t2,$t3
	add	$t8,$t8,$t5
	add	$t8,$t8,$t6
	add	$t8,$t8,$t7
	li	$t2,7
	div	$t8,$t2
	mfhi	$v0
	bnez	$v0,sub1
	li	$v0,6
	b	retu
sub1:
	addi	$v0,$v0,-1
retu:
	jr	$ra
	

	


numberOfDaysDetect:
	beq	$a1,1,to31
	beq	$a1,3,to31
	beq	$a1,5,to31
	beq	$a1,7,to31
	beq	$a1,8,to31
	beq	$a1,10,to31
	beq	$a1,12,to31
	beq	$a1,2,CheckIfLeap
	li	$v0,30
	b 	retUrn
to31:
	li	$v0,31
	b 	retUrn
CheckIfLeap:
	lw	$t9,8($sp)
	beq	$t9,1,LeapDays
	li	$v0,28
	b 	retUrn
LeapDays:
	li	$v0,29
retUrn:
	sw	$v0,($sp)
	jr	$ra
	
	
	
monthFunc:
	la 	$a0,cal	
	addi	$a0,$a0,71
	addi	$a2,$a1,-1
	rem	$t5,$a2,3
	mul 	$t5,$t5,22
	ble 	$a1,3,col1
	ble 	$a1,6,col2	
	ble 	$a1,9,col3	
	ble 	$a1,12,col4
col1:	
	b end_add
col2:	
	addi $a0,$a0,630
	b end_add
col3:	
	addi $a0,$a0,1260
	b end_add
col4:	
	addi $a0,$a0,1890
end_add:
	add $a0,$a0,$t5
	
#Month nbr and title from a3
	li	$t0,0
montTitLoop:
	blt	$t0,12,spac1
	bgt	$t0,14,spac1
	add	$t1,$a0,$t0
	lb	$t2,($a3)
	sb	$t2,($t1)
	addi	$a3,$a3,1
	addi	$t0,$t0,1
	b 	montTitLoop
spac1:
	add	$t1,$a0,$t0
	addi	$t0,$t0,1
	bgt	$t0,23,WeekdayTit
	bne	$t0,11,montTitLoop
	addi $t0,$t0,-1
	bge $a1,10,twodigMon	
	move $t2,$a1
	addi $t2,$t2,48
	sb $t2,($t1)
	addi $t0,$t0,1
	b	montTitLoop
twodigMon:
	li 	$t3,10		
	div 	$a1,$t3
	addi 	$t1,$t1,-1
	mflo 	$t2	
	addi 	$t2,$t2,48
	sb 	$t2,($t1)
	addi $t1,$t1,1
	mfhi $t2	
	addi $t2,$t2,48
	sb 	$t2,($t1)
	addi $t0,$t0,1
	b montTitLoop
   #weekdays title
WeekdayTit:
	addi	$t0,$a0,71
	la	$t1,weekday
	li	$t3,0
loop2:	
	li 	$t2,0x20	
	sb 	$t2,($t0)
	addi 	$t0,$t0,1
	lb 	$t2,($t1)
	sb 	$t2,($t0)
	addi 	$t0,$t0,1
	addi 	$t1,$t1,1
	li 	$t2,0x20	
	sb 	$t2,($t0)
	addi $t0,$t0,1
	addi $t3,$t3,1	
	bgt 	$t3,6,printDays
	b 	loop2
printDays:
	li 	$t2,0x20	
	sb 	$t2,($t0)
	addi	$t1,$a0,141
	li	$t5,0x5f
	li	$t6,0
printHoz:
	sb	$t5,($t1)
	addi	$t6,$t6,1
	addi	$t1,$t1,1
	ble	$t6,19,printHoz
	addi	$t1,$a0,211
	lw	$a2,4($sp)
	mul	$t5,$a2,3
	add	$t1,$t1,$t5
	lw	$t6,($sp)
	li	$t0,1
datesLoop:	
	bge 	$t0,10,twodigitDay
	blt 	$a2,7,stayUp	
	addi 	$t1,$t1,-24	#jump to the following line
	addi 	$t1,$t1,73
	addi 	$a2,$a2,-7 	#print from sunday
stayUp:
	addi 	$t1,$t1,1		
	addi 	$t3,$t0,48
	sb 	$t3,($t1)
	addi 	$t1,$t1,2
	addi 	$t0,$t0,1
	addi 	$a2,$a2,1
	b 	datesLoop
twodigitDay:	
	bgt	$t0,$t6,monthEnd
	blt $a2,7,printline2	
	addi $t1,$t1,-24
	addi $t1,$t1,73
	addi $a2,$a2,-7
printline2:
	li 	$t3,10		
	div 	$t0,$t3		
	mflo $t3
	addi 	$t3,$t3,48
	sb 	$t3,($t1)
	addi $t1,$t1,1
	mfhi 	$t3
	addi 	$t3,$t3,48
	sb 	$t3,($t1)
	addi 	$t1,$t1,2
	addi 	$a2,$a2,1
	addi 	$t0,$t0,1
	b 	datesLoop
monthEnd:
	move	$v0,$a2
	jr	$ra
	
printCalendar:
 	la	$a0,title
 	li	$v0,4
 	syscall
 	la	$a1,year
 	lw	$a0,($a1)
 	li	$v0,1
 	syscall
 	la	$a0,underline
 	li	$v0,4
 	syscall
 	li	$a0,0x0a
 	li	$v0,11
 	syscall
 	la	$a0,cal
 	li	$v0,4
 	syscall
 	
 	jr	$ra
