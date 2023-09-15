.global main
.text

main:
	addi t0, zero, 1
	addi t1, t0, 2
	addi t2, t1, 3
	addi t3, t2, 4
    addi t4, t3, 5
	addi t5, t4, 6
	addi t6, t5, 7
	addi a0, t6, 8
	addi a1, t5, 9

# Expected final state:
# t0: 1
# t1: 3
# t2: 6
# a0: 36
# a1: 30
# t3: 10
# t4: 15
# t5: 21
# t6: 28
