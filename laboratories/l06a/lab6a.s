.section .text

.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93      # syscall exit
    ecall

atoi:
    la a0, input        # load address of the input buffer to a0

    add t0, a0, s0      # t0 recieves the memory address of the first char each 4-digit number
    li s2, 10           # s2 <= 10 representing the base

    lbu a0, 0(t0)       # a0 <= first char
    addi a0, a0, -48    # turn char into int
    mul a0, a0, s2      # multiply by 10

    lbu t2, 1(t0)       # t2 <= second char
    addi t2, t2, -48
    add a0, a0, t2
    mul a0, a0, s2

    lbu t2, 2(t0)       # t2 <= third char
    addi t2, t2, -48
    add a0, a0, t2
    mul a0, a0, s2

    lbu t2, 3(t0)       # t2 <= fourth char
    addi t2, t2, -48
    add a0, a0, t2

    ret

sqrt:
    # a0 has the integer number
    li s1, 0
    li s2, 10
    srli t1, a0, 1         # t4 = y/2 = k

    2:
        bge s1, s2, 2f
        
        mul t2, t1, t1     # t2 = k*k
        add t2, t2, a0     # t2 = k*k + y
        slli t1, t1, 1     # t3 = 2*k
        divu t1, t2, t1    # t1 = (k*k + y) / 2*k

        addi s1, s1, 1
        j 2b

    2:
    mv a0, t1

    ret

itoa:
    la a0, output

    add t0, a0, s0

    li s1, 3     # counter to iterate
    li s2, 10    # decimal base to operate the conversion

    3:
        li t1, -1
        bge t1, s1, 3f

        rem t1, a2, s2    # t1 <= a2 % 10
        addi t1, t1, 48   # t1 <= t1 + 48, turn into char
        add t2, s1, t0    # access the correct position regarding the counter
        sb t1, 0(t2)      # stores in the memory

        divu a2, a2, s2

        addi s1, s1, -1

        j 3b

    3:
    mv a0, t0

    ret

main:
    addi sp, sp, -16
    sw ra, 0(sp)
    jal read

    li s0, 0
    1:
        li s1, 15
        bge s0, s1, 1f

        debug5:

        jal atoi
        jal sqrt
        mv a2, a0
        jal itoa

        li t0, ' '
        add t1, s0, a0
        sb t0, 4(t1)

        addi s0, s0, 5
        j 1b

    1:
    mv a3, a0
    li t0, '\n'
    sb t0, 9(a3)
    jal write

    lw ra, 0(sp)   
    addi sp, sp, 16
    ret

read:
    li a0, 0       # file descriptor
    la a1, input   # input buffer
    li a2, 20      # size
    li a7, 63      # syscall read (63)
    ecall

    ret

write:
    li a0, 1       # file descriptor
    la a1, output  # buffer
    li a2, 20      # size
    li a7, 64      # syscall write (64)
    ecall

    ret


.section .data
input: .skip 0x14   # buffer to store the input
output: .skip 0x14   # buffer to store the output