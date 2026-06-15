# RISC-V Single-Cycle Processor in Verilog

## Joshua Menchaca

## Objective

The objective of this project is to implement a basic **RISC-V RV32I processor architecture** using a **single-cycle design** in Verilog.

The processor integrates the main functional blocks required to execute instructions, including instruction fetch, decode, register access, immediate generation, ALU execution, memory access, and write-back.

The design was verified through simulation using a testbench, observing key internal signals such as the program counter, current instruction, ALU result, data written to memory, and memory write control signal.

---

## Project Description

This project implements a simplified RISC-V single-cycle processor. In a single-cycle architecture, each instruction is executed in one complete clock cycle from the perspective of the datapath control flow.

The processor was designed in a modular way, where each block was implemented as an independent Verilog module and then connected inside the main `top_module`.

The design supports the basic structure required for instructions such as:

* Arithmetic instructions
* Immediate-type instructions
* Load instructions
* Store instructions
* Branch instructions
* Jump instructions

During simulation, a small test program was loaded into instruction memory using a hexadecimal file.

---

## Requirements

To understand and run this project, the following knowledge and tools are recommended:

### Knowledge Requirements

* Basic computer architecture concepts.
* Understanding of instruction execution stages.
* Familiarity with the RISC-V RV32I instruction set.
* Digital design using Verilog HDL.
* Basic use of testbenches and waveform simulation.

### Tools Used

* Verilog HDL
* OSS CAD Suite
* Icarus Verilog
* GTKWave
* Visual Studio Code

Other recommended tools:

* ModelSim
* Quartus
* OSS CAD Suite

---

## Functional Blocks

The processor is divided into different modules. Each module performs a specific function inside the datapath.

| Module               | Main Function                                                                 |
| -------------------- | ----------------------------------------------------------------------------- |
| `program_counter`    | Stores and updates the address of the current instruction.                    |
| `instruction_memory` | ROM memory that stores the program instructions.                              |
| `reg_file`           | Register bank with 32 registers of 32 bits.                                   |
| `imm_gen`            | Generates immediate values depending on the instruction type.                 |
| `alu_control`        | Generates the ALU operation signal based on `alu_op`, `funct3`, and `funct7`. |
| `alu`                | Performs arithmetic and logic operations.                                     |
| `control_unit`       | Generates the main control signals according to the opcode.                   |
| `data_memory`        | RAM memory used for load and store instructions.                              |
| `multiplexor`        | Selects between different datapath signals.                                   |
| `adder`              | Adds addresses, mainly for `PC + 4` and branch/jump target calculations.      |
| `top_module`         | Main module that connects all processor blocks.                               |
| `top_module_tb`      | Testbench used to simulate the complete processor.                            |

---

## Processor Datapath

The general datapath of the processor follows this structure:

```text
Program Counter
      |
      v
Instruction Memory
      |
      v
Control Unit -------------------
      |                         |
      v                         v
Register File              ALU Control
      |                         |
      v                         |
Immediate Generator             |
      |                         |
      v                         v
      -----------> ALU <---------
                    |
                    v
              Data Memory
                    |
                    v
              Write Back Mux
                    |
                    v
              Register File
```

The Program Counter normally increments by 4 after each instruction. For branch or jump instructions, the next PC can be changed to a target address calculated using an immediate value.

---

## Project Structure

The suggested structure for the project is:

```text
RISC_V/
│
├── top_module.v
├── top_module_tb.v
├── program_counter.v
├── instruccion_memory.v
├── reg_file.v
├── imm_gen.v
├── control_unit.v
├── alu_control.v
├── alu.v
├── adder.v
├── multiplexor.v
├── data_memory.v
└── instrMem.hex
```

In this project, the main module is:

```text
top_module.v
```

The simulation testbench is:

```text
top_module_tb.v
```

The instruction program is loaded from:

```text
instrMem.hex
```

---

## Module Descriptions

## 1. Program Counter

The `program_counter` module stores the current instruction address.

It receives:

* `clk`
* `rst`
* `pc_next`

It outputs:

* `pc_out`

When reset is active, the PC is set to zero. Otherwise, the PC updates with the next address.

