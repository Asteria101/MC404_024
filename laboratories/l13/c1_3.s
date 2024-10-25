
.text

.globl operation

operation:
    addi sp, sp, -16
    sw ra, (sp)

    li a0, 1 # int a
    li a1, -2 # int b
    li a2, 3 # short c
    li a3, -4 # short d
    li a4, 5 # char e
    li a5, -6 # char f
    li a6, 7 # int g
    li a7, -8 # int h 

    # load other params
    addi sp, sp, -24
    li t0, -14 # int n
    sw t0, 20(sp)

    li t0, 13 # int m
    sw t0, 16(sp)

    li t0, -12 # short l 
    sw t0, 12(sp)

    li t0, 11 # short k 
    sw t0, 8(sp)

    li t0, -10 # char j
    sw t0, 4(sp)

    li t0, 9 # char i
    sw t0, (sp)

    jal mystery_function
    addi sp, sp, 24

    lw ra, (sp)
    addi sp, sp, 16
    ret
