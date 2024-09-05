	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"lab03.c"
	.globl	read
	.p2align	2
	.type	read,@function
read:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 63	# syscall write code (63) 
	ecall		# invoke syscall 
	mv	a3, a0	# move return value to ret_val

	#NO_APP
	sw	a3, -28(s0)
	lw	a0, -28(s0)
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	read, .Lfunc_end0-read

	.globl	write
	.p2align	2
	.type	write,@function
write:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 64	# syscall write (64) 
	ecall	
	#NO_APP
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	write, .Lfunc_end1-write

	.globl	power
	.p2align	2
	.type	power,@function
power:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -20(s0)
	sw	a1, -24(s0)
	lui	a0, 261888
	sw	a0, -28(s0)
	li	a1, 0
	sw	a1, -32(s0)
	lw	a0, -24(s0)
	bne	a0, a1, .LBB2_2
	j	.LBB2_1
.LBB2_1:
	lui	a0, 261888
	sw	a0, -12(s0)
	li	a0, 0
	sw	a0, -16(s0)
	j	.LBB2_7
.LBB2_2:
	li	a0, 0
	sw	a0, -36(s0)
	j	.LBB2_3
.LBB2_3:
	lw	a0, -36(s0)
	lw	a1, -24(s0)
	bge	a0, a1, .LBB2_6
	j	.LBB2_4
.LBB2_4:
	lw	a0, -20(s0)
	fcvt.d.w	ft1, a0
	fld	ft0, -32(s0)
	fmul.d	ft0, ft0, ft1
	fsd	ft0, -32(s0)
	j	.LBB2_5
.LBB2_5:
	lw	a0, -36(s0)
	addi	a0, a0, 1
	sw	a0, -36(s0)
	j	.LBB2_3
.LBB2_6:
	fld	ft0, -32(s0)
	fsd	ft0, -16(s0)
	j	.LBB2_7
.LBB2_7:
	fld	fa0, -16(s0)
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end2:
	.size	power, .Lfunc_end2-power

	.globl	strLen
	.p2align	2
	.type	strLen,@function
strLen:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	li	a0, 0
	sw	a0, -16(s0)
	j	.LBB3_1
.LBB3_1:
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	li	a1, 10
	beq	a0, a1, .LBB3_4
	j	.LBB3_2
.LBB3_2:
	j	.LBB3_3
.LBB3_3:
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB3_1
.LBB3_4:
	lw	a0, -16(s0)
	addi	a0, a0, 1
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end3:
	.size	strLen, .Lfunc_end3-strLen

	.globl	detectBase
	.p2align	2
	.type	detectBase,@function
detectBase:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	lbu	a0, 1(a0)
	li	a1, 10
	sw	a1, -20(s0)
	li	a2, 16
	li	a1, 120
	sw	a2, -16(s0)
	beq	a0, a1, .LBB4_2
	lw	a0, -20(s0)
	sw	a0, -16(s0)