```verilog
program_counter DUT_PC(
    .clk(clk), 
    .rst(rst), 
    .pc_next(pc_next), 
    .pc_out(pc)
);
```

---

## 2. Instruction Memory

The `instruction_memory` module stores the program instructions.

The instructions are loaded using:

```verilog
$readmemh("instrMem.hex", instr_mem);
```

The memory receives the current PC as the address and outputs the instruction.

In this implementation, the instruction memory is synchronous, meaning the instruction is updated on the positive edge of the clock.

```verilog
instruction_memory DUT_IMEM(
    .clk(clk),
    .A(pc),
    .RD(instruction)
);
```

Current instruction memory size:

```verilog
reg [31:0] instr_mem [0:2];
```

This means the memory currently stores 3 instructions.

---

## 3. Register File

The `reg_file` module represents the RISC-V register bank.

It contains:

* 32 registers
* 32 bits per register
* Two read ports
* One write port

Inputs:

* `clk`
* `WE3`
* `A1`
* `A2`
* `A3`
* `WD3`

Outputs:

* `RD1`
* `RD2`

The register file reads two registers and writes one register when `WE3` is active.

```verilog
reg_file DUT_REGFILE( 
    .clk(clk), 
    .WE3(reg_write), 
    .A1(instruction[19:15]),
    .A2(instruction[24:20]),
    .A3(instruction[11:7]),
    .WD3(result),
    .RD1(rd1), 
    .RD2(rd2)
);
```

---

## 4. Immediate Generator

The `imm_gen` module extracts and sign-extends immediate values from the instruction.

It supports different instruction formats:

| `imm_src` | Instruction Type |
| --------- | ---------------- |
| `00`      | I-type           |
| `01`      | S-type           |
| `10`      | B-type           |
| `11`      | J-type           |

The immediate generator is connected as follows:

```verilog
imm_gen DUT_IMMGEN( 
    .instruction(instruction),
    .imm_src(imm_src),
    .imm_ext(imm_ext)
);
```

This module is important for instructions such as:

* `addi`
* `lw`
* `sw`
* `beq`
* `jal`

---

## 5. Control Unit

The `control_unit` module receives the opcode of the current instruction and generates the main control signals for the datapath.

Inputs:

* `op`
* `zero`

Outputs:

* `pc_src`
* `mem_write`
* `alu_src`
* `reg_write`
* `result_src`
* `imm_src`
* `alu_op`

Example connection:

```verilog
control_unit DUT_CONTROL( 
    .op(instruction[6:0]),
    .zero(zero),
    .pc_src(pc_src),
    .mem_write(mem_write), 
    .alu_src(alu_src), 
    .reg_write(reg_write), 
    .result_src(result_src), 
    .imm_src(imm_src), 
    .alu_op(alu_op)
);
```

The control unit determines whether the processor should write to a register, write to memory, select an immediate, branch, or use a specific result source.

---

## 6. ALU Control

The `alu_control` module determines the specific operation that the ALU must execute.

Inputs:

* `alu_op`
* `funct3`
* `funct7`

Output:

* `alu_control`

Example connection:

```verilog
alu_control DUT_ALUCONTROL( 
    .alu_op(alu_op), 
    .funct3(instruction[14:12]), 
    .funct7(instruction[30]), 
    .alu_control(alu_control)
);
```

This module allows the processor to distinguish between operations such as:

* ADD
* SUB
* AND
* OR
* SLT

---

## 7. ALU

The `alu` module performs arithmetic and logic operations.

Inputs:

* `a`
* `b`
* `alu_control`

Outputs:

* `result`
* `zero`

Example connection:

```verilog
alu DUT_ALU( 
    .a(rd1), 
    .b(src_b), 
    .alu_control(alu_control), 
    .result(alu_result), 
    .zero(zero)
);
```

The `zero` signal is used for branch instructions such as `beq`.

---

## 8. Data Memory

The `data_memory` module is used for load and store instructions.

Inputs:

* `clk`
* `WE`
* `A`
* `WD`

Output:

* `RD`

Example connection:

```verilog
data_memory DUT_DATAMEM(
    .clk(clk),
    .WE(mem_write),
    .A(alu_result),
    .WD(rd2),
    .RD(read_data)
);
```

