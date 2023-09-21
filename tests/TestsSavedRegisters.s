	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi s0, zero, 1
	addi s1, s0, 2
	addi s2, s1, 3
	addi s3, s2, 4
    addi s4, s3, 5
	addi s5, s4, 6
	addi s6, s5, 7
    addi s7, s6, 8
	addi s8, s7, 9
	addi s9, s8, 10
    addi s10, s9, 11
	addi s11, s10, 12
	addi a0, s11, 13
	addi a1, s10, 14

# Expected final state:
# a0: 91
# a1: 80
