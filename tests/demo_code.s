addi zero, zero, 0
lui a0, 131072 #pwm clk_on
addi a1, a0, 1 #pwm clk_in_dc
slli a2, a0, 1 #button1
addi a3, a2, 1 #button2

lw t2, 0(a2) #last_button1
addi zero, zero, 0
lw t3, 0(a3) #last_button2
addi zero, zero, 0

addi t0, zero, 5
addi t1, zero, 10
addi t6, t1, 1
sw t0, 0(a0)
sw t0, 0(a0)
sw t1, 0(a1)
sw t1, 0(a1)



main_loop:
    lw t4, 0(a2)
    addi zero, zero, 0
    lw t5, 0(a3)
    addi zero, zero, 0

    beq t4, t2, no_add
    nop
    nop
    nop
    nop
    addi t0, t0, 1
no_add:
    beq t5, t3, no_sub
    nop
    nop
    nop
    nop
    addi t0, t0, -1
no_sub:
    bge t0, zero, no_negative
    nop
    nop
    nop
    nop
    addi t0, zero, 0
no_negative: 
    blt t0, t6, no_overvalue
    nop
    nop
    nop
    nop
    addi t0, t1, 0
no_overvalue:

    sw t0, 0(a0)
    sw t0, 0(a0)

    addi t2, t4, 0
    addi t3, t5, 0

	beq zero, zero, main_loop
    nop
    nop
    nop
    nop