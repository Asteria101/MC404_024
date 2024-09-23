	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"lab5a.c"
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

	.globl	copyString
	.p2align	2
	.type	copyString,@function
copyString:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	li	a0, 0
	sw	a0, -28(s0)
	lw	a0, -24(s0)
	sw	a0, -32(s0)
	j	.LBB2_1
.LBB2_1:
	lw	a1, -28(s0)
	lw	a0, -20(s0)
	li	a2, 0
	sw	a2, -36(s0)
	blt	a0, a1, .LBB2_3
	j	.LBB2_2
.LBB2_2:
	lw	a0, -32(s0)
	lw	a1, -24(s0)
	lw	a2, -20(s0)
	sub	a1, a1, a2
	slt	a0, a0, a1
	xori	a0, a0, 1
	sw	a0, -36(s0)
	j	.LBB2_3
.LBB2_3:
	lw	a0, -36(s0)
	andi	a0, a0, 1
	li	a1, 0
	beq	a0, a1, .LBB2_6
	j	.LBB2_4
.LBB2_4:
	lw	a0, -12(s0)
	lw	a1, -28(s0)
	slli	a1, a1, 2
	add	a0, a0, a1
	lw	a0, 0(a0)
	lw	a1, -16(s0)
	lw	a2, -32(s0)
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	j	.LBB2_5
.LBB2_5:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	lw	a0, -32(s0)
	addi	a0, a0, -1
	sw	a0, -32(s0)
	j	.LBB2_1
.LBB2_6:
	lw	a1, -16(s0)
	li	a0, 0
	sw	a0, 128(a1)
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end2:
	.size	copyString, .Lfunc_end2-copyString

	.globl	power
	.p2align	2
	.type	power,@function
power:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	lui	a0, 261888
	sw	a0, -20(s0)
	li	a0, 0
	sw	a0, -24(s0)
	lw	a0, -12(s0)
	fcvt.d.w	ft0, a0
	fsd	ft0, -32(s0)
	j	.LBB3_1
.LBB3_1:
	lw	a1, -16(s0)
	li	a0, 0
	bge	a0, a1, .LBB3_5
	j	.LBB3_2
.LBB3_2:
	lbu	a0, -16(s0)
	andi	a0, a0, 1
	li	a1, 0
	beq	a0, a1, .LBB3_4
	j	.LBB3_3
.LBB3_3:
	fld	ft1, -32(s0)
	fld	ft0, -24(s0)
	fmul.d	ft0, ft0, ft1
	fsd	ft0, -24(s0)
	j	.LBB3_4
.LBB3_4:
	fld	ft0, -32(s0)
	fmul.d	ft0, ft0, ft0
	fsd	ft0, -32(s0)
	lw	a0, -16(s0)
	srai	a0, a0, 1
	sw	a0, -16(s0)
	j	.LBB3_1
