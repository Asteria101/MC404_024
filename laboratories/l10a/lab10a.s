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


gets:
    # a0: buffer pointer
    # returns: null-terminated string (a0: buffer pointer)

    mv a3, a0
    mv a1, a0
    li a0, 0             # file descriptor
    li a2, 1000000       # buffer size
    li a7, 63            # syscall read
    ecall
    #add t0, a0, a3
    #addi t0, t0, -1
    #sb zero, (t0)

    mv a0, a3
    ret


puts:
    # a0: buffer pointer
    # returns: void

    mv a1, a0            # buffer pointer
    li a2, 1
    1:
        lbu t1, (a1)
        beq t1, zero, 1f
        addi a2, a2, 1
        addi a1, a1, 1
        j 1b
    1:
    li t1, '\n'
    sb t1, (a1)

    mv a1, a0
    li a0, 1             # file descriptor
    li a7, 64            # syscall write
    ecall

    sb zero, (a1)

    ret


atoi:
    # Turns a string into a signed integer
    # a0: buffer pointer
    # returns: integer (a0)

    li t2, 1                 # t2 <= 1, for the signal
    li a2, 0                 # a2 <= 0, stores the number
    mv a1, a0

    li t1, '-'           # t1 <= '-'
    lbu t0, (a1)
    bne t0, t1, 1f       # if t0 != '-', go to 1
    li t2, -1            # t2 <= -1
    addi a1, a1, 1

    1:
        lbu t0, (a1)        # t0 <= char
        li t1, '\n'
        beq t0, t1, 1f
        beq t0, zero, 1f     # if t0 == NULL, go to 1

        li t1, 10            # t1 <= 10
        addi t0, t0, -48     # t0 <= t0 - '0'
        add a2, a2, t0       # a2 <= a2 + t0
        mul a2, a2, t1       # a2 <= a2 * 10

        addi a1, a1, 1
        j 1b
    1:

    div a2, a2, t1       # a2 <= a2 / 10
    mul a0, a2, t2       # a0 <= a2 * t2 signal

    ret


itoa:
    # Turns a signed integer into a string
    # a0: has the number
    # a1: has the buffer addres
    # a2: has the base to be converted

    # returns: the buffer pointer (a0)

    mv t0, a1 # &buffer

    li t4, 0 # inicial buffer index

    # Treat negative numbers
    bge a0, zero, positive # t1 >= 0 go to positive
    li t1, '-'
    sb t1, (t0) # store minus signal
    li t1, -1
    mul a0, a0, t1 # a0 *= -1
    addi t0, t0, 1 # buffer++
    li t4, 1 # inicial buffer index


    positive:

    # Count number of digits
    li t1, 0 # counter
    li t2, 10 # base 10
    mv t3, a0 # t3 <= a0
    1:
    addi t1, t1, 1 # t1++
    div t3, t3, t2 # t3 /= 10

    beq t3, zero, 1f
    j 1b

    1:
    add t0, t0, t1 # last index of buffer
    addi t0, t0, 1 # includes the null terminator
    sb zero, (t0) # adds null terminator
    addi t0, t0, -1 # t0--

    addi t1, t1, -1 # t1--, removes 1 because condition is checked afterwards

    # Add number to buffer
    2:
        rem t2, a0, a2 # t2 <= a0 % base

        li t3, 10
        blt t2, t3, 3f # if t2 <= 9, go to 3

        # range A to F
        sub t2, t2, t3 # t2 -= 10
        addi t2, t2, 'A' # t2 += 'A'
        j 4f

        3:
        # range 0 to 9
        addi t2, t2, 48 # t2 += '0'

        4:
        sb t2, (t0) # store number
        div a0, a0, a2

        bge t4, t1, 2f # if t4 >= t2, break
        addi t0, t0, -1 # t0--
        addi t1, t1, -1 # t1--
        j 2b

    2:
    mv a0, t0

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