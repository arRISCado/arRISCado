.global main
.text

main:
	addi a0, zero, 3
	addi a1, zero, -24
	addi zero, zero, 0
	addi zero, zero, 0
	slt a2, a0, a1
	sltu a3, a0, a1
	slti a4, a0, 2
	slti a5, a0, 4
	slt a6, a1, a0
	sltu a7, a1, a0
	sltiu s2, a0, 1
	sltiu s3, a0, -2

# Expected final state:
# a0: 3
# a1: 4294967272 (-24)
# a2: 0
# a3: 1
# a4: 0
# a5: 1
# a6: 1
# a7: 0
# s2: 0
# s3: 1
