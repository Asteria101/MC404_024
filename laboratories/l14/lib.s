
.data
.globl _system_time
_system_time: .word

.bss
.align 4
isr_stack: .skip 1024
isr_stack_end:


.text
.align 2
.set GPT_BASE_MEMORY, 0xFFFF0100
.set MIDI_BASE_MEMORY, 0xFFFF0300

.globl _start
.globl play_note

_start:

    # set interrupts
    la t0, isr_stack_end
    csrw mscratch, t0

    la t0, main_isr
    csrw mtvec, t0
    
    li t0, 0x800
    csrs mie, t0

    csrrsi zero, mstatus, 0x8

    li t0, GPT_BASE_MEMORY
    li t1, 100
    sw t1, 0x8(t0)

    jal main

    li a0, 0
    li a7, 93
    ecall


main_isr:

    # save the context
    csrrw sp, mscratch, sp
    addi sp, sp, -96
    sw ra, (sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    sw a4, 20(sp)
    sw a5, 24(sp)
    sw a6, 28(sp)
    sw a7, 32(sp)
    sw s0, 36(sp)
    sw s1, 40(sp)
    sw s2, 44(sp)
    sw s3, 48(sp)
    sw s4, 52(sp)
    sw s5, 56(sp)
    sw s6, 60(sp)
    sw s7, 64(sp)
    sw s8, 68(sp)
    sw s9, 72(sp)
    sw s10, 76(sp)
    sw s11, 80(sp)

    # implement interrupt handling
    li t0, GPT_BASE_MEMORY
    li t1, 1
    sb t1, (t0)

    0:
        lb t1, (t0)
        beqz t1, 0f
        j 0b
    0:

    lw t1, 0x4(t0)
    la t2, _system_time
    sw t1, (t2)

    li t1, 100
    sw t1, 0x8(t0)

    # restore the context
    lw ra, (sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    lw a3, 16(sp)
    lw a4, 20(sp)
    lw a5, 24(sp)
    lw a6, 28(sp)
    lw a7, 32(sp)
    lw s0, 36(sp)
    lw s1, 40(sp)
    lw s2, 44(sp)
    lw s3, 48(sp)
    lw s4, 52(sp)
    lw s5, 56(sp)
    lw s6, 60(sp)
    lw s7, 64(sp)
    lw s8, 68(sp)
    lw s9, 72(sp)
    lw s10, 76(sp)
    lw s11, 80(sp)
    addi sp, sp, 96
    csrrw sp, mscratch, sp
    
    mret


play_note:

    # a0: int ch (channel)
    # a1: int inst (instrument ID)
    # a2: int note (musical note)
    # a3: int vel (note velocity)
    # a4: int dur (nite duration)
    li t0, MIDI_BASE_MEMORY
    sh a4, 6(t0)
    sb a3, 5(t0)
    sb a2, 4(t0)
    sh a1, 2(t0)
    sb a0, (t0)

    ret