For `sw`, the memory writes data when `mem_write = 1`.

For `lw`, the memory outputs the data stored in the selected address.

---

## 9. Multiplexers

The `multiplexor` module is a 4-input multiplexer of 32 bits.

It is used in different parts of the datapath:

### PC Selection

Selects between:

* `PC + 4`
* branch or jump target address

```verilog
multiplexor DUT_MUX_PC(
    .A(pc4),
    .B(pc_target),
    .C(32'b0),
    .D(32'b0),
    .Sel({1'b0, pc_src}),
    .Y(pc_next)
);
```

### ALU Source B Selection

Selects between:

* register data `rd2`
* immediate value `imm_ext`

```verilog
multiplexor DUT_MUX_ALU_B(
    .A(rd2),
    .B(imm_ext),
    .C(32'b0),
    .D(32'b0),
    .Sel({1'b0, alu_src}),
    .Y(src_b)
);
```

### Write Back Result Selection

Selects between:

* ALU result
* data memory output
* `PC + 4`

```verilog
multiplexor DUT_MUX_RESULT(
    .A(alu_result),
    .B(read_data),
    .C(pc4),
    .D(32'b0),
    .Sel(result_src),
    .Y(result)
);
```

---

## 10. Adder

The `adder` module is used to calculate:

* `PC + 4`
* `PC + immediate`

Example:

```verilog
adder DUT_PC4( 
    .a(pc), 
    .b(32'd4), 
    .result(pc4)
);
```

Another adder is used to calculate the target address:

```verilog
adder DUT_PCTARGET( 
    .a(pc), 
    .b(imm_ext), 
    .result(pc_target)
);
```

---

## Top Module

The `top_module` connects all the processor modules.

The top module has only two inputs:

```verilog
input clk;
input rst;
```

This keeps the processor design clean. All internal datapath signals are declared and connected inside the module.

The main internal signals include:

```verilog
wire [31:0] pc;
wire [31:0] instruction;
wire [31:0] alu_result;
wire [31:0] read_data;
wire [31:0] result;
wire mem_write;
wire reg_write;
wire alu_src;
wire pc_src;
```

---

## Test Program

The program used for simulation is stored in:

```text
instrMem.hex
```

Example contents:

```text
00500293
00a00313
00628533
```

These instructions represent:

```asm
addi x5, x0, 5
addi x6, x0, 10
add  x10, x5, x6
```

Expected behavior:

| Instruction       | Description              | Expected ALU Result |
| ----------------- | ------------------------ | ------------------- |
| `addi x5, x0, 5`  | Stores 5 in register x5  | `00000005`          |
| `addi x6, x0, 10` | Stores 10 in register x6 | `0000000a`          |
| `add x10, x5, x6` | Adds x5 and x6           | `0000000f`          |

Final expected result:

```text
5 + 10 = 15
```

---

## Testbench

The testbench file is:

```text
top_module_tb.v
```

It generates:

* Clock signal
* Reset signal
* VCD waveform file

The main monitored signals are:

```verilog
DUT.pc
DUT.instruction
DUT.alu_result
DUT.rd2
DUT.mem_write
```

Example testbench output:

```text
PC=00000000 | INST=00500293 | ALU=00000005 | WD=00000005 | MEMWRITE=0
PC=00000008 | INST=00a00313 | ALU=0000000a | WD=xxxxxxxx | MEMWRITE=0
PC=0000000c | INST=00628533 | ALU=0000000f | WD=0000000a | MEMWRITE=0
```

The output confirms that the ALU correctly computes:

```text
5
10
15
```

---

## Simulation Results

The simulation showed the following behavior:

1. The Program Counter starts at `00000000`.
2. The first instruction loaded is `00500293`.
3. The ALU computes `00000005`.
4. The second instruction loaded is `00a00313`.
5. The ALU computes `0000000a`.
6. The third instruction loaded is `00628533`.
7. The ALU computes `0000000f`.

This confirms that the processor correctly executes the basic arithmetic test program.

---

## Important Notes About the Simulation

At the beginning of the simulation, the instruction may appear as:

```text
INST=xxxxxxxx
```

