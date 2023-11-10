addi a2, zero, 7
addi a3, zero, 15

lw a0, addr_pwm1
lw a1, addr_pwm2

sw a2, 0(a0)
sw a3, 0(a1)

addi zero, zero, 0
addi zero, zero, 0
addi zero, zero, 0
addi zero, zero, 0

loop:
	jal loop

addr_pwm1: # Cycles on
 	.word 0x20000000 
  
addr_pwm2: # Cycles in Duty Cycle 
 	.word 0x20000001