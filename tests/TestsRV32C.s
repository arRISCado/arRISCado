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
    c.lw x10, 0(sp)

    # c.lwsp  rd, imm
    c.lwsp x11, 0(sp)

    # c.ld    rd, rs1, imm
    c.ld x12, 0(sp)

    # c.ldsp  rd, imm
    c.ldsp x13, 0(sp)

    # c.sw    rs1, rs2, imm
    c.sw x5, 0(sp)

    # c.swsp  rs2, imm
    c.swsp x6, 0(sp)

    # c.sd    rs1, rs2, imm
    c.sd x7, 0(sp)

    # c.sdsp  rs2, imm
    c.sdsp x7, 0(sp)

    # c.add       rd, rs1
    c.add x14, x5

    # c.addw      rd, rs1
    c.addw x15, x6

    # c.addi      rd, imm
    c.addi x16, x7, 100

    # c.addiw     rd, imm
    c.addiw x17, x5, 200

    # c.addi16sp  rd, imm
    c.addi16sp x18, 300

    # c.addi4spn  rd, imm
    c.addi4spn x19, x6, 400

    # c.li        rd, imm
    c.li x20, 500

    # c.mv        rd, rs1
    c.mv x21, x7

    # c.sub       rd, rs1
    c.sub x22, x5

    # c.subw      rd, rsw
    c.subw x23, x6

    # c.slli      rd, imm
    c.slli x24, x7, 2

    # c.srli      rd, imm
    c.srli x25, x5, 1

    # c.srai      rd, imm
    c.srai x26, x6, 1

    # c.and       rd, rs1
    c.and x27, x7

    # c.or        rd, rs1
    c.or x10, x5

    # c.xor       rd, rs1
    c.xor x11, x6

    # c.andi      rd, imm
    c.andi x12, x7, 15

    # c.ori       rd, imm
    c.ori x13, x5, 255

    # c.xori      rd, imm
    c.xori x14, x6, 127

    # c.beqz      rs1, imm
    c.beqz x7, 100

    # c.bnez      rs1, imm
    c.bnez x5, 200

    # c.j         imm
    c.j 300

    # c.jr        rd, rs1
    c.jr x6

    # c.jal       imm
    c.jal 400

    # c.jalr      rd, rs1
    c.jalr x7
