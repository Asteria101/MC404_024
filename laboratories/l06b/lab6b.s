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
    li s1, 10           # s1 <= 10 representing the base

    lbu a0, 0(t0)       # t2 <= second char
    addi a0, a0, -48
    mul a0, a0, s1

    lbu t2, 1(t0)       # t2 <= third char
    addi t2, t2, -48
    add a0, a0, t2
    mul a0, a0, s1

    lbu t2, 2(t0)       # t2 <= fourth char
    addi t2, t2, -48
    add a0, a0, t2
    mul a0, a0, s1

    lbu t2, 3(t0)       # t2 <= fifth char
    addi t2, t2, -48
    add a0, a0, t2

    ret


verify_signal_str:
    la t1, input        # load address of the input buffer to a0

    addi s0, s0, -1       # decrement the index to access the correct position

    add t0, t1, s0      # t0 recieves the memory address of the first char each 4-digit number
    li s2, 10           # s2 <= 10 representing the base

    lbu t1, 0(t0)       # t1 <= first char
    li a0, '+'
    beq t1, a0, 4f    # if a0 == '+', jump to 4
        li a0, -1
        j cont

    4:
    li a0, 1

    cont:

    ret

find_distance:
    li t0, 3
    li t1, 10
    mul a0, a0, t0
    div a0, a0, t1

    ret

find_y:
    mul s5, s5, s5  # s5 <= Da²
    mul s6, s6, s6  # s6 <= Db²
    mul t0, s3, s3  # t0 <= Yb²

    add a0, s5, t0
    sub a0, a0, s6
    slli s3, s3, 1  # s3 <= 2Yb
    rem t0, a0, s3  # t0 <= (Da² - Db² + Yb²) % 2Yb
    div t0, s3, t0  # t0 <= 2Yb / ((Da² - Db² + Yb²) % 2Yb)

    div a0, a0, s3 # a0 <= (Da² - Db² + Yb²) / 2Yb
    
    li t1, 1
    bne t0, t1, cont3
        addi a0, a0, 1
    cont3:

    ret
    
find_x:
    addi sp, sp, -16
    sw ra, 0(sp)

    mul t0, s4, s4
    mul s7, s7, s7

    add a0, s5, t0
    sub a0, a0, s7

    slli s4, s4, 1 

    rem t0, a0, s4
    div t0, s4, t0
    div a0, a0, s4

    li t1, 1
    bne t0, t1, cont4
        addi a0, a0, 1
    cont4:

    lw ra, 0(sp)   
    addi sp, sp, 16

    ret


itoa:
    addi sp, sp, -16
    sw ra, 0(sp)

    # a2 has the integer number
    li t0, 0
    li t1, -1
    bge a2, t0, else
        li s3, '-'
        mul a2, a2, t1
        j cont2
    else:
    li s3, '+'

    cont2:

    la a0, output
    add t0, a0, s0
    sb s3, 0(t0)

    li s1, 4     # counter to iterate
    li s2, 10    # decimal base to operate the conversion

    3:
        li t1, 0
        bge t1, s1, 3f

        rem t1, a2, s2    # t1 <= a2 % 10
        addi t1, t1, 48   # t1 <= t1 + 48, turn into char
        add t2, s1, t0    # access the correct position regarding the counter
        sb t1, 0(t2)      # stores in the memory

        divu a2, a2, s2

        addi s1, s1, -1

        j 3b

    3:
    mv a4, t0
    li t0, ' '
    sb t0, 5(a4)

    lw ra, 0(sp)   
    addi sp, sp, 16
    ret




main:
    addi sp, sp, -16
    sw ra, 0(sp)

    # read the coordinates of the satillites B and C
    li a3, 12
    jal read
    li s0, 1
    jal atoi
    mv s3, a0               # s3 <= Yb
    jal verify_signal_str
    mul s3, s3, a0

    li s0, 7
    jal atoi
    mv s4, a0               # s4 <= Xc
    jal verify_signal_str
    mul s4, s4, a0

    
    # read the timestamps of the satillites A, B, C and the receiver
    li a3, 20
    jal read

    li s0, 0
    jal atoi
    mv s5, a0               # s5 <= Ta

    li s0, 5
    jal atoi
    mv s6, a0               # s6 <= Tb

    li s0, 10
    jal atoi
    mv s7, a0               # s7 <= Tc

    li s0, 15
    jal atoi
    mv s8, a0               # s8 <= Tr

    
    # perform the time difference (T{abc} <= Tr - T{abc})
    sub s5, s8, s5
    sub s6, s8, s6
    sub s7, s8, s7

    # perform the distance calculation (D{abc} <= (3 * T{abc}) / 10)
    mv a0, s5
    jal find_distance       # Calculate the distance of the satillite A
    mv s5, a0

    mv a0, s6
    jal find_distance       # Calculate the distance of the satillite B
    mv s6, a0

    mv a0, s7
    jal find_distance       # Calculate the distance of the satillite C
    mv s7, a0

    

    # to find the coordinates of the receiver, we can perform the following equations
    # Yr = (Da² - Db² + Yb²) / 2Yb

    jal find_y
        mv a2, a0
    mv s8, a2
    li s0, 6
    jal itoa
    
    jal find_x
        mv a2, a0
    li s0, 0
    jal itoa

    li t0, '\n'
    sb t0, 11(a4)
    li a3, 12
    jal write

    lw ra, 0(sp)   
    addi sp, sp, 16
    ret

read:
    li a0, 0       # file descriptor
    la a1, input   # input buffer
    mv a2, a3      # size
    li a7, 63      # syscall read (63)
    ecall

    ret

write:
    li a0, 1       # file descriptor
    la a1, output  # buffer
    mv a2, a3      # size
    li a7, 64      # syscall write (64)
    ecall

    ret


.section .data
input: .skip 0x14   # buffer to store the input
output: .skip 0xc   # buffer to store the output