This happens because the instruction memory is synchronous and needs one clock cycle to output the first instruction.

After the available instructions are executed, the output may again show:

```text
INST=xxxxxxxx
```

This happens because the current instruction memory only has three positions:

```verilog
reg [31:0] instr_mem [0:2];
```

Therefore, when the PC tries to access memory positions beyond `instr_mem[2]`, the result is undefined.

This behavior is expected with the current memory size.

---

## How to Compile and Run

Open a terminal in the project folder and run:

```bash
iverilog -o top.out top_module.v top_module_tb.v adder.v alu.v alu_control.v control_unit.v imm_gen.v instruccion_memory.v multiplexor.v program_counter.v reg_file.v data_memory.v
```

Then execute the simulation:

```bash
vvp top.out
```

To open the waveform file in GTKWave:

```bash
gtkwave top_module_tb.vcd
```

---

## Expected Output

A correct simulation should show something similar to:

```text
instr_mem[0] = 00500293
instr_mem[1] = 00a00313
instr_mem[2] = 00628533
VCD info: dumpfile top_module_tb.vcd opened for output.
PC=00000000 | INST=00500293 | ALU=00000005 | WD=00000005 | MEMWRITE=0
PC=00000008 | INST=00a00313 | ALU=0000000a | WD=xxxxxxxx | MEMWRITE=0
PC=0000000c | INST=00628533 | ALU=0000000f | WD=0000000a | MEMWRITE=0
```

---

## Verification Checklist

The following requirements were implemented or considered in the project:

| Requirement                        | Status      |
| ---------------------------------- | ----------- |
| Program Counter                    | Implemented |
| Instruction Memory                 | Implemented |
| Register File                      | Implemented |
| Immediate Generator                | Implemented |
| ALU Control                        | Implemented |
| ALU                                | Implemented |
| Control Unit                       | Implemented |
| Data Memory                        | Implemented |
| Multiplexers                       | Implemented |
| Adders                             | Implemented |
| Top module integration             | Implemented |
| Testbench simulation               | Implemented |
| Test program in hexadecimal format | Implemented |
| Waveform generation with VCD       | Implemented |

---

## Development Process

The project was developed using a modular design methodology:

1. Each component was written as an independent Verilog module.
2. The modules were connected in `top_module.v`.
3. A test program was written in hexadecimal format.
4. The processor was simulated using `top_module_tb.v`.
5. The output was verified through terminal results and waveform generation.

---

## Evidence of Execution

The simulation result shows that the processor fetches and executes the instructions stored in instruction memory.

The most important result is:

```text
ALU=0000000f
```

This corresponds to decimal 15, which confirms the correct execution of:

```asm
add x10, x5, x6
```

Where:

```text
x5 = 5
x6 = 10
x10 = 15
```

---

## Limitations

The current implementation is a simplified version of a RISC-V single-cycle processor.

Some limitations are:

* The instruction memory currently stores only 3 instructions.
* The test program mainly verifies arithmetic instructions.
* The branch comparator is represented through the ALU `zero` signal instead of a separate dedicated module.
* More instructions can be added by expanding the instruction memory and control logic.
* Additional test programs are needed to fully verify `lw`, `sw`, `beq`, `bne`, `jal`, and `jalr`.

---

## Future Improvements

Possible improvements for this project include:

* Increase the size of the instruction memory.
* Add a dedicated `branch_comparator` module.
* Add support for more RV32I instructions.
* Create more test programs for `lw`, `sw`, `beq`, `bne`, `jal`, and `jalr`.
* Improve waveform documentation.
* Add a complete datapath diagram.
* Create a final PDF report with module descriptions, simulation evidence, and analysis.

---

## Conclusion

This project demonstrates the implementation of a basic RISC-V single-cycle processor in Verilog.

The design connects the essential datapath components, including the Program Counter, Instruction Memory, Register File, Immediate Generator, Control Unit, ALU Control, ALU, Data Memory, Adders, and Multiplexers.

The simulation verifies that the processor can correctly execute a small RISC-V program. In the tested program, the processor loads immediate values into registers and performs an addition, obtaining the expected result of `15`.

This confirms the correct integration of the main modules and the basic functionality of the single-cycle RISC-V processor.
