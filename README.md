# RV32I 5-Stage Pipelined Processor

FPGA implementation of a 32-bit RISC-V (RV32I) 5-stage
pipelined processor on PYNQ-Z2 using Vivado 2019.2.

## Features
- 5-stage pipeline: IF, ID, EX, MEM, WB
- Hazard detection unit with stall logic
- Data forwarding unit (EX and MEM forwarding)
- Switch-controlled LED output display
- Compiled C program loaded via program.hex

## Switch LED Mapping
| SW1 | SW0 | Register | Value | LED Pattern |
|-----|-----|----------|-------|-------------|
|  0  |  0  | x3 sum   |  8    | 1000        |
|  0  |  1  | x4 diff  |  2    | 0010        |
|  1  |  0  | x5 and   |  1    | 0001        |
|  1  |  1  | x6 or    |  7    | 0111        |

## Files
| File               | Description         |
|--------------------|---------------------|
| rv32i_pipeline.v   | Top-level module    |
| pc_reg.v           | Program counter     |
| instr_mem.v        | Instruction memory  |
| reg_file.v         | Register file       |
| imm_gen.v          | Immediate generator |
| control_unit.v     | Control unit        |
| alu.v              | ALU                 |
| data_mem.v         | Data memory         |
| hazard_unit.v      | Hazard detection    |
| forwarding_unit.v  | Data forwarding     |
| tb_rv32i.v         | Testbench           |
| rv32constraints.xdc| PYNQ-Z2 constraints |
| program.hex        | Compiledtestprogram |

## Board
- PYNQ-Z2 (XC7Z020CLG400-1)
- Vivado 2019.2
- Clock: 10 MHz
- Language: Verilog HDL



## Author
D. NAGA JASWANTH
