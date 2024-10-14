.text

.globl _start
.globl exit
.globl puts
.globl gets
.globl atoi
.globl itoa
.globl linked_list_search


exit:
    # a0: has the return code for the exit 
    li a7, 93
    ecall
    ret


puts:
    # a0: buffer pointer
    # a1: buffer size THIS CANT BE A PARAMETER
    # returns: void

    li t0, '\n'
    add t1, a0, a1
    sb t0, 0(t1)

    mv a4, a0
    addi a1, a1, 1
    mv a3, a1

    li a0, 1             # file descriptor
    mv a1, a4            # buffer pointer
    mv a2, a3            # buffer size
    li a7, 64            # syscall write
    ecall
    ret


gets:
    # a0: buffer pointer
    # returns: buffer filled (a0: buffer pointer), string size without \0 (a1)

    mv a1, a0
    li a2, 100           # buffer size
    li a0, 0             # file descriptor
    li a7, 63            # syscall read
    ecall
    mv a3, a0
    addi a3, a3, -1

    li t0, '\n'
    mv t1, a1            # t1 <= a1, t1 iterates over the buffer
    1:
        lbu t2, 0(t1)
        beq t2, t0, 1f
        addi t1, t1, 1
        j 1b
    1:
    li t0, 3
    sb t0, 0(t1)

    mv a0, a1
    mv a1, a3

    debug:

    ret


atoi:
    # Turns a string into a signed integer
    # a0: buffer pointer
    #   
    # returns: integer (a0)
    mv a3, a1
    add a3, a0, a3
    li t2, 1                 # t2 <= 1, for the signal
    li a1, 0                 # a1 <= 0, stores the number
    1:
        beq a0, a3, 1f       # if a0 == size, go to 1

        lbu t0, 0(a0)        # t0 <= first char

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


    mv a0, a1
    ret


getDigitsNumber:
    # a0: has the number
    # returns: number of digits (a0)

    mv t2, a0

    li t0, 0
    bge t2, t0, 1f      # if t2 >= 0, go to 1
    li t0, -1
    mul t2, t2, t0      # else: t2 < 0, t2 *= -1

    1:
    li t0, 0            # number of digits
    li t1, 10           # base

    2:
    addi t0, t0, 1
    blt t2, t1, 2f      # if t2 < 10, go to 2
    div t2, t2, t1      # t2 /= 10
    j 2b

    2:
    mv a0, t0

    ret


itoa:
    # Turns a signed integer into a string
    # a0: has the number
    # a1: has the buffer addres
    # a2: has the base to be converted

    # returns: the buffer pointer (a0), buffer size (a1 <= s0)

    addi sp, sp, -12
    sw ra, 8(sp)

    sw a0, 4(sp)
    jal getDigitsNumber
    mv s0, a0               # s0 <= a0, stores the number of digits
    lw a0, 4(sp)            # reload to a0 the integer

    # Check if the number is negative
    sw s0, 0(sp)            # store the number of digits for adding the \n

    li t0, 0                # t0 <= 0
    bge a0, t0, 1f          # if a0 >= 0, go to 1

    li t0, '-'              # else: t0 <= '-', stores the signal
    sb t0, 0(a1)
    li t0, -1               # t0 <= -1
    mul a0, a0, t0          # a0 <= a0 * -1    turns the number positive
    addi a1, a1, 1          # a1 <= a1 + 1     buffer++

    1:
        li t0, 0
        bge t0, s0, 1f

        rem t0, a0, a2        # t0 <= a0 % base

        li t1, 10
        blt t0, t1, 2f        # if t0 <= 9, go to 2

        sub t0, t0, t1        # t0 -= 10
        addi t0, t0, 'A'      # else: t0 <= t0 + 'A'
        j 3f

        2:
        addi t0, t0, 48       # t0 <= t0 + '0'
        
        3:
        add t1, s0, a1        # access the correct position regarding the counter
        sb t0, 0(t1)          # store the digit in the buffer
        divu a0, a0, a2       # a0 <= a0 / base

        addi s0, s0, -1
        j 1b

    1:
    lw s0, 0(sp)

    li t0, '\0'
    add t1, s0, a1
    addi t1, t1, 1
    sb t0, 0(t1)    

    sub t1, t1, s0

    mv a0, t1
    mv a1, s0

    lw ra, 8(sp)
    addi sp, sp, 12

    ret


linked_list_search:
    # Search for sum in the linked list
    # a0: head_node address
    # a1: value to be found

    li t0, 0               # t0 <= 0, will iterate through the linked list
    lw s1, 0(a0)           # s1 <= *head

    1:
        li t1, 0
        beq s1, t1, 3f         # if s1 == NULL, go to 1
        lw s2, 0(a0)           # s2 <= *s1 (VAL1)
        lw s3, 4(a0)           # s3 <= *(s1 + 4) (VAL2)
        add s2, s2, s3         # s2 <= s2 + s3

        beq s2, a1, 2f         # if s2 == a1, go to 2

        addi t0, t0, 1
        lw a0, 8(a0)           # s1 <= *(s1 + 8)  (pointer to the next node)
        lw s1, 0(a0)           # s1 <= *s1

        j 1b

    2:
    mv a0, t0
    j 1f

    3:
    li a0, -1

    1:
    ret