.data 
array:.word 49,38,65,97,76,13,27
 .globl main
 .text
 main:
        la      $a0,  array  
        li      $t0,  6  
lp0:              
       addi $a1, $a0, 4  
       move $t1, $t0   
lp1:  
       lw      $t2,  ($a0)        
       lw      $t3,  ($a1)
       ble    $t2,  $t3,  next
       sw      $t2,  ($a1)         
       sw      $t3,  ($a0)
       next:        
       addi $a1, $a1, 4      
       addi $t1, $t1,-1         
       bgt    $t1, $0, lp1
       addi $a0, $a0, 4  
       addi $t0, $t0,-1 
       bgt    $t0, $0, lp0
       li      $v0,  10