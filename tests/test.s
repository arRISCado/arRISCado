main:
	add a0, zero, zero
    addi a1, zero, 1
    addi a2, zero, 8
    addi a3, zero, 2
.loop:
	addi a0, a0, 1
    mul a1, a1, a3
    bne a0, a2, .loop
    j main