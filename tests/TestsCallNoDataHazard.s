.global main
.text

my_function:
    addi sp, sp, -4 
    addi zero, zero, 0
	addi zero, zero, 0   
    sw ra, 0(sp)
    addi t0, zero, 5
    addi t1, zero, 1
    addi zero, zero, 0
    addi zero, zero, 0

    loop_start:
        beq t0, zero, loop_end
        add t1, t1, t0    
        addi t0, t0, -1 
        addi zero, zero, 0
        addi zero, zero, 0
        call loop_start        

    loop_end:
    
    add a0, zero, t1
    addi zero, zero, 0
	addi zero, zero, 0
    lw ra, 0(sp)   
    addi sp, sp, 4
    addi zero, zero, 0
	addi zero, zero, 0
    jalr ra, 0(ra)

main:
    jal ra, my_function
    addi a2, zero, 10
    addi zero, zero, 0
	addi zero, zero, 0 
    ecall
      
    
# Expected final state:
# t0: 0
# t1: 16
# a0: 16
# a2: 10
