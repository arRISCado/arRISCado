main:
	addi a0, a0, 57
	addi zero, zero, 0
	addi zero, zero, 0
	srli a0, a0, 2
	addi zero, zero, 0
	addi zero, zero, 0
	slli a1, a0, 2
	addi a2, a2, 3
	addi zero, zero, 0
	addi zero, zero, 0
	srl a3, a0, a2
	sll a4, a1, a2
	addi zero, zero, 0
	addi zero, zero, 0
	sra a5, a4, a2
	srai a6, a4, 2


# Expected Final State: 
# a0: 14
# a1: 56
# a2: 3
# a3: 1
# a4: 448
# a5: 56
# a6: 112
