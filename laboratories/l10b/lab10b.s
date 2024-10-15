.globl exit
.globl puts
.globl gets
.globl atoi
.globl itoa
.globl recursive_tree_search


exit:
    # a0: has the return code for the exit 
    li a7, 93
    ecall
    ret


gets:
    # This function gets char per char until it reaches a newline
    # a0: buffer pointer
    # returns: null-terminated string (a0: buffer pointer)

    addi sp, sp, -16
    sw a0, (sp)              # store buffer pointer

    mv a3, a0
    1:
        li a0, 0
        mv a1, a3
        li a2, 1
        li a7, 63            # syscall read
        ecall
        
        li t0, '\n'
        lb t1, (a1)
        beq t1, t0, 1f
        sb t1, (a3)
        addi a3, a3, 1
        j 1b

    1:
    sb zero, (a3)
    lw a0, (sp)
    addi sp, sp, 16

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

    li t1, '-'               # t1 <= '-'
    lbu t0, (a1)
    bne t0, t1, 1f           # if t0 != '-', go to 1
    li t2, -1                # t2 <= -1
    addi a1, a1, 1

    1:
        lbu t0, (a1)         # t0 <= char
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

    div a2, a2, t1           # a2 <= a2 / 10
    mul a0, a2, t2           # a0 <= a2 * t2 signal

    ret
    

itoa:
    # Turns a signed integer into a string
    # a0: has the number
    # a1: has the buffer addres
    # a2: has the base to be converted

    # returns: the buffer pointer (a0)

    mv t0, a1 # &buffer

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
    add t0, a1, t1 # last index of buffer

    addi t0, t0, 1 # includes the null terminator
    sb zero, (t0) # adds null terminator
    addi t0, t0, -1 # t0--

    addi t1, t1, -1 # t1--, removes 1 because condition is checked afterwards

    # Add number to buffer
    2:
        rem t2, a0, a2 # t2 <= a0 % base
        addi t2, t2, 48 # t2 += '0'
        sb t2, (t0) # store number
        div a0, a0, a2

        bge zero, t1, 2f # if 0 >= t2, break
        addi t0, t0, -1 # t0--
        addi t1, t1, -1 # t1--
        j 2b

    2:
    mv a0, t0
    ret


recursive_tree_search:
    # Operates a recursive search on a binary tree
    # a0: has the root of the tree
    # a1: has the value to be searched

    # returns: the depth of the tree, 0 otherwise (a0)

    addi sp, sp, -8
    sw ra, 4(sp)
    sw fp, (sp)

    addi fp, sp, 8
    sw ra, (fp)
    li a2, 0 # depth

    addi sp, sp, -4
    sw a0, (sp)

    # It is like this is a new function that contains the 
    # same parameters as recursive_tree_search, but also 
    # the node depth (a2)
    depth_first_search:
        lw a0, (sp) # load root of the tree
        addi sp, sp, -4 
        sw ra, (sp) # store return address for recursive_tree_search

        addi a2, a2, 1 # depth++
        
        lw t0, 0(a0) # load node->val
        beq a1, t0, found # if node->val == val, found

        lw t0, 4(a0) # load node->left
        beq t0, zero, search_right # if node->left == NULL, search_right

        # search left
        addi sp, sp, -4
        sw t0, (sp) # store node->left
        jal depth_first_search

        search_right:
        lw a0, 4(sp)
        lw t1, 8(a0) # load node->right

        beq t1, zero, not_found # if node->right == NULL, not_found

        addi sp, sp, -4
        sw t1, (sp) # store node->right
        jal depth_first_search  


        not_found:
            lw ra, (sp)
            addi sp, sp, 8
            addi a2, a2, -1 # depth--
            beq a2, zero, found
            ret

    found:
        lw ra, (fp)
        mv a0, a2
        ret
