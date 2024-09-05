	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"main.c"
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
.Lfunc_end0:
	.size	exit, .Lfunc_end0-exit

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
	li	a7, 63	# syscall read code (63) 
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
.Lfunc_end2:
	.size	read, .Lfunc_end2-read

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	li	a0, 0
	sw	a0, -12(s0)
	lui	a1, %hi(input)
	addi	a1, a1, %lo(input)
	sw	a1, -28(s0)
	li	a2, 5
	call	read
	mv	a1, a0
	lw	a0, -28(s0)
	sw	a1, -16(s0)
	lbu	a0, 2(a0)
	sw	a0, -24(s0)
	li	a1, 42
	beq	a0, a1, .LBB3_3
	j	.LBB3_1
.LBB3_1:
	lw	a0, -24(s0)
	li	a1, 43
	beq	a0, a1, .LBB3_4
	j	.LBB3_2
.LBB3_2:
	lw	a0, -24(s0)
	li	a1, 45
	beq	a0, a1, .LBB3_5
	j	.LBB3_6
.LBB3_3:
	lui	a0, %hi(input)
	addi	a1, a0, %lo(input)
	lb	a0, %lo(input)(a0)
	addi	a0, a0, -48
	lb	a1, 4(a1)
	addi	a1, a1, -48
	mul	a0, a0, a1
	addi	a0, a0, 48
	sb	a0, -17(s0)
	j	.LBB3_6
.LBB3_4:
	lui	a0, %hi(input)
	addi	a1, a0, %lo(input)
	lb	a0, %lo(input)(a0)
	lb	a1, 4(a1)
	add	a0, a0, a1
	addi	a0, a0, -48
	sb	a0, -17(s0)
	j	.LBB3_6
.LBB3_5:
	lui	a0, %hi(input)
	addi	a1, a0, %lo(input)
	lb	a0, %lo(input)(a0)
	lb	a1, 4(a1)
	sub	a0, a0, a1
	addi	a0, a0, 48
	sb	a0, -17(s0)
	j	.LBB3_6
.LBB3_6:
	lb	a1, -17(s0)
	lui	a0, %hi(input)
	sb	a1, %lo(input)(a0)
	addi	a1, a0, %lo(input)
	li	a0, 10
	sb	a0, 1(a1)
	li	a0, 1
	li	a2, 2
	call	write
	li	a0, 0
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

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
.Lfunc_end4:
	.size	_start, .Lfunc_end4-_start

	.type	input,@object
	.section	.sbss,"aw",@nobits
	.globl	input
input:
	.zero	5
	.size	input, 5

	.ident	"Ubuntu clang version 15.0.7"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym exit
	.addrsig_sym write
	.addrsig_sym read
	.addrsig_sym main
	.addrsig_sym input
