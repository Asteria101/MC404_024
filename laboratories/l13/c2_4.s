
.text
.globl node_op

node_op:
    # a0: Node *node
    lw t0, (a0) # node->a
    lb t1, 4(a0) # node->b
    add t0, t0, t1

    lb t1, 5(a0) # node->c
    sub t0, t0, t1

    lh t1, 6(a0) # node->d
    add t0, t0, t1

    mv a0, t0
    ret


/*
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