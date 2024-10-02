.section .text
.globl _start
.equ MAXVAL, 255

_start:
    jal main
    jal exit

exit:
    li a0, 0    # return code
    li a7, 93   # syscall exit
    ecall 
    ret

open:
    la a0, input_file   # adress for the file path
    li a1, 0            # flags
    li a2, 0            # mode
    li a7, 1024         # syscall open
    ecall
    ret

read:
    mv a0, a6            # file descriptor
    la a1, data          # adress for the buffer
    li a2, 0x4000f       # buffer size
    li a7, 63            # syscall read
    ecall
    ret

close:
    mv a0, a6            # file descriptor
    li a7, 57            # syscall close
    ecall
    ret

treatHeader:
    # return a0: dimension, a1: final position

    la a2, data

    # read width and height
    # a3: start index in header
    add t0, a2, a3          # i: t0, t0 <= a2 + a3
    li a0, 0                # a0 <= 0
    1:
        lbu t3, 0(t0)       # read byte
        li t1, ' '          # delimiter: t1, t1 <= ' '
        beq t3, t1, 1f      # if reaches a space, go to 2

        li t2, '\n'         # end of line: t2, t2 <= '\n'
        beq t3, t2, 1f      # if end of line, go to 2

        li t1, 10           # t1 <= 10
        addi t3, t3, -48    # t3 <= t3 - '0'
        add a0, a0, t3      # a0 <= a0 + t3
        mul a0, a0, t1      # a0 <= a0 * 10

        addi t0, t0, 1
        j 1b

    1:
    li t1, 10
    div a0, a0, t1          # a0 <= a0 / 10
    mv a1, t0               # a1 <= t0
    ret

setCanvasSize:
    mv a0, a2     # canvas width
    mv a1, a3     # canvas height
    li a7, 2201   # syscall setCanvasSize
    ecall
    ret

setPixel:
    mv a0, a3   # x coordinate
    mv a1, a4   # y coordinate
    mv a2, a5   # colour pixel
    li a7, 2200 # syscall setPixel (2200)
    ecall
    ret


main:
    addi sp, sp, -16
    sw ra, 0(sp)

    jal open
    mv a6, a0           # store file descriptor
    jal read            # read file
    jal close           # close file

    li a3, 3            # a3: start index in header, a3 <= 3
    jal treatHeader
    mv s0, a0           # s0: stores width, s0 <= a0

    mv a3, a1           # a3 <= a1
    sub a3, a3, a2      # a3 <= a3 - a2
    addi a3, a3, 1      # a3 <= a3 + 1
    jal treatHeader
    mv s1, a0           # s1: stores height, s1 <= a0
    mv s2, a1           # s2: stores the address pointer where the line
                        # containing the dimensions end, s2 <= a0
    add s2, s2, 5

    mv a2, s0           # a2 <= s0
    mv a3, s1           # a3 <= s1
    jal setCanvasSize

    # loop to go through image matrix
    # i: t0, t0 runs through height
    # j: t1, t1 runs through width
    li t0, 0
    li t5, 0 # variable for going through the image matrix

    mul t6, s0, s1

    2:
        li t1, 0
        beq t0, s1, 2f
        bge t5, t6, 2f
        3:
            beq t1, s0, 3f

            add t2, s2, t5
            lbu t2, 0(t2)       # stores the byte in t2 for further manipulation
            mv t3, t2           # green
            mv t4, t2           # blue
            slli t2, t2, 24     # shifting for red colour
            slli t3, t3, 16     # shifting for green colour
            slli t4, t4, 8      # shifting for blue colour
            add t2, t2, t3
            add t2, t2, t4
            addi t2, t2, 255 # alpha value

            mv a3, t1
            mv a4, t0
            mv a5, t2
            jal setPixel

            addi t1, t1, 1
            addi t5, t5, 1
            j 3b
        3:
            addi t0, t0, 1
            j 2b
    2:

    lw ra, 0(sp)   
    addi sp, sp, 16
    ret


.section .data
input_file: .asciz "image.pgm"
data: .skip 0x4000f