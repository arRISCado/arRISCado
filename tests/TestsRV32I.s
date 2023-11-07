# RV32I Assembly Example

	.option nopic
	.text
	.align	2
	.globl	_start
	.type	_start, @function

_start:
  # LUI - Load Upper Immediate
  lui x1, 0x12345     # Carrega o endereço da mensagem no x1

  # AUIPC - Add Upper Immediate to PC
  auipc x2, 0x0       # x2 = PC + 0x0

  # JAL - Jump and Link
  jal x3, jump_target  # Salta para jump_target e armazena o endereço de retorno em x3

  # JALR - Jump and Link Register
  jalr x4, x2, 0      # Salta para o endereço em x2 e armazena o endereço de retorno em x4

  jump_target:
    # BEQ - Branch if Equal
    beq x3, x4, equal_label

    # BNE - Branch if Not Equal
    bne x3, x4, not_equal_label

    # BLT - Branch if Less Than
    blt x3, x4, less_than_label

    # BGE - Branch if Greater or Equal
    bge x3, x4, greater_equal_label

    # BLTU - Branch if Less Than Unsigned
    bltu x3, x4, less_than_unsigned_label

    # BGEU - Branch if Greater or Equal Unsigned
    bgeu x3, x4, greater_equal_unsigned_label

  equal_label:
    # Executa se beq for verdadeiro

  not_equal_label:
    # Executa se bne for verdadeiro

  less_than_label:
    # Executa se blt for verdadeiro

  greater_equal_label:
    # Executa se bge for verdadeiro

  less_than_unsigned_label:
    # Executa se bltu for verdadeiro

  greater_equal_unsigned_label:
    # Executa se bgeu for verdadeiro

  # Load Byte (LB)
  lb x5, 0(x1)

  # Load Half (LH)
  lh x6, 2(x1)

  # Load Word (LW)
  lw x7, 4(x1)

  # Load Byte Unsigned (LBU)
  lbu x8, 6(x1)

  # Load Half Unsigned (LHU)
  lhu x9, 8(x1)

  # Store Byte (SB)
  sb x5, 12(x1)

  # Store Half (SH)
  sh x6, 14(x1)

  # Store Word (SW)
  sw x7, 16(x1)

  # ADDI - Add Immediate
  addi x10, x7, 100

  # SLTI - Set Less Than Immediate
  slti x11, x7, 200

  # SLTIU - Set Less Than Immediate Unsigned
  sltiu x12, x7, 300

  # XORI - XOR Immediate
  xori x13, x7, 0x55

  # ORI - OR Immediate
  ori x14, x7, 0xAA

  # ANDI - AND Immediate
  andi x15, x7, 0xF0

  # SLLI - Shift Left Logical Immediate
  slli x16, x7, 2

  # SRLI - Shift Right Logical Immediate
  srli x17, x7, 3

  # SRAI - Shift Right Arithmetic Immediate
  srai x18, x7, 2

  # ADD - Add
  add x19, x7, x10

  # SUB - Subtract
  sub x20, x7, x10

  # SLL - Shift Left Logical
  sll x21, x7, x10

  # SLT - Set Less Than
  slt x22, x7, x10

  # SLTU - Set Less Than Unsigned
  sltu x23, x7, x10

  # XOR - XOR
  xor x24, x7, x10

  # SRL - Shift Right Logical
  srl x25, x7, x10

  # SRA - Shift Right Arithmetic
  sra x26, x7, x10

  # OR - OR
  or x27, x7, x10

  # AND - AND
  and x28, x7, x10

  # Exit
  ecall