.LBB3_5:
	fld	fa0, -24(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end3:
	.size	power, .Lfunc_end3-power

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
	li	a0, 0
	sw	a0, -28(s0)
	sw	a0, -32(s0)
	lw	a0, -16(s0)
	addi	a0, a0, -1
	sw	a0, -36(s0)
	j	.LBB4_1
.LBB4_1:
	lw	a0, -36(s0)
	li	a1, 0
	blt	a0, a1, .LBB4_7
	j	.LBB4_2
.LBB4_2:
	lw	a0, -12(s0)
	lw	a1, -36(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	li	a1, 48
	blt	a0, a1, .LBB4_5
	j	.LBB4_3
.LBB4_3:
	lw	a0, -12(s0)
	lw	a1, -36(s0)
	add	a0, a0, a1
	lbu	a1, 0(a0)
	li	a0, 57
	blt	a0, a1, .LBB4_5
	j	.LBB4_4
.LBB4_4:
	lw	a0, -12(s0)
	lw	a1, -36(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	addi	a0, a0, -48
	sw	a0, -24(s0)
	j	.LBB4_5
.LBB4_5:
	lw	a0, -32(s0)
	fcvt.d.wu	ft0, a0
	fsd	ft0, -56(s0)
	lw	a0, -24(s0)
	fcvt.d.w	ft0, a0
	fsd	ft0, -48(s0)
	lw	a0, -20(s0)
	lw	a1, -28(s0)
	call	power
	fld	ft1, -56(s0)
	fld	ft0, -48(s0)
	fmadd.d	ft0, ft0, fa0, ft1
	fcvt.wu.d	a0, ft0, rtz
	sw	a0, -32(s0)
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB4_6
.LBB4_6:
	lw	a0, -36(s0)
	addi	a0, a0, -1
	sw	a0, -36(s0)
	j	.LBB4_1
.LBB4_7:
	lw	a0, -32(s0)
	lw	ra, 60(sp)
	lw	s0, 56(sp)
	addi	sp, sp, 64
	ret
.Lfunc_end4:
	.size	atoi, .Lfunc_end4-atoi

	.globl	getNumber
	.p2align	2
	.type	getNumber,@function
getNumber:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	li	a0, 0
	sw	a0, -24(s0)
	j	.LBB5_1
.LBB5_1:
	lw	a1, -24(s0)
	li	a0, 3
	blt	a0, a1, .LBB5_4
	j	.LBB5_2
.LBB5_2:
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	lw	a2, -24(s0)
	add	a1, a1, a2
	add	a0, a0, a1
	lb	a0, 0(a0)
	lw	a1, -16(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB5_3
.LBB5_3:
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB5_1
.LBB5_4:
	lw	a0, -16(s0)
	li	a1, 4
	li	a2, 10
	call	atoi
	sw	a0, -28(s0)
	lw	a1, -12(s0)
	lw	a0, -20(s0)
	add	a0, a0, a1
	lbu	a0, -1(a0)
	li	a1, 45
	bne	a0, a1, .LBB5_6
	j	.LBB5_5
.LBB5_5:
	lw	a1, -28(s0)
	li	a0, 0
	sub	a0, a0, a1
	sw	a0, -32(s0)
	j	.LBB5_7
.LBB5_6:
	lw	a0, -28(s0)
	sw	a0, -32(s0)
	j	.LBB5_7
.LBB5_7:
	lw	a0, -32(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end5:
	.size	getNumber, .Lfunc_end5-getNumber

	.globl	sliceBinary
	.p2align	2
	.type	sliceBinary,@function
sliceBinary:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a0, -16(s0)
	sw	a0, -24(s0)
	j	.LBB6_1
.LBB6_1:
	lw	a0, -24(s0)
	li	a1, 0
	blt	a0, a1, .LBB6_4
	j	.LBB6_2
.LBB6_2:
	lw	a0, -12(s0)
	lw	a2, -24(s0)
	srl	a0, a0, a2
	andi	a0, a0, 1
	lw	a1, -20(s0)
	slli	a2, a2, 2
	add	a1, a1, a2
	sw	a0, 0(a1)
	j	.LBB6_3
.LBB6_3:
	lw	a0, -24(s0)
	addi	a0, a0, -1
	sw	a0, -24(s0)
	j	.LBB6_1
.LBB6_4:
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end6:
	.size	sliceBinary, .Lfunc_end6-sliceBinary

	.globl	packBinary
	.p2align	2
	.type	packBinary,@function
packBinary:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	lw	a0, -20(s0)
	addi	a0, a0, 1
	mv	a1, sp
	sw	a1, -28(s0)
	slli	a1, a0, 2
	addi	a1, a1, 15
	andi	a2, a1, -16
	mv	a1, sp
	sub	a2, a1, a2
	sw	a2, -36(s0)
	mv	sp, a2
	sw	a0, -32(s0)
	lw	a0, -16(s0)
	lw	a1, -20(s0)
	call	sliceBinary
	lw	a0, -36(s0)
	lw	a1, -12(s0)
	lw	a2, -20(s0)
	lw	a4, -24(s0)
	li	a3, 31
	sub	a3, a3, a4
	call	copyString
	lw	a0, -28(s0)
	mv	sp, a0
	addi	sp, s0, -48
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end7:
	.size	packBinary, .Lfunc_end7-packBinary

	.globl	binaryToInteger
	.p2align	2
	.type	binaryToInteger,@function
binaryToInteger:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	li	a0, 0
	sw	a0, -16(s0)
	sw	a0, -20(s0)
	j	.LBB8_1
.LBB8_1:
	lw	a1, -20(s0)
	li	a0, 31
	blt	a0, a1, .LBB8_4
	j	.LBB8_2
.LBB8_2:
	lw	a0, -16(s0)
	slli	a0, a0, 1
	lw	a1, -12(s0)
	lw	a2, -20(s0)
	slli	a2, a2, 2
	add	a1, a1, a2
	lw	a1, 0(a1)
	or	a0, a0, a1
	sw	a0, -16(s0)
	j	.LBB8_3
.LBB8_3:
	lw	a0, -20(s0)
	addi	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB8_1
.LBB8_4:
	lw	a0, -16(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end8:
	.size	binaryToInteger, .Lfunc_end8-binaryToInteger

	.globl	hexCode
	.p2align	2
	.type	hexCode,@function
hexCode:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	sw	a0, -28(s0)
	li	a0, 48
	sb	a0, -23(s0)
	li	a0, 120
	sb	a0, -22(s0)
	li	a0, 10
	sb	a0, -13(s0)
	li	a0, 9
	sw	a0, -36(s0)
	j	.LBB9_1
.LBB9_1:
	lw	a0, -36(s0)
	li	a1, 2
	blt	a0, a1, .LBB9_7
	j	.LBB9_2
.LBB9_2:
	lw	a0, -28(s0)
	andi	a0, a0, 15
	sw	a0, -32(s0)
	lw	a0, -32(s0)
	li	a1, 10
	bltu	a0, a1, .LBB9_4
	j	.LBB9_3
.LBB9_3:
	lw	a0, -32(s0)
	addi	a0, a0, 55
	lw	a2, -36(s0)
	addi	a1, s0, -23
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB9_5
.LBB9_4:
	lw	a0, -32(s0)
	addi	a0, a0, 48
	lw	a2, -36(s0)
	addi	a1, s0, -23
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB9_5
.LBB9_5:
	lw	a0, -28(s0)
	srli	a0, a0, 4
	sw	a0, -28(s0)
	j	.LBB9_6
.LBB9_6:
	lw	a0, -36(s0)
	addi	a0, a0, -1
	sw	a0, -36(s0)
	j	.LBB9_1
.LBB9_7:
	li	a0, 1
	addi	a1, s0, -23
	li	a2, 11
	call	write
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end9:
	.size	hexCode, .Lfunc_end9-hexCode

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -208
	sw	ra, 204(sp)
	sw	s0, 200(sp)
	addi	s0, sp, 208
	li	a0, 0
	sw	a0, -204(s0)
	sw	a0, -12(s0)
	addi	a1, s0, -42
	li	a2, 30
	call	read
	mv	a1, a0
	lw	a0, -204(s0)
	sw	a1, -48(s0)
	sw	a0, -196(s0)
	sw	a0, -200(s0)
	j	.LBB10_1
.LBB10_1:
	lw	a1, -200(s0)
	li	a0, 24
	blt	a0, a1, .LBB10_14
	j	.LBB10_2
.LBB10_2:
	lw	a0, -200(s0)
	addi	a2, a0, 1
	addi	a0, s0, -42
	addi	a1, s0, -52
	call	getNumber
	sw	a0, -188(s0)
	lw	a0, -200(s0)
	li	a1, 0
	bne	a0, a1, .LBB10_4
	j	.LBB10_3
.LBB10_3:
	li	a0, 2
	sw	a0, -192(s0)
	j	.LBB10_12
.LBB10_4:
	lw	a0, -200(s0)
	li	a1, 6
	bne	a0, a1, .LBB10_6
	j	.LBB10_5
.LBB10_5:
	lw	a0, -192(s0)
	lw	a1, -196(s0)
	add	a0, a0, a1
	addi	a0, a0, 1
	sw	a0, -196(s0)
	li	a0, 7
	sw	a0, -192(s0)
	j	.LBB10_11
.LBB10_6:
	lw	a0, -200(s0)
	li	a1, 12
	beq	a0, a1, .LBB10_8
	j	.LBB10_7
.LBB10_7:
	lw	a0, -200(s0)
	li	a1, 18
	bne	a0, a1, .LBB10_9
	j	.LBB10_8
.LBB10_8:
	lw	a0, -192(s0)
	lw	a1, -196(s0)
	add	a0, a0, a1
	addi	a0, a0, 1
	sw	a0, -196(s0)
	li	a0, 4
	sw	a0, -192(s0)
	j	.LBB10_10
.LBB10_9:
	lw	a0, -192(s0)
	lw	a1, -196(s0)
	add	a0, a0, a1
	addi	a0, a0, 1
	sw	a0, -196(s0)
	li	a0, 10
	sw	a0, -192(s0)
	j	.LBB10_10
.LBB10_10:
	j	.LBB10_11
.LBB10_11:
	j	.LBB10_12
.LBB10_12:
	lw	a1, -188(s0)
	lw	a2, -192(s0)
	lw	a3, -196(s0)
	addi	a0, s0, -184
	call	packBinary
	j	.LBB10_13
.LBB10_13:
	lw	a0, -200(s0)
	addi	a0, a0, 6
	sw	a0, -200(s0)
	j	.LBB10_1
.LBB10_14:
	li	a0, 10
	sw	a0, -56(s0)
	addi	a0, s0, -184
	call	binaryToInteger
	call	hexCode
	li	a0, 0
	lw	ra, 204(sp)
	lw	s0, 200(sp)
	addi	sp, sp, 208
	ret
.Lfunc_end10:
	.size	main, .Lfunc_end10-main

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
.Lfunc_end11:
	.size	exit, .Lfunc_end11-exit

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
.Lfunc_end12:
	.size	_start, .Lfunc_end12-_start

	.ident	"Ubuntu clang version 15.0.7"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym read
	.addrsig_sym write
	.addrsig_sym copyString
	.addrsig_sym power
	.addrsig_sym atoi
	.addrsig_sym getNumber
	.addrsig_sym sliceBinary
	.addrsig_sym packBinary
	.addrsig_sym binaryToInteger
	.addrsig_sym hexCode
	.addrsig_sym main
	.addrsig_sym exit
