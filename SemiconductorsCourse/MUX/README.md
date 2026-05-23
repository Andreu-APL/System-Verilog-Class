# Multiplexer (MUX) in SystemVerilog

## What is SystemVerilog?

SystemVerilog is a **hardware description language (HDL)**. Unlike Python or Java — which describe instructions for a CPU to execute one at a time — SystemVerilog describes **actual hardware circuits**: wires, logic gates, and flip-flops that all operate **simultaneously**.

When you write SystemVerilog, you are not programming a computer. You are **drawing a circuit** in text form. A tool called a **synthesizer** converts that text into a real gate-level netlist that can be manufactured on a chip or loaded onto an FPGA.

---

## Core Concepts Before Reading the Code

### 1. Signals and Data Types

In hardware, values travel on **wires**. In SystemVerilog, the main data type is `logic`:

```systemverilog
logic a;       // 1-bit wire — can be 0 or 1
logic [3:0] d; // 4-bit bus — d[3], d[2], d[1], d[0]
logic [1:0] sel; // 2-bit bus — sel[1], sel[0]
```

`[3:0]` means bits 3 down to 0, giving 4 bits total. The leftmost index is always the most significant bit (MSB).

### 2. Modules

A **module** is the fundamental building block of a hardware design — like a function in software, but it represents a **physical circuit block** with input and output pins.

```systemverilog
module my_circuit (
    input  logic a,   // input pin
    output logic y    // output pin
);
    // circuit logic goes here
endmodule
```

### 3. Continuous Assignment (`assign`)

`assign` creates a **permanent wire connection**. Whenever the right side changes, the left side instantly updates — there is no clock cycle delay.

```systemverilog
assign y = a & b;  // y is always the AND of a and b
```

### 4. The Ternary Operator

`condition ? value_if_true : value_if_false` works just like in C or JavaScript, but here it describes a **hardware multiplexer**:

```systemverilog
assign y = sel ? b : a;  // if sel=1 then y=b, else y=a
```

### 5. `always_comb` Block

`always_comb` is a block of **combinational logic** (no clock, no memory). It re-evaluates automatically whenever any input signal changes. Use it for more complex logic like `case` statements.

### 6. Number Literals

SystemVerilog uses the format `<width>'<base><value>`:

| Literal  | Meaning                        |
|----------|--------------------------------|
| `1'b0`   | 1-bit binary 0                 |
| `2'b10`  | 2-bit binary value 10 (= 2)   |
| `4'b1010`| 4-bit binary 1010 (= 10)      |
| `8'hFF`  | 8-bit hexadecimal FF (= 255)  |

### 7. Testbenches

A **testbench** is a simulation-only file. It has no ports because it doesn't connect to anything in real hardware — its only job is to **apply inputs and verify outputs** during simulation. You run it with a simulator like ModelSim, Vivado, or VCS.

---

## What is a Multiplexer?

A **multiplexer (MUX)** is a circuit that acts like a **channel selector**. It takes multiple input signals and routes exactly one of them to the output, based on a **select signal**.

Think of it like a TV remote: you have many channels (inputs), and the channel number you press (select) determines what appears on screen (output).

```
Inputs ──┐
         ├──[ MUX ]──► Output
Select ──┘
```

---

## 2-to-1 MUX (`mux2to1.sv`)

The simplest MUX: choose between 2 inputs.

### Schematic

```
a ──────┐
        ├──[ MUX 2:1 ]──► y
b ──────┘
        ▲
       sel
```

### Truth Table

| sel | y   |
|-----|-----|
|  0  |  a  |
|  1  |  b  |

### Code Walkthrough

```systemverilog
module mux2to1 (
    input  logic a,    // Input 0: selected when sel=0
    input  logic b,    // Input 1: selected when sel=1
    input  logic sel,  // The selector switch
    output logic y     // The chosen input appears here
);

    assign y = sel ? b : a;
    //         ──── ─   ─
    //          │   │   └── if sel=0, output a
    //          │   └────── if sel=1, output b
    //          └────────── condition: check sel

endmodule
```

