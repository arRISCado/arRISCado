main:
	add a0, zero, zero
    addi a1, zero, 32
.loop:
	addi a0, a0, 1
    bne a0, a1, .loop
    j main