.LBB4_2:
	lw	a0, -16(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end4:
	.size	detectBase, .Lfunc_end4-detectBase

	.globl	invertStr
	.p2align	2
	.type	invertStr,@function
invertStr:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	li	a0, 0
	sw	a0, -20(s0)
	j	.LBB5_1
.LBB5_1:
	lw	a0, -20(s0)
	lw	a1, -16(s0)
	srli	a2, a1, 31
	add	a1, a1, a2
	srai	a1, a1, 1
	bge	a0, a1, .LBB5_4
	j	.LBB5_2
.LBB5_2:
	lw	a1, -12(s0)
	lw	a0, -20(s0)
	add	a0, a0, a1
	lb	a0, 2(a0)
	sb	a0, -21(s0)
	lw	a2, -12(s0)
	lw	a0, -16(s0)
	lw	a1, -20(s0)
	sub	a0, a0, a1
	add	a0, a0, a2
	lb	a0, 1(a0)
	add	a1, a1, a2
	sb	a0, 2(a1)
	lb	a0, -21(s0)
	lw	a2, -12(s0)
	lw	a1, -16(s0)
	lw	a3, -20(s0)
	sub	a1, a1, a3
	add	a1, a1, a2
	sb	a0, 1(a1)
	j	.LBB5_3
.LBB5_3:
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB5_1
.LBB5_4:
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end5:
	.size	invertStr, .Lfunc_end5-invertStr

	.globl	atoi
	.p2align	2
	.type	atoi,@function
atoi:
	addi	sp, sp, -64
	sw	ra, 60(sp)
	sw	s0, 56(sp)
	addi	s0, sp, 64
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	li	a0, 0
	sw	a0, -36(s0)
	sw	a0, -40(s0)
	lw	a0, -12(s0)
	lbu	a0, 0(a0)
	sw	a0, -48(s0)
	li	a1, 45
	beq	a0, a1, .LBB6_2
	j	.LBB6_1
.LBB6_1:
	lw	a0, -48(s0)
	li	a1, 48
	beq	a0, a1, .LBB6_3
	j	.LBB6_4
.LBB6_2:
	li	a0, 1
	sw	a0, -28(s0)
	j	.LBB6_5
.LBB6_3:
	li	a0, 2
	sw	a0, -28(s0)
	j	.LBB6_5
.LBB6_4:
	li	a0, 0
	sw	a0, -28(s0)
	j	.LBB6_5
.LBB6_5:
	lw	a0, -16(s0)
	addi	a0, a0, -2
	sw	a0, -44(s0)
	j	.LBB6_6
.LBB6_6:
	lw	a0, -44(s0)
	lw	a1, -28(s0)
	blt	a0, a1, .LBB6_13
	j	.LBB6_7
.LBB6_7:
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	li	a1, 48
	blt	a0, a1, .LBB6_10
	j	.LBB6_8
.LBB6_8:
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	add	a0, a0, a1
	lbu	a1, 0(a0)
	li	a0, 57
	blt	a0, a1, .LBB6_10
	j	.LBB6_9
.LBB6_9:
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a0, a0, -48
	sw	a0, -32(s0)
	j	.LBB6_11
.LBB6_10:
	lw	a0, -12(s0)
	lw	a1, -44(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a0, a0, -87
	sw	a0, -32(s0)
	j	.LBB6_11
.LBB6_11:
	lw	a0, -40(s0)
	fcvt.d.wu	ft0, a0
	fsd	ft0, -64(s0)
	lw	a0, -32(s0)
	fcvt.d.w	ft0, a0
	fsd	ft0, -56(s0)
	lw	a0, -20(s0)
	lw	a1, -36(s0)
	call	power
	fld	ft1, -64(s0)
	fld	ft0, -56(s0)
	fmadd.d	ft0, ft0, fa0, ft1
	fcvt.wu.d	a0, ft0, rtz
	sw	a0, -40(s0)
	lw	a0, -36(s0)
	addi	a0, a0, 1
	sw	a0, -36(s0)
	j	.LBB6_12
.LBB6_12:
	lw	a0, -44(s0)
	addi	a0, a0, -1
	sw	a0, -44(s0)
	j	.LBB6_6
.LBB6_13:
	lw	a0, -40(s0)
	lw	ra, 60(sp)
	lw	s0, 56(sp)
	addi	sp, sp, 64
	ret
.Lfunc_end6:
	.size	atoi, .Lfunc_end6-atoi

	.globl	itoa
	.p2align	2
	.type	itoa,@function
itoa:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a0, -12(s0)
	sw	a0, -24(s0)
	lw	a0, -12(s0)
	sw	a0, -28(s0)
	j	.LBB7_1
.LBB7_1:
	lw	a0, -16(s0)
	sw	a0, -36(s0)
	lw	a0, -16(s0)
	lui	a1, 838861
	addi	a1, a1, -819
	mulhu	a0, a0, a1
	srli	a0, a0, 3
	sw	a0, -16(s0)
	lw	a0, -36(s0)
	lw	a1, -16(s0)
	li	a2, 10
	mul	a1, a1, a2
	sub	a0, a0, a1
	lui	a1, %hi(.L.str)
	addi	a1, a1, %lo(.L.str)
	add	a0, a0, a1
	lb	a0, 35(a0)
	lw	a1, -24(s0)
	addi	a2, a1, 1
	sw	a2, -24(s0)
	sb	a0, 0(a1)
	j	.LBB7_2
.LBB7_2:
	lw	a0, -16(s0)
	li	a1, 0
	bne	a0, a1, .LBB7_1
	j	.LBB7_3
.LBB7_3:
	lw	a0, -20(s0)
	li	a1, 1
	bne	a0, a1, .LBB7_5
	j	.LBB7_4
.LBB7_4:
	lw	a1, -24(s0)
	addi	a0, a1, 1
	sw	a0, -24(s0)
	li	a0, 45
	sb	a0, 0(a1)
	j	.LBB7_5
.LBB7_5:
	lw	a1, -24(s0)
	addi	a0, a1, -1
	sw	a0, -24(s0)
	li	a0, 10
	sb	a0, 0(a1)
	j	.LBB7_6
.LBB7_6:
	lw	a0, -28(s0)
	lw	a1, -24(s0)
	bgeu	a0, a1, .LBB7_8
	j	.LBB7_7
.LBB7_7:
	lw	a0, -24(s0)
	lb	a0, 0(a0)
	sb	a0, -29(s0)
	lw	a0, -28(s0)
	lb	a0, 0(a0)
	lw	a1, -24(s0)
	addi	a2, a1, -1
	sw	a2, -24(s0)
	sb	a0, 0(a1)
	lb	a0, -29(s0)
	lw	a1, -28(s0)
	addi	a2, a1, 1
	sw	a2, -28(s0)
	sb	a0, 0(a1)
	j	.LBB7_6
.LBB7_8:
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end7:
	.size	itoa, .Lfunc_end7-itoa

	.globl	intToBin
	.p2align	2
	.type	intToBin,@function
intToBin:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	li	a0, 0
	sw	a0, -20(s0)
	j	.LBB8_1
.LBB8_1:
	lw	a0, -12(s0)
	andi	a0, a0, 1
	ori	a0, a0, 48
	lw	a2, -16(s0)
	lw	a1, -20(s0)
	add	a1, a1, a2
	sb	a0, 2(a1)
	lw	a0, -12(s0)
	srli	a0, a0, 1
	sw	a0, -12(s0)
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB8_2
.LBB8_2:
	lw	a0, -12(s0)
	li	a1, 0
	bne	a0, a1, .LBB8_1
	j	.LBB8_3
.LBB8_3:
	lw	a0, -20(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end8:
	.size	intToBin, .Lfunc_end8-intToBin

	.globl	numToBin
	.p2align	2
	.type	numToBin,@function
numToBin:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a1, -20(s0)
	li	a0, 48
	sb	a0, 0(a1)
	lw	a1, -20(s0)
	li	a0, 98
	sb	a0, 1(a1)
	lw	a0, -12(s0)
	li	a1, 0
	blt	a0, a1, .LBB9_2
	j	.LBB9_1
.LBB9_1:
	lw	a0, -16(s0)
	li	a1, 1
	bne	a0, a1, .LBB9_3
	j	.LBB9_2
.LBB9_2:
	lw	a1, -12(s0)
	li	a0, 0
	sub	a0, a0, a1
	lw	a1, -20(s0)
	call	intToBin
	sw	a0, -24(s0)
	lw	a0, -20(s0)
	li	a1, 32
	call	invertStr
	lw	a1, -20(s0)
	li	a0, 10
	sb	a0, 34(a1)
	lw	a1, -20(s0)
	li	a0, 1
	li	a2, 35
	call	write
	j	.LBB9_4
.LBB9_3:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	call	intToBin
	sw	a0, -28(s0)
	lw	a0, -20(s0)
	lw	a1, -28(s0)
	call	invertStr
	lw	a1, -20(s0)
	lw	a0, -28(s0)
	add	a1, a0, a1
	li	a0, 10
	sb	a0, 3(a1)
	lw	a1, -20(s0)
	lw	a0, -28(s0)
	addi	a2, a0, 4
	li	a0, 1
	call	write
	j	.LBB9_4
.LBB9_4:
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end9:
	.size	numToBin, .Lfunc_end9-numToBin

	.globl	numToDec
	.p2align	2
	.type	numToDec,@function
numToDec:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	lw	a0, -24(s0)
	lw	a1, -16(s0)
	lw	a2, -20(s0)
	call	itoa
	lw	a0, -24(s0)
	call	strLen
	sw	a0, -28(s0)
	lw	a1, -24(s0)
	lw	a0, -28(s0)
	add	a1, a0, a1
	li	a0, 10
	sb	a0, -1(a1)
	lw	a1, -24(s0)
	lw	a2, -28(s0)
	li	a0, 1
	call	write
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end10:
	.size	numToDec, .Lfunc_end10-numToDec

	.globl	binToHex
	.p2align	2
	.type	binToHex,@function
binToHex:
	addi	sp, sp, -64
	sw	ra, 60(sp)
	sw	s0, 56(sp)
	addi	s0, sp, 64
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	lw	a1, -16(s0)
	li	a0, 48
	sb	a0, 0(a1)
	lw	a1, -16(s0)
	li	a0, 120
	sb	a0, 1(a1)
	lw	a0, -12(s0)
	call	strLen
	addi	a0, a0, -2
	sw	a0, -40(s0)
	lw	a0, -40(s0)
	srai	a1, a0, 31
	srli	a1, a1, 30
	add	a1, a0, a1
	andi	a1, a1, -4
	sub	a0, a0, a1
	li	a1, 0
	bne	a0, a1, .LBB11_2
	j	.LBB11_1
.LBB11_1:
	lw	a0, -40(s0)
	srai	a1, a0, 31
	srli	a1, a1, 30
	add	a0, a0, a1
	srai	a0, a0, 2
	sw	a0, -48(s0)
	j	.LBB11_3
.LBB11_2:
	lw	a0, -40(s0)
	srai	a1, a0, 31
	srli	a1, a1, 30
	add	a0, a0, a1
	srai	a0, a0, 2
	addi	a0, a0, 1
	sw	a0, -48(s0)
	j	.LBB11_3
.LBB11_3:
	lw	a0, -48(s0)
	sw	a0, -44(s0)
	li	a0, 2
	sw	a0, -20(s0)
	sw	a0, -24(s0)
	j	.LBB11_4
.LBB11_4:
	lw	a0, -20(s0)
	lw	a1, -44(s0)
	addi	a1, a1, 2
	bge	a0, a1, .LBB11_14
	j	.LBB11_5
.LBB11_5:
	li	a0, 0
	sw	a0, -32(s0)
	sw	a0, -28(s0)
	j	.LBB11_6
.LBB11_6:
	lw	a1, -28(s0)
	li	a0, 3
	blt	a0, a1, .LBB11_9
	j	.LBB11_7
.LBB11_7:
	lw	a0, -12(s0)
	lw	a2, -24(s0)
	lw	a1, -28(s0)
	add	a2, a2, a1
	add	a0, a0, a2
	lbu	a0, 0(a0)
	addi	a0, a0, -48
	fcvt.d.w	ft0, a0
	fsd	ft0, -56(s0)
	li	a0, 3
	sub	a1, a0, a1
	li	a0, 2
	call	power
	fld	ft0, -56(s0)
	lw	a0, -32(s0)
	fcvt.d.w	ft1, a0
	fmadd.d	ft0, ft0, fa0, ft1
	fcvt.w.d	a0, ft0, rtz
	sw	a0, -32(s0)
	j	.LBB11_8
.LBB11_8:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB11_6
.LBB11_9:
	lw	a1, -32(s0)
	li	a0, 9
	blt	a0, a1, .LBB11_11
	j	.LBB11_10
.LBB11_10:
	lw	a0, -32(s0)
	addi	a0, a0, 48
	lw	a1, -16(s0)
	lw	a2, -20(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB11_12
.LBB11_11:
	lw	a0, -32(s0)
	addi	a0, a0, 87
	lw	a1, -16(s0)
	lw	a2, -20(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB11_12
.LBB11_12:
	j	.LBB11_13
.LBB11_13:
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	lw	a0, -24(s0)
	addi	a0, a0, 4
	sw	a0, -24(s0)
	j	.LBB11_4
.LBB11_14:
	lw	a1, -16(s0)
	lw	a0, -44(s0)
	add	a1, a0, a1
	li	a0, 10
	sb	a0, 2(a1)
	lw	a1, -16(s0)
	lw	a0, -44(s0)
	addi	a2, a0, 3
	li	a0, 1
	call	write
	lw	ra, 60(sp)
	lw	s0, 56(sp)
	addi	sp, sp, 64
	ret
.Lfunc_end11:
	.size	binToHex, .Lfunc_end11-binToHex

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -128
	sw	ra, 124(sp)
	sw	s0, 120(sp)
	addi	s0, sp, 128
	li	a0, 0
	sw	a0, -112(s0)
	sw	a0, -12(s0)
	addi	a1, s0, -32
	li	a2, 20
	call	read
	mv	a1, a0
	lw	a0, -112(s0)
	sw	a1, -36(s0)
	sw	a0, -40(s0)
	lbu	a0, -32(s0)
	li	a1, 45
	bne	a0, a1, .LBB12_2
	j	.LBB12_1
.LBB12_1:
	li	a0, 1
	sw	a0, -40(s0)
	j	.LBB12_2
.LBB12_2:
	addi	a0, s0, -32
	sw	a0, -116(s0)
	call	detectBase
	mv	a1, a0
	lw	a0, -116(s0)
	sw	a1, -44(s0)
	lw	a1, -36(s0)
	lw	a2, -44(s0)
	lw	a3, -40(s0)
	call	atoi
	sw	a0, -48(s0)
	lw	a0, -48(s0)
	li	a1, 0
	bge	a0, a1, .LBB12_4
	j	.LBB12_3
.LBB12_3:
	li	a0, 1
	sw	a0, -40(s0)
	j	.LBB12_4
.LBB12_4:
	lw	a0, -48(s0)
	lw	a1, -40(s0)
	addi	a2, s0, -83
	sw	a2, -120(s0)
	call	numToBin
	lw	a0, -44(s0)
	lw	a1, -48(s0)
	lw	a2, -40(s0)
	addi	a3, s0, -94
	call	numToDec
	lw	a0, -120(s0)
	addi	a1, s0, -105
	call	binToHex
	li	a0, 0
	lw	ra, 124(sp)
	lw	s0, 120(sp)
	addi	sp, sp, 128
	ret
.Lfunc_end12:
	.size	main, .Lfunc_end12-main

	.globl	exit
	.p2align	2
	.type	exit,@function
exit:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a1, -12(s0)
	#APP
	mv	a0, a1	# return code
	li	a7, 93	# syscall exit (64) 
	ecall	
	#NO_APP
.Lfunc_end13:
	.size	exit, .Lfunc_end13-exit

	.globl	_start
	.p2align	2
	.type	_start,@function
_start:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	call	main
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	call	exit
.Lfunc_end14:
	.size	_start, .Lfunc_end14-_start

	.type	.L.str,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"ZYXWVUTSRQPONMLKJIHGFEDCBA9876543210123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	.size	.L.str, 72

	.ident	"Ubuntu clang version 15.0.7"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym read
	.addrsig_sym write
	.addrsig_sym power
	.addrsig_sym strLen
	.addrsig_sym detectBase
	.addrsig_sym invertStr
	.addrsig_sym atoi
	.addrsig_sym itoa
	.addrsig_sym intToBin
	.addrsig_sym numToBin
	.addrsig_sym numToDec
	.addrsig_sym binToHex
	.addrsig_sym main
	.addrsig_sym exit
