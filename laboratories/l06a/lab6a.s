.section .text

.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93      # syscall exit
    ecall

atoi:
    # a1 has input address
    la a1, input   # input buffer
    add t3, a1, a0
    li t1, 10

    lbu a2, 0(t3)
    addi a2, a2, -48
    mul a2, a2, t1

    lbu t2, 1(t3)
    addi t2, t2, -48
    add a2, a2, t2
    mul a2, a2, t1

    lbu t2, 2(t3)
    addi t2, t2, -48
    add a2, a2, t2
    mul a2, a2, t1

    lbu t2, 3(t3)
    addi t2, t2, -48
    add a2, a2, t2

    ret

sqrt:
    # a2 has the integer number
    li t0, 0
    li t1, 9
    srli t4, a2, 1         # t4 = y/2 = k
    for_sqrt:
        bge t0, t1, end_sqrt
        
        mul t2, t4, t4     # t2 = k*k
        add t2, t2, a2     # t2 = k*k + y
        slli t3, t4, 1     # t3 = 2*k
        divu t4, t2, t3    # t4 = (k*k + y) / 2*k

        addi t0, t0, 1
        j for_sqrt

    end_sqrt:
    
    mv a2, t4
    ret

itoa:
    addi sp, sp, -16
    sw ra, 0(sp)

    la a3, output
    add t5, a3, a0

    li t0, 3    # counter to iterate
    li t1, -1    # number used for the bge, so t0 reaches 0
    li t2, 10   # decimal base to operate the conversion

    for_itoa:

        bge t0, t1, end_itoa

        rem t3, a2, t2    # t3 <= a2 % 10
        addi t3, t3, 48   # t3 <= t3 + 48, turn into char
        add t4, t0, t5    # access the correct position regarding t0
        addi t3, zero, '0'
        sb t3, 0(t4)      # stores in the memory

        divu a2, a2, t2

        addi t0, t0, -1
        j for_itoa

    end_itoa:
    li t3, ' '
    sb t3, 4(t4)

    lw ra, 0(sp)   
    addi sp, sp, 16
    ret


main:
    addi sp, sp, -16
    sw ra, 0(sp)
    jal read

    li a0, 0
    for:
        /*bge a0, t0, end_for
        la s1, output  # output buffer
        li s0, '\n'
        sb s0, 19(s1)
        li s0, 'a'
        sb s0, 18(s1)
        jal write*/

        li t0, 5
        jal atoi
        jal sqrt
        jal itoa

        addi a0, a0, 5
        j for

    end_for:
    la a3, output  # output buffer
    li t0, '\n'
    sb t0, 19(a3)


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