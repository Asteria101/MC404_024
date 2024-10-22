.text
.globl _start

_start:
    la a0, string
    li a1, 0xffff0100
    jal mmio_read

    la a0, string
    jal peform_operation

    # exit code
    li a0, 0
    li a7, 93
    ecall


mmio_read:
    # a0: string pointer
    # a1: address of base memory

    0:
        li t0, 1
        sb t0, 0x2(a1) # triggers reading

        # busy wait
        1:
            lb t0, 0x2(a1)
            beqz t0, 1f
            j 1b
        1:
        
        lb t0, 0x3(a1) # read the value

        sb t0, (a0) # store the value in a string

        li t1, '\n'
        beq t0, t1, 0f
        addi a0, a0, 1
        j 0b
    0:
    ret


mmio_write:
    # a0: string pointer
    # a1: address of base memory

    0:
        lb t0, (a0)
        sb t0, 0x1(a1) # write the value

        li t1, 1
        sb t1, (a1) # triggers writing

        # busy wait
        1:
            lb t1, (a1)
            beqz t1, 1f
            j 1b
        1:

        li t1, '\n'
        beq t0, t1, 0f
        addi a0, a0, 1
        j 0b

    0:
    ret


reverse_string:
    # a0: string pointer
    # a1: aux_string pointer

    # t0: i that will go through *string
    # t1: j that will go through *aux_string

    # position pointer t0 correctly to last string position
    mv t0, a0
    0:
        lb t1, (t0) # t1 <- string[i]
        li t2, '\n'
        beq t2, t1, 0f
        addi t0, t0, 1
        j 0b
    0:


    addi t0, t0, -1
    mv t1, a1
    1:
        lb t2, (t0) # t2 <- string[i]
        sb t2, (t1) # aux_string[j] <- t2
        beq t0, a0, 1f
        addi t0, t0, -1
        addi t1, t1, 1
        j 1b
    1:
    addi t1, t1, 1 # so it reaches the correct position to store '\n'
    li t0, '\n'
    sb t0, (t1)

    ret


peform_operation:
    # a0: string pointer
    addi sp, sp, -16
    sw ra, (sp)

    lb t0, (a0) # load operation character
    addi t0, t0, -48

    li t1, 1
    beq t0, t1, 1f

    li t1, 2
    beq t0, t1, 2f

    li t1, 3
    beq t0, t1, 3f

    j end

    1:
        jal mmio_read

        la a0, string
        li a1, 0xffff0100
        jal mmio_write
        j end

    2:
        jal mmio_read

        la a0, string
        la a1, aux_string
        jal reverse_string

        la a0, aux_string
        li a1, 0xffff0100
        jal mmio_write
        j end

    3:  
        jal mmio_read

        
        j end

    end:
    lw ra, (sp)
    addi sp, sp, 16
    ret

.data
string: .skip 0x64
aux_string: .skip 0x64
