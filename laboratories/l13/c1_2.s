
/*
Caller-saved registers: t0-t6, a0-a7 and ra
*/

.text
.globl my_function
my_function:
    # a0 has int a
    # a1 has int b
    # a2 has int c

    addi sp, sp, -16
    sw ra, (sp)
    sw a0, 4(sp) # holds a
    sw a1, 8(sp) # holds b
    sw a2, 12(sp) # holds c

    # CALL 1
    add a0, a0, a1 # a0 <- a0 + a1 (a + b)
    lw a1, 4(sp) # a1 <- a
    jal mystery_function
    # return value in a0

    # calculate aux
    lw t0, 8(sp) # t0 <- b
    lw t1, 12(sp) # t1 <- c
    sub a0, t0, a0 # a0 <- b - a0
    add a0, a0, t1 # a0 <- a0 + c

    sw a0, 4(sp) # store aux, because we wont use the space where a was stacked

    # CALL 2
    mv a1, t0 # a1 <- b
    jal mystery_function
    
    lw t0, 12(sp)
    sub a0, t0, a0 # a0 <- c - a0
    lw t1, 4(sp)
    add a0, a0, t1 # a0 <- a0 + aux

    lw ra, (sp)
    addi sp, sp, 16
    ret
