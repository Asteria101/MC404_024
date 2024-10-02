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
    add t0, a2, a3          # i: t0, t0 <= a2 + a3, t0: stores the memory address of the current byte
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


readImage:
    # returns a0: position where the image matrix starts and stores the width and height values in s0 and s1, respectively

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

    mv a0, a1           # a0 <= a1
    add a0, a0, 5       # a0 <= a0 + 5, a0: stores the position where the dimensions end, then it adds 5 to get to the start of the image matrix

    lw ra, 0(sp)   
    addi sp, sp, 16
    ret    


getColourPixel:
    # a0: byte to be manipulated
    mv t4, a0           # t4: copy of byte a0 to get the green
    mv t5, a0           # t5: copy of byte a0 to get the blue
    slli a0, a0, 24     # shifting for red colour
    slli t4, t4, 16     # shifting for green colour
    slli t5, t5, 8      # shifting for blue colour

    add a0, a0, t4
    add a0, a0, t5
    addi a0, a0, MAXVAL # alpha value
    ret


setCanvasSize:
    li a7, 2201   # syscall setCanvasSize
    ecall
    ret


setPixel:
    li a7, 2200   # syscall setPixel (2200)
    ecall
    ret

setScalling:
    li a7, 2202   # syscall setScalling
    ecall
    ret


setKernelBorder:
    # a0: index j (column) of the matrix
    # a1: index i (row) of the matrix
    addi sp, sp, -16
    sw ra, 0(sp)

    li a2, 255 # black colour
    jal setPixel

    lw ra, 0(sp)   
    addi sp, sp, 16
    ret


main:
    addi sp, sp, -16
    sw ra, 0(sp)

    jal readImage
    mv s2, a0           # s2: stores the position where the image matrix starts, s2 <= a0

    mv a0, s0           # a0 <= s0
    mv a1, s1           # a1 <= s1
    jal setCanvasSize

    # loop to go through image matrix
        # i: t0, t0 runs through height
        # j: t1, t1 runs through width
        # x: t3, t3 runs through the image matrix indeces
    li t0, 0
    li t3, 0 

    2:
        li t1, 0
        beq t0, s1, 2f

        mul t2, s0, s1
        bge t3, t2, 2f
        3:
            beq t1, s0, 3f

            add t2, s2, t3      # t2: stores the memory address of the current pixel in the image matrix
            lbu t2, 0(t2)       # stores the byte in t2 for further manipulation

            mv a0, t2
            jal getColourPixel  # get the colour of the pixel
            mv t2, a0

            # check if the pixel is in the borders and turn it into black
            li t4, 0
            bne t0, t4, 4f
            mv a0, t1
            mv a1, t0
            jal setKernelBorder
            j cont

            4:
            bne t1, t4, 5f
            mv a0, t1
            mv a1, t0
            jal setKernelBorder
            j cont

            5:
            addi t4, s0, -1
            bne t1, t4, 6f
            mv a0, t1
            mv a1, t0
            jal setKernelBorder
            j cont

            6:
            addi t4, s1, -1
            bne t0, t4, 7f
            
            mv a0, t1
            mv a1, t0
            jal setKernelBorder
            j cont

            7:
            # print pixel
            mv a0, t1
            mv a1, t0
            mv a2, t2
            jal setPixel

            cont:
                addi t1, t1, 1
                addi t3, t3, 1
                j 3b
        3:
            addi t0, t0, 1
            j 2b
    2:

    li a0, 4
    li a1, 2
    jal setScalling

    lw ra, 0(sp)   
    addi sp, sp, 16
    ret


.section .data
input_file: .asciz "image.pgm"
data: .skip 0x4000f