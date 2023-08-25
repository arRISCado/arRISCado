# TODO: Fix register names based on our implementation

main:
	addi a0, zero, 1
	addi zero, zero, 0
	addi zero, zero, 0
	sub a1, zero, a0
	add a2, a0, a0
	addi zero, zero, 0
	addi zero, zero, 0
	add a2, a2, a2
	addi a3, zero, 4095 
	addi zero, zero, 0
	add a4, a2, a1
	addi zero, zero, 0
	addi zero, zero, 0
	sub a5, a2, a4
	addi a6, a3, 5
	lui a7, 98
	auipc s2, 0

# Expected final state:
# a0: 1
# a1: 4294967295
# a2: 4
# a3: 4095
# a4: 3
# a5: 1
# a6: 4100
# a7: 401408
# s2: 108
