	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
    addi t0, zero, 1028
    addi t1, zero, 2
    mul t2, t0, t1       
    mulhu t3, t0, t1 
    mulhsu t4, t0, t1 
    mul t5, t0, t1  
    add t5, t5, t2 
    mulhu t6, t0, t1  
    add t6, t6, t3   
    mul t7, t0, t1  
    sub t7, t7, t5
    li t8, 10   
    ecall      

# Expected final state:
# t0: 1028
# t1: 2
# t2: 2056 
# t3: 0
# t4: 0
# t5: 4112
# t6: 0
# t7: -2056
# t8: 10
