.text
.globl _start

/*
    Car initial position is aproximatelly (180, 3, -108)
    We need to get it to position (73, 1, -19)
*/

_start:
    li a0, 0xFFFF0100 # address of the first byte of the memory-mapped I/O region
    li a1, '1' # store into a1
    sb a1, (a0) # store a1 into a0, to start reading the coordinates and rotation

    # sets car's engine to go forward
    li a0, 0xFFFF0121
    li t0, 1
    sb t0, (a0) # engine direction set to forward

    # Get car to turnning point
    # sets car's steering wheel to go only forward
    li a0, 0xFFFF0120
    li t0, 0
    sb t0, (a0) # steering wheel direction set to forward 

    li t0, 10000
    li t1, 0
    0:
        li a0, 0xFFFF0110
        lw a1, (a0) # x coordinate
        li a0, 0xFFFF0114
        lw a2, (a0) # y coordinate
        li a0, 0xFFFF0118
        lw a3, (a0) # z coordinate
        beq t1, t0, 0f
        addi t1, t1, 1
        j 0b
    0:

    # Start turnning the car
    li a0, 0xFFFF0121
    li t0, 1
    sb t0, (a0) # engine direction set to forward

    li a0, 0xFFFF0120
    li t0, -90
    sb t0, (a0) # steering wheel direction set to 45 degress 

    li t0, 6500
    li t1, 0
    1:
        li a0, 0xFFFF0110
        lw a1, (a0) # x coordinate
        li a0, 0xFFFF0114
        lw a2, (a0) # y coordinate
        li a0, 0xFFFF0118
        lw a3, (a0) # z coordinate
        beq t1, t0, 1f
        addi t1, t1, 1
        j 1b
    1:

    # go forward
    li a0, 0xFFFF0121
    li t0, 1
    sb t0, (a0) # engine direction set to forward

    li a0, 0xFFFF0120
    li t0, 0
    sb t0, (a0) # steering wheel direction set to 0

    # loop for stopping the car
    li t0, 3400
    li t1, 0
    2:
        li a0, 0xFFFF0122
        li t2, 1
        sb t2, (a0)
        beq t1, t0, 2f
        addi t1, t1, 1
        j 2b
    2:

    li a0, 0xFFFF0100 # address of the first byte of the memory-mapped I/O region
    li a1, '0' # store into a1
    sb a1, (a0) # store a1 into a0, to start reading the coordinates and rotation

    li a0, 0 # return value
    li a7, 93 # exit syscall
    ecall
    ret