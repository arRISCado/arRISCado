# Tests Benches

Os testbenches são usados na verificação de hardware e permitem simular o
comportamento de módulos, circuitos e sistemas eletrônicos em um ambiente de
simulação, em vez de exigir uma FPGA real. Isso é útil para testar e depurar
designs antes de implementá-los em hardware físico.

Os testes atuais são:

- [alu_tb.v](alu_tb.v): Testa as operações da [Alu](../project/cpu/alu.v).
- [cpu_tb.v](cpu_tb.v): Testa as operações na [CPU](../project/cpu.v) com todos os módulos.
- [fetch_decode_tb.v](fetch_decode_tb.v): Testa o conjunto dos modulos de [fetch](../project/cpu/fetch.v) e [decode](../project/cpu/decode.v).
- [fetch_tb.v](fetch_tb.v): Testa o módulo de [fetch](../project/cpu/fetch.v); verifica o andamento do pc e possiveis saltos.
- [if_de_ex_tb.v](if_de_ex_tb.v): Testa os módulos de [fetch](../project/cpu/fetch.v), [decode](../project/cpu/decode.v) e [execute](../project/cpu/execute.v).
- [if_de_ex_wb_tb.v](if_de_ex_wb_tb.v): Testa os módulos de [fetch](../project/cpu/fetch.v), [decode](../project/cpu/decode.v], [execute](../project/cpu/execute.v) e [writeback](../project/cpu/writeback.v).
- [instruction_tb.v](instruction_tb.v): Serve para testar os sinais para cada instrução.
- [memory_tb.v](memory_tb.v): Testa as operações da [Memory](../project/cpu/memory.v).
- [ram_tb.v](ram_tb.v): Testa o módulo da [ram](../project/ram.v).
- [rom_tb.v](rom_tb.v): Testa o módulo da [rom](../project/rom.v).
- [writeback_tb.v](writeback_tb.v): Testa as operações da [Writeback](../project/cpu/writeback.v).

Adicionais:

- [cpu_tb.txt](cpu_tb.txt): Serve como set de instruções para o [cpu_tb.v](cpu_tb.v).
- [if_de_ex_wb_tb.txt](if_de_ex_wb_tb.txt): Serve como set de instruções para o [if_de_ex_wb_tb.v](if_de_ex_wb_tb.v).
- [instruction_tb_rom.txt](instruction_tb_rom.txt): Serve como instruções para o [test.py](../test.py) e o [instruction_tb.v](instruction_tb.v).

## TO DO

- Melhorar testbenches do módulo de writeback, e register_bank.
