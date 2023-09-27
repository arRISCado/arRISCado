	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi zero, a0, 1
	addi t0, zero, 2
	addi t1, zero, 3
	addi t2, zero, 4
	addi s0, t0, 5
	addi s1, t1, 6
	addi a0, t2, 7
	addi a1, s0, 8
	addi a2, s1, 9
	addi a3, a0, 10
	addi a4, a1, 11
	addi a5, a2, 12
	addi a6, a3, 13
	addi a7, a4, 14
	addi s2, a5, 15
	addi s3, a6, 16
	addi s4, a7, 17
	addi s5, s2, 18
	addi s6, s3, 19
	addi s7, s4, 20
	addi s8, s5, 21
	addi s9, s6, 22
	addi s10, s7, 23
	addi s11, s8, 24
	addi t3, s9, 25
	addi t4, s10, 26
	addi t5, s11, 27
	addi t6, t3, 28

# Expected final state:
# zero: 0
# t4: 126
# t5: 135
# t6: 144
