	.option nopic
	.text
	.align	2
	.globl	main
	.type	main, @function
my_function:
    addi sp, sp, -4    
    sw ra, 0(sp)
    addi t0, zero, 5
    addi t1, zero, 1

    loop_start:
        beq t0, zero, loop_end
        add t1, t1, t0    
        addi t0, t0, -1 
        call loop_start        

    loop_end:
    
    add a0, zero, t1
    lw ra, 0(sp)   
    addi sp, sp, 4    
    jalr ra, 0(ra)

main:
    jal ra, my_function
    addi a2, zero, 10 
    
# Expected final state:
# t0: 0
# t1: 16
# a0: 16
# a2: 10
