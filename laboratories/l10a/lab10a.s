.text

.globl _start
.globl exit
.globl puts
.globl gets
.globl atoi
.globl itoa
.globl linked_list_search
.globl buffer


exit:
    # a0: has the return code for the exit 
    li a7, 93
    ecall
    ret


puts:
    # a1: buffer pointer
    # a2: buffer size
    # returns: void
    la a1, buffer
    li t0, '\0'
    mv t1, a1      # t1 <= a1, t1 iterates over the buffer 

    1:
        lbu t2, 0(t1)
        beq t2, t0, 1f
        addi t1, t1, 1
        j 1b
    1:
    li t0, '\n'
    sb t0, 0(t1)

    sub t1, t1, a1
    addi t1, t1, 1

    li a0, 1             # file descriptor
    mv a2, t1            # a2 <= t1, a2 has the buffer size
    li a7, 64            # syscall write
    ecall
    ret


gets:
    # a1: buffer pointer
    # returns: buffer filled (a0: buffer pointer)
    la a1, buffer
    li a2, 100           # buffer size
    li a0, 0             # file descriptor
    li a7, 63            # syscall read
    ecall

    li t0, '\n'
    mv t1, a1      # t1 <= a1, t1 iterates over the buffer
    1:
        lbu t2, 0(t1)
        beq t2, t0, 1f
        addi t1, t1, 1
        j 1b
    1:
    li t0, '\0'
    sb t0, 0(t1)

    mv a0, a1

    ret


atoi:
    # Turns a string into a signed integer
    # a0: buffer pointer
    # returns: integer (a1)
    li t2, 1                 # t2 <= 1, for the signal
    li a1, 0                 # a1 <= 0, stores the number
    1:
        lbu t0, 0(a0)        # t0 <= first char

        li t1, '\0'          # t1 <= '\0'
        beq t0, t1, 1f       # if t0 == '\0', go to 1

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


