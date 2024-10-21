.text
.globl _start

/*
    Car initial position is aproximatelly (180, 3, -108)
    We need to get it to position (73, 1, -19)
*/

keep_going:
    # a0 has the limit for the loop
    li t0, 0
    0:
        # get the car's coordinates
        li t1, 0xFFFF0110
        lw t2, (t1) # x coordinate
        li t1, 0xFFFF0114
        lw t3, (t1) # y coordinate
        li t1, 0xFFFF0118
        lw t4, (t1) # z coordinate

        beq t0, a0, 0f
        addi t0, t0, 1
        j 0b
    0:
    ret


break:
    # loop for stopping the car
    # a0 has the limit for the loop

    li t0, 0
    0:
        # activates the brake
        li a1, 0xFFFF0122
        li t1, 1
        sb t1, (a1)

        beq t0, a0, 0f
        addi t0, t0, 1
        j 0b
    0:
    # sets car's engine to go off
    li a0, 0xFFFF0121
    li t1, 0
    sb t1, (a0)
    ret


_start:
    # initial setup
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
    sb t0, (a0)
    li a0, 10000
    jal keep_going

    # Start turnning the car 91 degrees to the left
    li a0, 0xFFFF0120
    li t0, -90
    sb t0, (a0)
    li a0, 6500
    jal keep_going

    # after turning the car, we need to go a bit forward
    li a0, 0xFFFF0120
    li t0, 0
    sb t0, (a0) # steering wheel direction set to 0
    li a0, 3000
    jal keep_going

    # loop for stopping the car
    li a0, 7000
    jal break

    li a0, 0xFFFF0100 
    li a1, '0'
    sb a1, (a0) # store '0' into a0, to stop reading the coordinates and rotation

    li a0, 0 # return value
    li a7, 93 # exit syscall
    ecall
    ret