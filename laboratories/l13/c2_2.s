
.text

.globl middle_value_int
.globl middle_value_short
.globl middle_value_char
.globl value_matrix

middle_value_int:
    # a0: int *array
    # a1: int n
    srai t0, a1, 1
    slli t0, t0, 2 # hit sizeof int
    add t0, a0, t0
    lw a0, (t0)
    ret

middle_value_short:
    # a0: int *array
    # a1: int n
    srai t0, a1, 1
    slli t0, t0, 1
    add t0, a0, t0
    lh a0, (t0)
    ret

middle_value_char:
    # a0: int *array
    # a1: int n
    srai t0, a1, 1
    add t0, a0, t0
    lb a0, (t0)
    ret

value_matrix:
    # a0: int matrix[12][42]
    # a1: int r
    # a2: int c

    # r = 6: To reach the sixth row, you need to reach 42 spaces 6 times

    li t0, 42
    mul t0, a1, t0
    add t0, t0, a2
    slli t0, t0, 2 # So you work with sizeof int
    add t0, t0, a0
    lw a0, (t0)
    ret

