
.data
x: .word 0
y: .word 0
z: .word 0

.bss
.align 4
user_stack: .skip 1024
user_stack_end:

.text
.align 2
.set CAR_BASE_MEMORY, 0xFFFF0100

int_handler:
    ###### Syscall and Interrupts handler ######
    csrrw sp, mscratch, sp
    addi sp, sp, -80
    sw ra, (sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)
    sw t0, 52(sp)
    sw t1, 56(sp)
    sw t2, 60(sp)
    sw t3, 64(sp)

    # <= Implement your syscall handler here
    li t0, 10
    beq a7, t0, syscall_set_engine_and_steering
    li t0, 11
    beq a7, t0, syscall_set_hand_brake
    j 0f

    syscall_set_engine_and_steering:
        li t0, 2
        bge a0, t0, error
        li t0, -1
        blt a0, t0, error
        li t0, 128
        bge a1, t0, error
        li t0, -127
        blt a1, t0, error

        li t0, CAR_BASE_MEMORY
        sb a1, 0x20(t0)
        sb a0, 0x21(t0)
        li a0, 0
        j 0f

        error:
        li a0, -1
        j 0f

    syscall_set_hand_brake:
        li t0, CAR_BASE_MEMORY
        sb a0, 0x22(t0)
        j 0f


    # restore the context
    0:
        lw t3, 64(sp)
        lw t2, 60(sp)
        lw t1, 56(sp)
        lw t0, 52(sp)
        lw s11, 48(sp)
        lw s10, 44(sp)
        lw s9, 40(sp)
        lw s8, 36(sp)
        lw s7, 32(sp)
        lw s6, 28(sp)
        lw s5, 24(sp)
        lw s4, 20(sp)
        lw s3, 16(sp)
        lw s2, 12(sp)
        lw s1, 8(sp)
        lw s0, 4(sp)
        lw ra, (sp)
        addi sp, sp, 80
        csrrw sp, mscratch, sp

    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0
    mret


.globl _start
_start:

    la t0, user_stack_end
    csrw mscratch, t0

    la t0, int_handler
    csrw mtvec, t0

    csrr t0, mstatus
    li t1, ~0x1800
    and t0, t0, t1
    csrw mstatus, t0

    la t0, user_main
    csrw mepc, t0
    mret


.globl control_logic
control_logic:
    # implement your control logic here, using only the defined syscalls

    # Go forward and to the left 30 degrees
    li t1, 1900
    li t2, 0
    0:
    li a0, 1
    li a1, 0
    li a7, 10
    ecall

    li a0, 1
    li a1, -33
    li a7, 10
    ecall

    beq t2, t1, 0f
    addi t2, t2, 1
    j 0b
    0:

    li a0, 1
    li a7, 11
    ecall

    li a0, 0
    li a1, 0
    li a7, 10
    ecall
            
    li a0, 0
    li a7, 93
    ecall
    ret