	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	jal a1, .L1
	addi a0, zero, -1
	j .L2
.L1:
	jalr a2, a1, 4
	addi a3, zero, -2
.L2:
	addi zero, zero, 0


# Expected final state:
# a0: 0
# a1: Memory address for the instruction after jal
# a2: Memory address for the instruction after jalr
# a3: 0
