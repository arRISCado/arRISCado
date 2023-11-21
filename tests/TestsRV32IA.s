# RV32I and RV32A Assembly Test

.option nopic
.text
.align	2
.globl	_main
.type	_main, @function

_main:
    # Init
    addi x5, x0, 1
    addi x6, x0, 2
    addi x7, x0, 3

    # Instrução RV32I: ADD - Add
    add x10, x0, x0

    # Instrução RV32I: SLL - Shift Left Logical
    sll x11, x5, x6

    # Instrução RV32I: SLT - Set Less Than
    slt x12, x5, x6

    # Instrução RV32I: SLTU - Set Less Than Unsigned
    sltu x13, x5, x6

    # Instrução RV32I: XOR - XOR
    xor x14, x5, x6

    # Instrução RV32I: SRL - Shift Right Logical
    srl x15, x5, x6

    # Instrução RV32I: OR - OR
    or x16, x5, x6

    # Instrução RV32I: AND - AND
    and x17, x5, x6

    # Instrução RV32I: SUB - Subtract
    sub x10, x5, x6

    # Instrução RV32I: SRA - Shift Right Arithmetic
    sra x11, x5, x6

    # Instrução RV32A: LR.W - Load Reserved Word
    lr.w x12, (x5)

    # Instrução RV32A: SC.W - Store Conditional Word
    sc.w x13, x5, (x6)

    # Instrução RV32A: AMOSWAP.W - Atomic Memory Operation Swap Word
    amoswap.w x14, x5, (x11)

    # Instrução RV32A: AMOADD.W - Atomic Memory Operation Add Word
    amoadd.w x15, x5, (x11)

    # Instrução RV32A: AMOXOR.W - Atomic Memory Operation XOR Word
    amoxor.w x16, x5, (x11)

    # Instrução RV32A: AMOAND.W - Atomic Memory Operation AND Word
    amoand.w x17, x5, (x11)

    # Instrução RV32A: AMOOR.W - Atomic Memory Operation OR Word
    amoor.w x18, x5, (x11)

    # Instrução RV32A: AMOMIN.W - Atomic Memory Operation Minimum Word
    amomin.w x19, x5, (x11)

    # Instrução RV32A: AMOMAX.W - Atomic Memory Operation Maximum Word
    amomax.w x21, x5, (x11)

    # Instrução RV32A: AMOMINU.W - Atomic Memory Operation Minimum Unsigned Word
    amominu.w x22, x5, (x11)

    # Instrução RV32A: AMOMAXU.W - Atomic Memory Operation Maximum Unsigned Word
    amomaxu.w x23, x5, (x11)
