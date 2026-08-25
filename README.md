# RISC-V Single-Cycle CPU (SystemVerilog)

A single-cycle RISC-V CPU implementing a subset of the RV32I base integer instruction set, built from scratch in SystemVerilog as a first hardware design project. Verified entirely in simulation (Verilator / Icarus Verilog), with every module unit-tested individually before integration.

## Overview

This CPU implements the classic single-cycle datapath: every instruction fetches, decodes, executes, accesses memory, and writes back in exactly one clock cycle. It supports 9 instructions covering arithmetic, immediates, memory access, and branching — enough to run real (if small) programs involving loops, comparisons, and memory reads/writes.

## Supported Instructions

| Instruction | Format | Description |
|---|---|---|
| `add`  | R | `rd = rs1 + rs2` |
| `sub`  | R | `rd = rs1 - rs2` |
| `and`  | R | `rd = rs1 & rs2` |
| `or`   | R | `rd = rs1 \| rs2` |
| `slt`  | R | `rd = (rs1 < rs2) ? 1 : 0` |
| `addi` | I | `rd = rs1 + imm` |
| `lw`   | I | `rd = M[rs1 + imm]` |
| `sw`   | S | `M[rs1 + imm] = rs2` |
| `beq`  | B | `if (rs1 == rs2) PC += imm` |

## Architecture

Eight independently designed and tested modules, wired together in a top-level `CPU` module:

- **ALU** — performs all arithmetic/logic operations; outputs a result and a zero flag (used for branch comparisons)
- **Register File** — 32×32-bit registers, two combinational read ports, one synchronous write port; `x0` is hardwired to zero
- **Immediate Generator** — extracts and sign-extends immediates from I/S/B-type instructions
- **Control Unit** — decodes opcode/funct3/funct7 into control signals (`reg_wr`, `alu_src`, `mem_rd`, `mem_wr`, `mem_to_reg`, `branch`, `alu_op`)
- **Instruction Memory** — 64-word ROM, loaded via `$readmemh` from a hex program file
- **Data Memory** — 64-word RAM, synchronous write / combinational read
- **PC** — clocked register holding the current instruction address
- **PC Adder** — computes `PC+4` and `PC+immediate`, selecting between them based on branch outcome

## Repository Structure

```
cpu-comp/
  alu.sv
  reg_file.sv
  imm_gen.sv
  control_unit.sv
  instr_mem.sv
  data_mem.sv
  pc.sv
  pc_adder.sv
cpu_top.sv          # top-level module wiring everything together  
packages.sv        # shared enum/type definitions
tests/
  *_tb.sv             # one testbench per module
cpu_tb.sv            # end-to-end testbenches
program.hex          # test program 1: arithmetic, memory, taken branch
```

## Testing

Every module has its own dedicated testbench, run and verified independently before integration:

- **ALU** — all 6 operations, including negative operands and the zero flag
- **Register File** — read/write correctness, `x0` write-blocking and zero-read behavior, write-enable gating
- **Immediate Generator** — sign extension for positive and negative immediates across I/S/B formats
- **Control Unit** — correct signal generation for all 9 instructions plus a safe default for unrecognized opcodes
- **Instruction Memory / Data Memory / PC / PC Adder** — read/write correctness and branch-decision logic

Two end-to-end test programs run the fully integrated CPU:
- **Program 1** — arithmetic, `addi`, `lw`/`sw`, and a **taken** branch (confirms the branch correctly skips an instruction)
- **Program 2** — `and`/`or`/`slt` through the full datapath, and a **not-taken** branch (confirms execution falls through correctly)
- Program 1 EDA link: https://edaplayground.com/x/8zU4
- Program 2 EDA link: https://edaplayground.com/x/A52q
  

## Known Limitations / Future Work

- No halt instruction — the PC continues incrementing past the end of a program (simulations are stopped externally after a fixed number of cycles)
- No pipelining — every instruction takes a full cycle regardless of complexity
- Only 9 of the ~40 RV32I instructions are implemented (no shifts, xor as a standalone op is implemented in the ALU but unused by any decoded instruction, no jumps/`jal`/`jalr`, no `lui`/`auipc`)
- Not synthesized to real hardware — verified functionally in simulation only, no timing/synthesis results

## Background

Built as my first project in SystemVerilog and digital design, starting from no prior hardware experience. I was not sure about my career path but after taking 18-213 (Intro. to Computer Systems), I wanted to take a deeper dive in to hardware/computer engineering. I find the way these components all work together really fascinating and it almost just feels like magic. The learning process was a true captivator. These processes are so complex yet so simple, the work behind the scenes that allow the CPU to actually execute programs is so bizarre to me. I've learned mostly everything
