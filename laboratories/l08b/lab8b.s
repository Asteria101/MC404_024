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
    la a1, input_image   # adress for the buffer
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

    la a2, input_image     # a2: stores the memory address of the first byte of the image

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
    # a1: byte to be manipulated
    # t0: copy of byte a1 to get the green
    # t1: copy of byte a1 to get the blue
    mv t0, a1
    mv t1, a1
    slli a1, a1, 24     # shifting for red colour
    slli t0, t0, 16     # shifting for green colour
    slli t1, t1, 8      # shifting for blue colour

    add a1, a1, t0
    add a1, a1, t1
    addi a1, a1, MAXVAL # alpha value

    li t0, 0
    bge a1, t0, 1f           # if a1 >= 0, go to 1
    li a1, 0
    1:
        li t0, MAXVAL
        blt a1, t0, 2f  # if a1 < MAXVAL, go to 2
        li a1, MAXVAL
    2:

    ret


processPixel:
    addi sp, sp, -16
    sw ra, 0(sp)
    
    # a0: memory address of the first pixel
    # s0: width value of the image
    # the processing of the pixel begins for the 
    # first pixel in the image matrix that isnt in the borders
    # 1 2 3
    # 4 x 5  -> x: pixel to be processed, {1...8} are the neighbours
    # 6 7 8

    # pixel 1:
    sub t0, a0, s0
    addi t0, t0, -1
    lbu t0, 0(t0)

    mv a1, t0
    jal getColourPixel
    mv t0, a1

    li t1, -1
    mul t2, t0, t1

    # pixel 2:
    sub t0, a0, s0
    lbu t0, 0(t0)
    mv a1, t0
    jal getColourPixel
    mv t0, a1
    li t1, -1
    mul t0, t0, t1
    add t2, t2, t0

    # pixel 3:
    sub t0, a0, s0
    addi t0, t0, 1
    lbu t0, 0(t0)
    mv a1, t0
    jal getColourPixel
    mv t0, a1
    li t1, -1
    mul t0, t0, t1
    add t2, t2, t0

    # pixel 4:
    addi t0, a0, -1
    lbu t0, 0(t0)
    mv a1, t0
    jal getColourPixel
    mv t0, a1
    li t1, -1
    mul t0, t0, t1
    add t2, t2, t0

    # pixel x:
    lbu t0, 0(a0)
    mv a1, t0
    jal getColourPixel
    mv t0, a1
    li t1, 8
    mul t0, t0, t1
    add t2, t2, t0

    # pixel 5:
    addi t0, a0, 1
    lbu t0, 0(t0)
    mv a1, t0
    jal getColourPixel
    mv t0, a1
    li t1, -1
    mul t0, t0, t1
    add t2, t2, t0

    # pixel 6:
    add t0, a0, s0
    addi t0, t0, -1
    lbu t0, 0(t0)
    mv a1, t0
    jal getColourPixel
    mv t0, a1
    li t1, -1
    mul t0, t0, t1
    add t2, t2, t0

    # pixel 7:
    add t0, a0, s0
    lbu t0, 0(t0)
    mv a1, t0
    jal getColourPixel
    mv t0, a1
    li t1, -1
    mul t0, t0, t1
    add t2, t2, t0

    # pixel 8:
    add t0, a0, s0
    addi t0, t0, 1
    lbu t0, 0(t0)
    mv a1, t0
    jal getColourPixel
    mv t0, a1
    li t1, -1
    mul t0, t0, t1
    add t2, t2, t0

    mv a0, t2 # a0: stores the new colour of the pixel

    lw ra, 0(sp)   
    addi sp, sp, 16
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




initializeImage:
    # s0: width
    # s1: height
    # s2: address of the image

    # loop to go through image matrix
        # i: t0, t0 runs through height
        # j: t1, t1 runs through width
        # x: t2, t2 runs through the image matrix indeces

    addi sp, sp, -16
    sw ra, 0(sp)

    li t0, 0
    li t2, 0 

    1:
        beq t0, s1, 1f

        li t1, 0

        mul t3, s0, s1
        bge t2, t3, 1f
        2:
            beq t1, s0, 2f

            add t3, s2, t2      # t3: stores the memory address of the current pixel in the image matrix

            addi sp, sp, -12
            sw t0, 8(sp)
            sw t1, 4(sp)
            sw t2, 0(sp)
            mv a0, t3
            jal processPixel
            mv t3, a0
            lw t2, 0(sp)
            lw t1, 4(sp)
            lw t0, 8(sp)
            addi sp, sp, 12

            mv a0, t1
            mv a1, t0
            mv a2, t3
            jal setPixel

            addi t1, t1, 1
            addi t2, t2, 1
            j 2b

        2:
            addi t0, t0, 1
            j 1b
    1:

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

    jal initializeImage

    # Now that the input image has been processed, we can move on to producing the output image

    li a0, 4
    li a1, 2
    jal setScalling

    lw ra, 0(sp)   
    addi sp, sp, 16
    ret


.section .data
input_file: .asciz "image.pgm"
input_image: .skip 0x4000f