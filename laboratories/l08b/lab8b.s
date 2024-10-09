.section .text
.globl _start

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


getImageAddress:
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
    # t0: byte left shifted for red
    # t1: byte left shifted for green
    # t2: byte left shifted for blue

    # return pixel colour in gray scale in a0

    slli t0, a1, 24     # shifting for red colour
    slli t1, a1, 16     # shifting for green colour
    slli t2, a1, 8      # shifting for blue colour
    
    add a0, t0, t1
    add a0, a0, t2
    addi a0, a0, 0xff # alpha value

    ret


applyFilter:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw s2, 0(sp)
    # s3: i row index
    # s4: j column index
    # a0: memory address of the pixel from input image

    # 1 2 3
    # 4 x 5  -> x: pixel to be processed, {1...8} are the neighbours
    # 6 7 8

    li s2, 0x0          # s2: stores the sum of the pixel values
    
    sub a0, a0, s0      # a0: memory address of the pixel 1

    # pixels 1, 2 and 3
    lbu t0, -1(a0)       # read pixel 1
    lbu t1, 0(a0)       # read pixel 2
    add t0, t0, t1      # t0 <= t0 + t1
    lbu t1, 1(a0)       # read pixel 3
    add s2, t0, t1      # s2 <= t0 + t1
    li t0, -1
    mul s2, s2, t0      # s2 <= s2 * -1
    add a0, a0, s0

    # pixels 4 and 5
    lbu t0, -1(a0)       # read pixel 4
    lbu t1, 1(a0)       # read pixel 5
    add t2, t1, t0      # t2 <= t1 + t0
    li t0, -1
    mul t2, t2, t0      # t2 <= t2 * -1
    add s2, s2, t2      # s2 <= s2 + t2

    # read pixel x
    lbu t0, 0(a0)
    li t1, 8
    mul t0, t0, t1      # t0 <= t0 * 8
    add s2, s2, t0      # s2 <= s2 + t0
    
    add a0, a0, s0      # a0 <= a0 + s0

    # pixels 6, 7 and 8
    lbu t0, -1(a0)       # read pixel 6
    lbu t1, 0(a0)       # read pixel 7
    add t0, t0, t1      # t0 <= t0 + t1
    lbu t1, 1(a0)       # read pixel 8
    add t0, t0, t1      # t0 <= t0 + t1
    li t1, -1
    mul t0, t0, t1      # t0 <= t0 * -1
    add s2, s2, t0      # s2 <= s2 + t0

    # set pixel
    li t0, 0xff
    blt t0, s2, 2f      # if 0xff < s2, go to 2
    blt s2, zero, 3f    # if s2 < 0, go to 3
    mv a0, s2
    j 4f

    3:
    li a0, 0x0
    j 4f

    2:
    li a0, 0x000000ff

    4:
    lw s2, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8
    ret


processImage:
    # s0: width
    # s1: height
    # s2: address of the beginning of the image

    # loop to go through image matrix
    # i: s3, s3 runs through height
    # j: s4, s4 runs through width

    addi sp, sp, -16
    sw ra, 0(sp)

    li s3, 0        # i: s3 <= 0

    1:
        beq s3, s1, 1f          # if ir reaches the last row, go to 1
        li s4, 0                # j: s4 <= 0
        2:
            beq s4, s0, 2f      # if it reaches the last column, go to 2
            # set border pixels
            li t1, 0
            beq s3, t1, 3f
            beq s4, t1, 3f
            addi t1, s0, -1
            beq s4, t1, 3f
            addi t1, s1, -1
            beq s3, t1, 3f

            mv a0, s2
            jal applyFilter
            mv a2, a0
            mv a1, a2
            jal getColourPixel
            mv a2, a0
            j 4f

            3:
            li a2, 0x000000ff

            4:
            mv a0, s4
            mv a1, s3
            li a7, 2200         # syscall setPixel (2200)
            ecall

            addi s4, s4, 1
            addi s2, s2, 1
            j 2b

        2:
            addi s3, s3, 1
            j 1b
    1:

    lw ra, 0(sp)   
    addi sp, sp, 16
    ret


main:
    addi sp, sp, -16
    sw ra, 0(sp)

    jal getImageAddress
    mv s2, a0           # s2: stores the position where the image matrix starts, s2 <= a0

    mv a0, s0           # a0 <= s0
    mv a1, s1           # a1 <= s1
    li a7, 2201         # syscall setCanvasSize
    ecall

    jal processImage

    lw ra, 0(sp)   
    addi sp, sp, 16
    ret


.section .data
input_file: .asciz "image.pgm"
input_image: .skip 0x4000f