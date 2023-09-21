	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
    addi t0, zero, -1028
    addi t1, zero, 2
    mul t2, t0, t1   
    mulh t3, t0, t1      
    mulhu t4, t0, t1 
    mulhsu t5, t0, t1 
    mul t6, t0, t1  
    addi a0, zero, 10

# Expected final state:
# t0: -1028
# t1: 2
# t2: -2056 
# t3: -1
# t4: 1
# t5: -1
# t6: -2056
# a0: 10
