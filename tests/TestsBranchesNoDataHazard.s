.global main
.text

main:
	addi a1, zero, 5
	addi a2, zero, -3
	addi a3, zero, 5
	addi a4, zero, 69
	addi zero, zero, 0
	addi zero, zero, 0
	beq a1, a3, .L1
.L0:
	addi a0, zero, -1
	beq zero, zero, .EXIT
.L1:
	beq a1, a2, .L0
	bne a1, a3, .L0
	bne a1, a2, .L2
	addi a0, zero, -1
.L2:
	blt a1, a2, .L0
	blt a2, a1, .L3
	addi a0, zero, -1
.L3:
	bge a3, a4, .L0
	bge a4, a3, .L4
	addi a0, zero, -1
.L4:
	bge a1, a3, .L5
	addi a0, zero, -1
.L5:
	bltu a2, a1, .L0
	bltu a1, a2, .L6
	addi a0, zero, -1
.L6:
	bltu a4, a3, .L0
	bgeu a1, a2, .L0
	bgeu a1, a3, .EXIT
	addi a0, zero, -1
.EXIT:
	addi zero, zero, 0

# Expected final state:
# a0: 0
# a1: 5
# a2: 4294967293 (-3)
# a3: 5
# a4: 69
