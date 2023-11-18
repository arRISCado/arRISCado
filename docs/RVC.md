# Extenção de instruções - RVC

Segue a baixo as instruções compactas adicionadas nessa extenção:

**Instruções de Load:**
- c.lw    rd, rs1, imm          // 32 bits
- c.lwsp  rd, imm               // 32 bits
- c.ld    rd, rs1, imm          // 64 bits
- c.ldsp  rd, imm               // 64 bits

**Instruções de Store:**
- c.sw    rs1, rs2, imm         // 32 bits
- c.swsp  rs2, imm              // 32 bits
- c.sd    rs1, rs2, imm         // 64 bits
- c.sdsp  rs2, imm              // 64 bits

**Instruções Aritméticas:**
- c.add       rd, rs1
- c.addw      rd, rs1           // 64 bits
- c.addi      rd, imm
- c.addiw     rd, imm           // 64 bits
- c.addi16sp  rd, imm
- c.addi4spn  rd, imm
- c.li        rd, imm
- c.mv        rd, rs1
- c.sub       rd, rs1
- c.subw      rd, rsw           // 64 bits

**Instruções Lógicas:**
- c.and       rd, rs1
- c.or        rd, rs1
- c.xor       rd, rs1
- c.andi      rd, imm

**Instruções de Deslocamento:**
- c.slli      rd, imm
- c.srli      rd, imm
- c.srai      rd, imm

**Instruções de Branche:**
- c.beqz      rs1, imm
- c.bnez      rs1, imm

**Instruções de Controle de Fluxo:**
- c.j         offset
- c.jr        rd, rs1
- c.jal       offset
- c.jalr      rd, rs1

**Instrução Nula :**
- nop
