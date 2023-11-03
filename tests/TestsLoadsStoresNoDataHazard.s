	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi zero, zero, 0
	addi zero, zero, 0
	addi zero, zero, 0
	addi zero, zero, 0
	addi sp,sp,-8
	addi a1, zero, 20
	addi zero, zero, 0
	addi zero, zero, 0
	addi zero, zero, 0
	addi zero, zero, 0
	sw a1, 4(sp)
	sh a1, 2(sp)
	sb a1, 5(sp)
	addi a2, a1, 93
	addi zero, zero, 0
	addi zero, zero, 0
	addi zero, zero, 0
	addi zero, zero, 0
	sw a2, 1(sp)
	addi zero, zero, 0
	addi zero, zero, 0
	addi zero, zero, 0
	addi zero, zero, 0
	lw a3, 4(sp)
	lh a4, 5(sp)
	lb a5, 2(sp)

# Expected final state:
# a1: 20
# a2: 113
# a3: 5120
# a4: 20
# a5: 0
