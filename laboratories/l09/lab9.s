.section .text
.globl _start

_start:
    jal main
    jal exit


exit:
    li a0, 0    # return code
    li a7, 93   # syscall exit
    ecall 
    ret


read:
    li a0, 0             # file descriptor
    la a1, input         # adress for the buffer
    li a2, 8             # buffer size
    li a7, 63            # syscall read
    ecall
    ret


write:
    li a0, 1             # file descriptor
    la a1, output        # adress for the buffer
    li a2, 8             # buffer size
    li a7, 64            # syscall write
    ecall
    ret


atoi:
    # Turns a string into a signed integer
    la a0, input             # load address of the input buffer to a0

    li t2, 1                 # t2 <= 1, for the signal
    li a1, 0                 # a1 <= 0, stores the number
    1:
        lbu t0, 0(a0)        # t0 <= first char

        li t1, '\n'          # t1 <= '\n'
        beq t0, t1, 1f       # if t0 == '\n', go to 1

        li t1, '-'           # t1 <= '-'
        bne t0, t1, 2f       # if t0 != '-', go to 2
        li t2, -1            # t2 <= -1
        j 3f

        2:
        li t1, 10            # t1 <= 10
        addi t0, t0, -48     # t0 <= t0 - '0'
        add a1, a1, t0       # a1 <= a1 + t0
        mul a1, a1, t1       # a1 <= a1 * 10

        3:
        addi a0, a0, 1
        j 1b
    1:
    li t1, 10            # t1 <= 10
    div a1, a1, t1       # a1 <= a1 / 10
    mul a1, a1, t2       # a1 <= a1 * t2

    ret
    

search:
    # Search for sum in the linked list
    # integer number is stored at s0
    la a0, head_node       # a0 <= head
    li t0, 0               # t0 <= 0, will iterate through the linked list
    lw s1, 0(a0)           # s1 <= *head

    li a1, -1              # a1 <= -1, in case the search detects no sum


    1:
    li t1, 0
    beq s1, t1, 1f         # if s1 == NULL, go to 1
    lw s2, 0(a0)           # s2 <= *s1 (VAL1)
    lw s3, 4(a0)           # s3 <= *(s1 + 4) (VAL2)
    add s2, s2, s3         # s2 <= s2 + s3

    beq s2, s0, 2f         # if s2 == s0, go to 2

    addi t0, t0, 1
    lw a0, 8(a0)           # s1 <= *(s1 + 8)  (pointer to the next node)
    lw s1, 0(a0)           # s1 <= *s1

    j 1b

    2:
    mv a1, t0

    1:
    ret


getDigitsNumber:
    # Returns the number of digits of a number
    # a1: has the number
    mv a2, a1
    debug1:

    li t0, 0
    bge a1, t0, 1f
    li t0, -1
    mul a2, a1, t0

    1:
    li t0, 0          # number of digits
    li t1, 10
    2:
    addi t0, t0, 1
    blt a2, t1, 2f
    div a2, a2, t1
    j 2b
    2:
    ret


itoa:
    # Turns a signed integer into a string
    # a0: has the integer
    addi sp, sp, -8
    sw ra, 4(sp)

    mv a1, a0
    jal getDigitsNumber
    mv s0, t0             # s0 <= t0, stores the number of digits


    la a1, output         # load address of the output buffer to a1

    # Check if the number is negative
    sw s0, 0(sp)
    li t0, 0
    bge a0, t0, 1f
    li t0, '-'
    sb t0, 0(a1)
    li t0, -1
    mul a0, a0, t0
    addi a1, a1, 1
    li s0, 1

    1:
    li t0, 0
    bge t0, s0, 1f

    li t2, 10
    rem t0, a0, t2        # t0 <= a0 % 10
    addi t0, t0, 48       # t0 <= t0 + '0'
    add t1, s0, a1        # access the correct position regarding the counter
    sb t0, 0(t1)

    divu a0, a0, t2        # a0 <= a0 / 10

    addi s0, s0, -1
    j 1b

    1:
    lw s0, 0(sp)

    li t0, '\n'
    add t1, s0, a1
    addi t1, t1, 1
    sb t0, 0(t1)    

    addi t1, t1, -1
    mv a1, t1

    lw ra, 4(sp)
    addi sp, sp, 8
    ret


main:
    addi sp, sp, -16
    sw ra, 0(sp)

    jal read
    jal atoi
    mv s0, a1           # s0 <= a1, stores the number
    jal search
    mv a0, a1
    jal itoa
    jal write
    
    addi sp, sp, 16
    lw ra, 0(sp)
    ret


input: .skip 8
output: .skip 8