This single `assign` line describes the entire circuit. There are no loops, no sequential steps — this is **one logical gate** that always evaluates.

---

## 4-to-1 MUX (`mux4to1.sv`)

Extends the idea to 4 inputs using a 2-bit select (2 bits → 4 combinations).

### Schematic

```
d[0] ──┐
d[1] ──┤
       ├──[ MUX 4:1 ]──► y
d[2] ──┤
d[3] ──┘
       ▲
     sel[1:0]
```

### Truth Table

| sel[1] | sel[0] | y    |
|--------|--------|------|
|   0    |   0    | d[0] |
|   0    |   1    | d[1] |
|   1    |   0    | d[2] |
|   1    |   1    | d[3] |

### Code Walkthrough

```systemverilog
module mux4to1 (
    input  logic [3:0] d,    // 4 inputs packed into a 4-bit bus
    input  logic [1:0] sel,  // 2-bit select: 00,01,10,11 → 4 options
    output logic       y     // one output
);

    always_comb begin          // combinational block: runs on any input change
        case (sel)             // examine sel's value
            2'b00: y = d[0];  // sel=0 → pass d[0] to output
            2'b01: y = d[1];  // sel=1 → pass d[1] to output
            2'b10: y = d[2];  // sel=2 → pass d[2] to output
            2'b11: y = d[3];  // sel=3 → pass d[3] to output
            default: y = 1'b0; // safety: cover any undefined sel value
        endcase
    end

endmodule
```

The `case` statement maps directly to a hardware **decoder + gate network**. The `default` branch is important: without it, some synthesizers infer unwanted latches.

---

## Testbench Walkthrough (`mux4to1_tb.sv`)

```systemverilog
module mux4to1_tb;   // No ports — testbenches are self-contained

    logic [3:0] d;   // local signals to drive the DUT
    logic [1:0] sel;
    logic       y;

    // Instantiate the module being tested
    mux4to1 dut (
        .d   (d),    // .port_name(signal_name)
        .sel (sel),
        .y   (y)
    );

    initial begin              // initial: runs once at simulation start
        d = 4'b1010;
        sel = 2'b00; #10;     // apply sel=0, wait 10 time units
        sel = 2'b01; #10;     // apply sel=1, wait 10 time units
        ...
        $finish;               // end simulation
    end

endmodule
```

`#10` means **"wait 10 time units"** — in simulation, this advances the clock. In real hardware there is no such pause; the `.` operator in port connections (`.d(d)`) connects the module's port named `d` to our local signal named `d`.

---

## How to Simulate

Using **Icarus Verilog** (free, open source):

```bash
# Compile both the design and testbench
iverilog -g2012 -o mux4to1_sim mux4to1.sv mux4to1_tb.sv

# Run the simulation
vvp mux4to1_sim
```

Expected output:
```
Time=0  | d=1010 | sel=00 | y=0
Time=10 | d=1010 | sel=01 | y=1
Time=20 | d=1010 | sel=10 | y=0
Time=30 | d=1010 | sel=11 | y=1
Time=40 | d=1100 | sel=00 | y=0
Time=50 | d=1100 | sel=01 | y=0
Time=60 | d=1100 | sel=10 | y=1
Time=70 | d=1100 | sel=11 | y=1
Simulation complete.
```

---

## Files in This Folder

| File            | Description                                      |
|-----------------|--------------------------------------------------|
| `mux2to1.sv`    | Simple 2-to-1 MUX using a ternary assign         |
| `mux4to1.sv`    | 4-to-1 MUX using always_comb + case statement    |
| `mux4to1_tb.sv` | Testbench: drives inputs and prints results      |

---

## Key Takeaways

- A MUX selects **one of N inputs** and routes it to the output.
- The **select bits** determine which input is chosen. With `k` select bits you can address `2^k` inputs.
- `assign` is a permanent wire; `always_comb` is a combinational logic block — both produce **no clock dependency**.
- Always include a `default` in `case` statements to avoid inferred latches.
- Testbenches exist only in simulation — they have no ports and use `#delay` to sequence events.
