main:
	andi a0, a0, 3240
	addi zero, zero, 0
	addi zero, zero, 0
	xori a0, a0, 3240
	addi zero, zero, 0
	addi zero, zero, 0
	xor a1, a1, a0
	addi zero, zero, 0
	addi zero, zero, 0
	xor a1, a1, a0
	xori a2, a0, 3241
	andi a3, a0, 3241
	xori a4, a4, 3855
	addi zero, zero, 0
	addi zero, zero, 0
	and a4, a4, a0
	addi zero, zero, 0
	addi zero, zero, 0
	ori a5, a4, 19
	addi zero, zero, 0
	addi zero, zero, 0
	or a6, a5, a3
	
	
	

# Expected Final State: 
# a0: 3240
# a1: 0
# a2: 1
# a3: 3240
# a4: 3080
# a5: 3099
# a6: 3259