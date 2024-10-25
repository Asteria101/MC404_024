
.text
.globl fill_array_int
.globl fill_array_short
.globl fill_array_char


fill_array_int:
    addi sp, sp, -404 # store space for 100 int 
    sw fp, (sp)
    mv fp, sp # so ra will also be where fp points

    li t0, 0
    0:
        li t1, 100
        bge t0, t1, 0f

        slli t1, t0, 2 # offset for sizeof(int)
        add t1, fp, t1 
        sw t0, (t1)
        addi t0, t0, 1
        j 0b
    0:

    mv a0, fp
    jal mystery_function_int

    lw fp, (sp)
    addi sp, sp, 404
    ret

fill_array_short:
    addi sp, sp, -204 # store space for 100 int 
    sw fp, (sp)
    mv fp, sp # so ra will also be where fp points

    li t0, 0
    0:
        li t1, 100
        bge t0, t1, 0f

        slli t1, t0, 1 # offset for sizeof(int)
        add t1, fp, t1 
        sh t0, (t1)
        addi t0, t0, 1
        j 0b
    0:

    mv a0, fp
    jal mystery_function_short

    lw fp, (sp)
    addi sp, sp, 204
    ret

fill_array_char:
    addi sp, sp, -104 # store space for 100 int 
    sw fp, (sp)
    mv fp, sp # so ra will also be where fp points

    li t0, 0
    0:
        li t1, 100
        bge t0, t1, 0f

        add t1, fp, t1 
        sb t0, (t1)
        addi t0, t0, 1
        j 0b
    0:

    mv a0, fp
    jal mystery_function_char

    lw fp, (sp)
    addi sp, sp, 104
    ret