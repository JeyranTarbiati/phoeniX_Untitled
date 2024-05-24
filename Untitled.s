# defining our numbers we want to sort
# we want to store these numbers in memory : 9 , 6 , 3 , 12, 10 , 7

li a0, 0x0
li a1, 9
sw a1, 0(a0)

li a0, 0x4
li a1, 6
sw a1, 0(a0)

li a0, 0x8
li a1, 3
sw a1, 0(a0)

li a0, 0xc
li a1, 12
sw a1, 0(a0)

li a0, 0x10
li a1, 10
sw a1, 0(a0)

li a0, 0x14
li a1, 7
sw a1, 0(a0)

##################################################################

start:
    li a2, 4
    li t6, 0x0
    li a7 , 0x0
    lw t0, 0(a0)

loop:
    lw t1, 0(t6)
    bge t0, t1, pointer
    
pointer:
    lw s9, 0(t6)
    lw t3, 4(a7)
    ble t3, t0, swap
    addi a7, a7, 4
    j pointer


swap:
    sw t3, 0(t6) 
    sw t1, 4(a7)
    addi a7, a7, 4
    beq a7, a0, right
    addi t6, t6, 4
    j loop

right:
    addi s1, t6, -4
    lw a3, 0(s1)       #new pivot in right
    li a5, 0x0 
    li s3, 0x0

loop_r:
    lw a4, 0(a5) 
    bge a4, a3, pointer_r
    addi a5, a5, 4
    j loop_r

pointer_r:
    lw s2, 4(a5)
    ble s2, a3, swap_r
    addi s3, s3, 4
    j pointer_r




swap_r:
    sw s2, 0(a5)
    sw a4, 4(s3)
    addi s3, s3, 4
    beq s3, s1, left
    addi a5, a5, 4
    j loop_r

left:
    lw s4, 0(a0)         #new pivot in left
    addi s5, t6, 4
    addi s6, t6, 4

loop_l:
    lw s7, 0(s5)         
    bge s7, s4, pointer_l
    addi s5, s5, 4

pointer_l:
    lw s0, 0(s5)
    lw s8, 4(s6)
    ble s8, s4, swap_l
    addi s6, s6, 4
    j pointer_l

swap_l:
    sw s8, 0(s5)
    sw s7, 4(s6)
    addi s6, s6, 4
    beq s6, a0, END
    
END:
   ebreak