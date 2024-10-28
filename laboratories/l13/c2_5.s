
/*
struct shape
node->a (a0)
[   ]
[   ]
[   ]
[   ]
node->b 4(a0)
[   ]
node->c 5(a0)
[   ]
node->d 6(a0)
[   ]
[   ]
*/

.text
.globl node_creation

node_creation:
    addi sp, sp, -32
    sw ra, 4(sp)
    sw fp, (sp)
    addi fp, sp, 8

    li t0, -12
    sh t0, 6(fp) # node.d
    li t0, 64
    sb t0, 5(fp) # node.c
    li t0, 25
    sb t0, 4(fp) # node.b
    li t0, 30
    sw t0, (fp)

    mv a0, fp
    jal mystery_function

    lw fp, (sp)
    lw ra, 4(sp)
    addi sp, sp, 32
    ret

/*
a (sp)
[]
[]
[]
[]
b 4(sp)
[]
c 5 (sp)
[]
d 6(sp)
[]
[]
fp 8(sp)
[]
[]
[]
[]
*/