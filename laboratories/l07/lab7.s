.section .text

.globl _start

_start:
    jal main
    jal exit

exit:
    li a0, 0
    li a7, 93      # syscall exit
    ecall
    ret

read:
    li a0, 0
    la a1, input
    mv a2, a3
    li a7, 63      # syscall read
    ecall
    ret

write:
    li a0, 1
    la a1, output
    mv a2, a3
    li a7, 64      # syscall write
    ecall
    ret


encode:
    # d1 d2 d3 d4
    # 0  1  2  3  (indeces in input)
    # p1 -> 0 1 3
    # p2 -> 0 2 3
    # p3 -> 1 2 3

    la a0, input # load the address of the input buffer into a0
    
    lbu t0, 0(a0)    # t0 <= d1
    lbu t1, 1(a0)    # t1 <= d2
    lbu t2, 2(a0)    # t2 <= d3
    lbu t3, 3(a0)    # t3 <= d4

    # s0 <= p1 = d1 ^ d2 ^ d4
    xor s0, t0, t1
    xor s0, s0, t3

    # s1 <= p2 = d1 ^ d3 ^ d4
    xor s1, t0, t2
    xor s1, s1, t3

    # s2 <= p3 = d2 ^ d3 ^ d4
    xor s2, t1, t2
    xor s2, s2, t3

    # store the results in the output buffer
    la a0, output

    sb s0, 0(a0)
    sb s1, 1(a0)
    sb t0, 2(a0)
    sb s2, 3(a0)
    sb t1, 4(a0)
    sb t2, 5(a0)
    sb t3, 6(a0)
    li t0, '\n'
    sb t0, 7(a0)

    ret


decode:
    la a0, input

    # load the values d1, d2, d3, d4 from the input buffer to t0, t1, t2, t3 respectively
    lbu t0, 2(a0)
    lbu t1, 4(a0)
    lbu t2, 5(a0)
    lbu t3, 6(a0)

    la a0, output

    # store the values in the output buffer
    sb t0, 0(a0)
    sb t1, 1(a0)
    sb t2, 2(a0)
    sb t3, 3(a0)
    li t0, '\n'
    sb t0, 4(a0)

    ret

check_error:
    la a0, input

    lbu t0, 0(a0) # p1 <= t0
    lbu t1, 1(a0) # p2 <= t1
    lbu t2, 2(a0) # d1 <= t2
    lbu t3, 3(a0) # p3 <= t3
    lbu t4, 4(a0) # d2 <= t4
    lbu t5, 5(a0) # d3 <= t5
    lbu t6, 6(a0) # d4 <= t6

    # a0 <= p1 ^ d1 ^ d2 ^ d4
    xor a0, t0, t2
    xor a0, a0, t4
    xor a0, a0, t6

    # a1 <= p2 ^ d1 ^ d3 ^ d4
    xor a1, t1, t2
    xor a1, a1, t5
    xor a1, a1, t6

    # a2 <= p3 ^ d2 ^ d3 ^ d4
    xor a2, t3, t4
    xor a2, a2, t5
    xor a2, a2, t6

    # a0 <= a0 OR a1 OR a2
    or a0, a0, a1
    or a0, a0, a2
    add a0, a0, 48

    la a1, output
    sb a0, 0(a1)
    li t0, '\n'
    sb t0, 1(a1)

    ret


main:
    addi sp, sp, -16
    sw ra, 0(sp)

    # first part of lab7
    li a3, 5
    jal read
    jal encode
    li a3, 8
    jal write

    # second part of lab7
    li a3, 8
    jal read
    jal decode
    li a3, 5
    jal write

    jal check_error
    li a3, 2
    jal write


    lw ra, 0(sp)   
    addi sp, sp, 16
    ret



.data 
input: .skip 0x8 # 8 bytes for the input buffer
output: .skip 0x8 # 8 bytes for the output buffer