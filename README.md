Computer Organization - Spring 2024
==============================================================
## Iran Univeristy of Science and Technology
## Assignment 1: Assembly code execution on phoeniX RISC-V core

- Name:Jeyran Tarbiati
- Team Members:Rozha Hasheminezhad
- Student ID: 400411261
- Date:1403/3/4

## Report for first question (quick sort)

-SUMMERY: This code will sort the given number that we saved in satacks.This numbers are 9,6,3,12,7,10.In this way our code set the last number as a pivot and check the other numbers and the first number that is greater than the pivot will be our pointer. then going to check the rest if they are smaller will be switch to pointer this process will be continued until the numbers that are less than pivot are at left and the greater ones are at right and at the end this algorithm happens again for less numbers and greater numbers to set in the suitable positions.
line 4-26:
 here we are saving the list of numbers we want to sort. Here is an example for saving a number in memory:
 li a0, 0x0 : adress of the destination of memory
li a1, 9    : loading the number we want to save
sw a1, 0(a0) :save the number existing in register a1 to the defined adress
our saved numbers: [9,6,3,12,10,7]
start:
    li a2, 4
    li t6, 0x0 : the most right position
    li a7 , 0x0  :the most right position
    lw t0, 0(a0)   : the point of this line is defining our pivot number (pivot number is in a0=0x14,the most left number)
loop:
    lw t1, 0(t6)
    bge t0, t1, pointer :selecting our pointer how? by compairing the pivot with element in address 0x0 to 0x10 , the first larger number than pivot is making our pointer
what does loop do? loop will repeat till we find our pointer
next step: after findig our pivot and pointer the next step is to find numbers less than the pivot
the label pointer is comparing the pivot with the numbers after the pointer if our current element is less than pivot the program jumps to the swap label otherwise the pointer will repeat again
pointer:
    lw s9, 0(t6) 
    lw t3, 4(a7)
    ble t3, t0, swap 
    addi a7, a7, 4
    j pointer
the job of swap label: the swap label will replace the value of the pointer with the element we found it less than pivot
after that again we jump to loop to find the new pointer

swap:
    sw t3, 0(t6) 
    sw t1, 4(a7)
    addi a7, a7, 4
    beq a7, a0, right
    addi t6, t6, 4
    j loop
we repeat this algorithem till we reach this layout
[6,3,7,12,10,9]
all the smaller number than pivot are at the left of pivot and all the greater number than pivot are at the right of the pivot 
we repeat the above algorithm for right_side numbers and left_side numbers separatly 
and the result will be:
[3,6,7,9,10,12]
https://github.com/phoeniX-Digital-Design/phoeniX/issues/1#issue-2315514127
- for the waveform of this code we got two different errors during the project even though we asked from TAs and searching for the problem we couldn't solve it.
this is the error for quick sort question:
https://github.com/phoeniX-Digital-Design/phoeniX/issues/3#issue-2315630946

## Report for second question
SUMMERY:In this code first we choose one number as base number like number 1 then we square the number then comparing with our pivot that is 25 that its square root is 5 if it is different and is less than 25 we go to the next number until the time that they are equal so in this moment that number will be our answer that we in it to a specific register.
line2
 _start:    li s2,0b11001       0b11001 is equal to 25 we want find the second root of it

  li s4, 0          # Initialize result to 0 => the result of squaring will be loaded in s4
    li t1, 1          # Initialize bit mask to t1 => we will explain why we need a mask 
    li t2, 0b00001    #Initialize the number which we want to calculate the aquare of it 
    li a1, 0          #Initialize the index
      
the first number we want to square is 1 

algorithem of squaring:

sqar:
    and  a3, t2, t1    
    beqz a3, skip 
    sll  a3, t2, a1 
    add  s4, s4, a3

skip:
    slli t1, t1, 1
    addi a1, a1, 1
    li a5, 5
    blt a1, a5, sqar  : checking if the algorithem is done for first number  
    mv a6, s4
    j comp  : the comp label will check if result is equal to 25 or not, if it is equal the 25, the number is the answer of our question
https://github.com/phoeniX-Digital-Design/phoeniX/issues/2#issue-2315624531
- these are the error for second question:
https://github.com/phoeniX-Digital-Design/phoeniX/issues/4#issue-2315634797