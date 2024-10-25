
.text

.globl operation

operation:
    # save to temporary registers  n to i
    lw t5, (sp) # i
    lw t4, 4(sp) # j
    lw t3, 8(sp) # k
    lw t2, 12(sp) # l
    lw t1, 16(sp) # m
    lw t0, 20(sp) # n

    # save ra
    addi sp, sp, -16
    sw ra, (sp)

    # store params from a to f in sp 
    addi sp, sp, -32
    sw a0, 20(sp) # a
    sw a1, 16(sp) # b
    sw a2, 12(sp) # c
    sw a3, 8(sp) # d
    sw a4, 4(sp) # e
    sw a5, (sp) # f
    
    mv t6, a6 # store g in t6

    # n, m, l, k, j, i
    mv a0, t0
    mv a1, t1
    mv a2, t2
    mv a3, t3
    mv a4, t4
    mv a5, t5
    mv a6, a7 # h
    mv a7, t6
    jal mystery_function

    addi sp, sp, 32

    lw ra, (sp)
    addi sp, sp, 16
    ret