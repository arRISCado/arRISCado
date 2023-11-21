# Exemplo de código em assembly RISC-V com instruções compactas

# Registradores de destino (rd): x10-x27 (Pode repetir)
# Registradores de origem (rs1): x0, x5-x7
# Valores imediatos (imm): random

    .option nopic
    .text
    .align	2
    .globl	_main
    .type	_main, @function

_main:
    # Inicialização de registradores para valores arbitrários
    li x5, 10
    li x6, 20
    li x7, 30

    # Instruções comprimidas

    # c.lw    rd, rs1, imm
    lw x10, 0(sp)

    # c.lwsp  rd, imm
    # lwsp x11, 0(sp)           // unrecognized opcode

    # c.sw    rs1, rs2, imm
    sw x5, 0(sp)

    # c.swsp  rs2, imm
    # swsp x6, 0(sp)            // unrecognized opcode

    # c.add       rd, rs1
    # add x14, x5               // illegal operands

    # c.addi      rd, imm
    # addi x16, 100             // illegal operands

    # c.addi16sp  rd, imm
    # addi16sp x18, 300             // illegal operands

    # c.addi4spn  rd, imm
    # addi4spn x19, 400             // illegal operands

    # c.li        rd, imm
    li x20, 500

    # c.mv        rd, rs1
    mv x21, x7

    # c.sub       rd, rs1
    # sub x22, x5               // illegal operands

    # c.slli      rd, imm
    # slli x24, 2               // illegal operands

    # c.srli      rd, imm
    # srli x25, 4               // illegal operands

    # c.srai      rd, imm
    # srai x26, 6               // illegal operands

    # c.and       rd, rs1
    # and x27, x7               // illegal operands

    # c.or        rd, rs1
    # or x10, x5                // illegal operands

    # c.xor       rd, rs1
    # xor x11, x6               // illegal operands

    # c.andi      rd, imm
    # andi x12, 15              // illegal operands

    # c.beqz      rs1, offset
    beqz x7, part1

part1:
    # c.bnez      rs1, offset
    bnez x5, part2

part2:
    # c.j         offset
    j part3

part3:
    # c.jr        rd, rs1
    jr x6

part4:
    # c.jal       offset
    jal part5

part5:
    # c.jalr      rd, rs1
    jalr x7

part6:
    # c.nop
    nop
