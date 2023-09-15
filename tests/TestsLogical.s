.global main
.text

main:
	andi a0, a0, 1745
	xori a0, a0, 1745
	xor a1, a1, a0
	xor a1, a1, a0
	xori a2, a0, 1320
	andi a3, a0, 1320
	xori a4, a4, 1111
	and a4, a4, a0
	ori a5, a4, 19
	or a6, a5, a3


# Expected Final State: 
# a0: 1745
# a1: 0
# a2: 1017
# a3: 1024
# a4: 1105
# a5: 1107
# a6: 1107
