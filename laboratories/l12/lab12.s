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
    # Function that will reserve a string and copy the reversed string to a destination pointer
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


atoi:
    # Function to turn a string into a decimal number
    # a0: string pointer
    # a1: when to stop 
    # returns: integer (a0)

    li t0, 1 # for signal calculations
    li t1, 0 # will store the number
    0:
        lbu t2, (a0)

        # check new line char
        beq a1, t2, 0f

        # check minus signal 
        li t3, '-'
        bne t2, t3, 1f
        li t0, -1
        j 2f

        1:
            addi t2, t2, -48 # t2 <- t2 - '0'
            add t1, t1, t2
            li t2, 10
            mul t1, t1, t2

        2:
            addi a0, a0, 1
            j 0b

    0:
    li t2, 10
    divu t1, t1, t2
    mul t1, t1, t0

    mv a0, t1
    ret


itoa_hex:
    # Function to turn an integer to its string hexdecimal representation 
    # a0: integer number
    # a1: string pointer that will store hex number

    addi t2, a1, 7

    0:
        li t0, 16
        remu t0, a0, t0 # t0 <- a0 % 16

        li t1, 10
        blt t0, t1, 1f

        # A to F
        sub t0, t0, t1
        addi t0, t0, 'A'
        j 2f

        1:
            # 0 to 9
            addi t0, t0, 48

        2:
            sb t0, (a1)
            li t0, 16
            divu a0, a0, t0

        beq a1, t2, 0f
        addi a1, a1, 1
        j 0b
    0:

    mv t1, a1
    extra_zeros:
        lb t0, (t1)
        li t2, '0'
        bne t0, t2, not_zero
        addi t1, t1, -1
        j extra_zeros

    not_zero:
        li t0, '\n'
        addi t1, t1, 1
        sb t0, (t1)

    ret


itoa_dec:
    # Function to turn an integer to its string decimal representation
    # a0: integer number
    # a1: string pointer

    bnez a0, 4f
    li t0, '0'
    sb t0, (a1)
    li t0, '\n'
    sb t0, 1(a1)
    j return

    4:
    li t0, 0 # counter
    mv t2, a0 # t3 <= a0
    2:
        addi t0, t0, 1 # t1++
        li t1, 10 # base 10
        div t2, t2, t1 # t3 /= 10

        beqz t2, 2f
        j 2b
    2:
    add t2, a1, t0

    li t3, 1

    bgez a0, 0f
    li t3, -1
    mul a0, a0, t3

    0:
        li t0, 10
        remu t0, a0, t0 # t0 <- a0 % 10

        # 0 to 9
        addi t0, t0, 48

        sb t0, (a1)
        li t0, 10
        divu a0, a0, t0

        beq a1, t2, 0f
        addi a1, a1, 1
        j 0b
    0:
    mv t1, a1


    1:
        lb t0, (t1)
        li t2, '0'
        bne t0, t2, 1f
        addi t1, t1, -1
        j 1b

    1:

    bgez t3, 3f
    li t0, '-'
    addi t1, t1, 1
    sb t0, (t1)

    3:
    li t0, '\n'
    addi t1, t1, 1
    sb t0, (t1)

    return:
    ret


get_operator:
    # a0: string pointer
    # returns: address to next number (a0), operator char (a1)

    0:
        lb t0, (a0)
        li t1, ' '
        beq t1, t0, 0f
        addi a0, a0, 1

        j 0b
    0:
    addi a0, a0, 1
    lb t0, (a0)
    addi a0, a0, 2
    mv a1, t0
    ret


treat_expression:
    # Function to treat algebraic expression
    # returns: result of expression (a0)

    la a0, string
    li a1, ' '
    jal atoi
    sw a0, 4(sp) # first number

    la a0, string
    jal get_operator
    sb a1, 8(sp) # operator

    li a1, '\n'
    jal atoi

    mv t1, a0
    lw t2, 8(sp) # retrieve operator
    lw t0, 4(sp) # retrieve first number

    plus:
        li t3, '+'
        bne t2, t3, minus
        add t0, t0, t1
        j 0f

    minus:
        li t3, '-'
        bne t2, t3, times
        sub t0, t0, t1
        j 0f

    times:
        li t3, '*'
        bne t2, t3, division
        mul t0, t0, t1
        j 0f

    division:
        # check if t0 and t1 are positive, if not make them positive
        bgez t0, 1f
        li t2, -1
        mul t0, t0, t2
        1:
        bgez t1, 2f
        li t3, -1
        mul t1, t1, t3
        2:
        divu t0, t0, t1

        # check if the result is negative
        bgez t2, 3f
        mul t0, t0, t2
        3:
        bgez t3, 0f
        mul t0, t0, t3

    0:
    mv a0, t0
    ret


peform_operation:
    # Function that has a switch case for the operations and calls the correct ones
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

    li t1, 4
    beq t0, t1, 4f

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

        la a0, string
        li a1, '\n'
        jal atoi

        la a1, string
        jal itoa_hex

        la a0, string
        la a1, aux_string
        jal reverse_string

        la a0, aux_string
        li a1, 0xffff0100
        jal mmio_write
        j end

    4:
        jal mmio_read
        
        jal treat_expression

        la a1, string
        jal itoa_dec

        la a0, string
        la a1, aux_string
        jal reverse_string

        la a0, aux_string
        li a1, 0xffff0100
        jal mmio_write

    end:
    lw ra, (sp)
    addi sp, sp, 16
    ret


.data
string: .skip 0x32
aux_string: .skip 0x32
