`ifndef TESTBENCH
`define TESTBENCH 1
`endif

`include "../../project/ram.v"
`include "../../project/rom.v"
`include "../../project/cpu/register_bank.v"
`include "../../project/cpu/alu.v"
`include "../../project/cpu/fetch.v"
`include "../../project/cpu/decode.v"
`include "../../project/cpu/execute.v"
`include "../../project/cpu/memory.v"
`include "../../project/cpu/writeback.v"
`include "../../project/cpu.v"
`include "../../project/peripheral/peripheral_manager.v"
`include "../../project/peripheral/pwm_port.v"
