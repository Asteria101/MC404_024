.text
.globl _start


mmio_read:
    # a0: buffer pointer
    # returns: index i where buffer[i] == '\n' (a0)
    mv t0, a0

    0:
        li a0, 0xFFFF0102
        li t1, 1
        sb t1, (a0) # triggers reading

        li a0, 0xFFFF0103
        lb t1, (a0) # read the value
        sb t1, (t0) # store the value in a buffer

        li t2, '\n'
        beq t1, t2, 0f
        addi t0, t0, 1
        j 0b
    0:
    li a0, 0xFFFF0102
    li t1, 0
    sb t1, (a0) # reading is complete
    
    ret

mmio_write:
    # a0: buffer pointer
    mv t0, a0

    0:
        lb t1, (t0)
        li a0, 0xFFFF0101
        sb t1, (a0) # write the value

        li a0, 0xFFFF0100
        li t2, 1
        sb t2, (a0) # triggers writing

        li t2, '\n'
        beq t1, t2, 0f
        addi t0, t0, 1
        j 0b

    0:
    li a0, 0xFFFF0100
    li t2, 0
    sb t2, (a0) # triggers writing

    ret


_start:
    la a0, buffer
    jal mmio_read
    la a0, buffer
    jal mmio_write

    # exit code
    li a0, 0
    li a7, 93
    ecall

.data
buffer: .skip 0x100
