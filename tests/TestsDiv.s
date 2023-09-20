	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
    addi t0, zero, -15
    addi t1, zero, 4
    div t2, t0, t1 
    divu t3, t0, t1  
    div t4, t0, t1 
    add t4, t4, t2 
    div t5, t0, t1   
    sub t5, t5, t3  
    li t6, 10   
    ecall       

# Expected final state:
# t0: -15
# t1: 4
# t2: -3 
# t3: 3
# t4: -6
# t5: 0
# t6: 10
