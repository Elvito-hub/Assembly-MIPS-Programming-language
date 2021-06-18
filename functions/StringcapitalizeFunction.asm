.data 
str:.space 100
 .globl main 
 .text 
 main: 
 la      $a0,  str# Code to read a string 
 li      $a1,  100                  # $a0:string address, $a1:length
 li      $v0,  8
 syscall
 jal    trans                        # call function trans
 li      $v0,  4  # Code to print a string  
 syscall    # Output results 
 li      $v0,  10  # terminate program run and 
 syscall  # return control to system   
 trans:
 move $a2, $a0                # Keep $a0, use $a2 point to string 
 li      $t0,  0x61                 # t0='a'
 li      $t1,  0x7a   # t1='z'
 li      $t2,  0                       # $t2 is counter
 loop: 
 lb      $t3,  ($a2)# Load char to $t3
 beqz $t3, ret   # if($t3==0) goto ret
 blt    $t3, $t0, next# if($t3<'a')goto next
 bgt    $t3, $t1, next # if($t3>'z')goto next
 addi $t3, $t3,-0x20# $t3-=0x20, lesser to upper
 sb      $t3,  ($a2)    # Store char $t3 to string
 next: 
 addi $a2, $a2, 1          # $a2 point to next char
 addi $t2, $t2, 1 # $t2++
 blt    $t2, $a1, loop# if($t2<$a1) loop
 ret:
 jr      $ra                           # return