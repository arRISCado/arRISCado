	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
    lui a0, 131072
    addi zero, zero, 0
	addi zero, zero, 0
	addi zero, zero, 0
    addi a1, a0, 1
	addi zero, zero, 0
	addi zero, zero, 0
	addi zero, zero, 0
    addi t0, zero, 5
	addi zero, zero, 0
	addi zero, zero, 0
	addi zero, zero, 0
    addi t1, zero, 10
    addi zero, zero, 0
	addi zero, zero, 0
	addi zero, zero, 0
    sw t0, 0(a0)
	addi zero, zero, 0
	addi zero, zero, 0
	addi zero, zero, 0
    sw t1, 0(a1)
	addi zero, zero, 0
	addi zero, zero, 0
	addi zero, zero, 0