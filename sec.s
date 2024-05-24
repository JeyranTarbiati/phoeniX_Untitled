.globl _start
.text
_start:
    li s2,0b11001        # Input number is 11001 or 25 in decimal
    
    call sqrt       # Call the sqrt function

sqrt:
    addi sp, sp, -8   # Allocate space on stack for local variables
    sw ra, 0(sp)      # Save return address on stack
    sw s2, 5(sp)      # Save input number on stack
    li s4, 0          # Initialize result to 0
    li t1, 1          # Initialize bit mask to t1
    li t2, 0b00001    #Initialize the number which we want to calculate the aquare of it
    li a1, 0          #Initialize the index
    
sqar:
    and  a3, t2, t1    
    beqz a3, skip
    sll  a3, t2, a1 
    add  s4, s4, a3
skip:
    slli t1, t1, 1
    addi a1, a1, 1
    li a5, 5
    blt a1, a5, sqar  
    mv a6, s4
    j comp
comp:
    blt a6, s2, num_inc
    beq a6, s2, end
    
num_inc:
    addi t2, t2, 1
    li a1, 0
    li t1, 1
    li s4, 0
    j sqar
    
end:
    mv s5, t2         # the answer is saved in register s5
    lw ra, 0(sp)      # Restore return address
    addi sp, sp, 8    # Deallocate stack space
    ebreak