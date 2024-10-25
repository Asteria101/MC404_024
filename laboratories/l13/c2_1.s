
.text

.globl swap_int
.globl swap_short
.globl swap_char

swap_int:
    # a0: int *a
    # a1: int *b
    lw t0, (a0)
    lw t1, (a1)
    sw t1, (a0)
    sw t0, (a1)
    li a0, 0
    ret

swap_short:
    # a0: int *a
    # a1: int *b
    lh t0, (a0)
    lh t1, (a1)
    sh t1, (a0)
    sh t0, (a1)
    li a0, 0
    ret

swap_char:
    # a0: int *a
    # a1: int *b
    lb t0, (a0)
    lb t1, (a1)
    sb t1, (a0)
    sb t0, (a1)
    li a0, 0
    ret