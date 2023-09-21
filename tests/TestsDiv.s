	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
    addi t0, zero, -2023
    addi t1, zero, 21
    div t2, t0, t1 
    divu t3, t0, t1  
    div t4, t0, t1 
    rem t5, t0, t1
    remu t6, t0, t1
    addi a0, zero, 10

# Expected final state:
# t0: -2023
# t1: 21
# t2: -96
# t3: 204522155
# t4: -96
# t5: 14
# t6: 18
# a0: 10
