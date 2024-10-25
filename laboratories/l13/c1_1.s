
.data
.globl my_var  
my_var: .word 10

.text
.globl increment_my_var

increment_my_var:
    la a0, my_var
    lw t0, (a0) # load my_var into t0
    addi t0, t0, 1 # increment t0, t0++
    sw t0, (a0) # store t0 back into my_var
    ret
