# Demultiplexer (DEMUX) in SystemVerilog

## What is SystemVerilog? (Quick Recap)

SystemVerilog is a **hardware description language**. You are not writing a program that runs step-by-step — you are describing a **physical circuit** where all wires and gates operate simultaneously. The text gets converted into real hardware by a **synthesizer**.

If you haven't read the MUX README yet, start there — it covers all the core concepts (`logic`, `module`, `assign`, `always_comb`, number literals, and testbenches) in depth.

---

## What is a Demultiplexer?

A **demultiplexer (DEMUX)** is the **opposite of a MUX**:

- A **MUX** takes many inputs → selects one → sends it to one output.
- A **DEMUX** takes one input → selects a destination → sends it to one of many outputs.

Think of it like a train switch: one train (input) arrives, and the switch (select) determines which track (output) the train is sent down. All other tracks remain empty (0).

```
              ┌──► y[0]
              │
Input (d) ──►├──► y[1]   (only the selected output carries d;
              │            all others are 0)
              ├──► y[2]
              │
              └──► y[3]
                   ▲
                 sel[1:0]
```

---

## MUX vs DEMUX Side by Side

| Property        | MUX                          | DEMUX                          |
|-----------------|------------------------------|--------------------------------|
| Inputs          | Many (N)                     | One                            |
| Outputs         | One                          | Many (N)                       |
| Select purpose  | Picks which input to read    | Picks which output to write to |
| Unselected lines| Not connected to output      | Held at 0                      |
| Use case        | Sharing a bus, signal routing| Broadcasting to a single path  |

---

## Core Concepts

### The `y = 4'b0000` Default Pattern

The DEMUX has a key difference from a MUX: only **one output is active** at a time. Every other output must be 0. The cleanest way to express this is:

```systemverilog
always_comb begin
    y = 4'b0000;   // Start: drive all outputs to 0
    case (sel)
        2'b00: y[0] = d;  // Override just one output with the input value
        ...
    endcase
end
```

This two-step pattern ("clear everything, then set one") avoids the need to write `y[x] = 0` for every inactive output explicitly.

### Why Not Use `assign`?

You could write the 1-to-2 DEMUX with `assign`:

```systemverilog
assign y[0] = (~sel) & d;
assign y[1] = sel & d;
```

This works and is perfectly valid. However, for 4 outputs the `case` in `always_comb` is far more readable and scales cleanly to 8, 16, or 32 outputs. Both produce identical hardware.

---

## 1-to-2 DEMUX (`demux1to2.sv`)

### Schematic

```
        ┌──► y[0]
d ─────►│
        └──► y[1]
             ▲
            sel
```

### Truth Table

| sel | y[1] | y[0] |
|-----|------|------|
|  0  |  0   |  d   |
|  1  |  d   |  0   |

### Code Walkthrough

```systemverilog
module demux1to2 (
    input  logic       d,    // The single data input
    input  logic       sel,  // Which output to activate
    output logic [1:0] y     // 2-bit output bus: y[1] and y[0]
);

    always_comb begin
        case (sel)
            1'b0: begin          // begin...end groups multiple statements
                y[0] = d;        // send d to output 0
                y[1] = 1'b0;     // silence output 1
            end
            1'b1: begin
                y[0] = 1'b0;     // silence output 0
                y[1] = d;        // send d to output 1
            end
            default: y = 2'b00;  // safety default
        endcase
    end

endmodule
```

The `begin...end` pair inside a `case` branch works like `{ }` in C — it groups multiple statements into one block.

---

## 1-to-4 DEMUX (`demux1to4.sv`)

Uses a 2-bit select (00, 01, 10, 11 → 4 choices) to route one input to one of four outputs.

### Schematic

```
              ┌──► y[0]   (sel=00)
              │
d ───────────►├──► y[1]   (sel=01)
              │
              ├──► y[2]   (sel=10)
              │
              └──► y[3]   (sel=11)
                   ▲
                 sel[1:0]
```

### Truth Table

| sel[1:0] | y[3] | y[2] | y[1] | y[0] |
|----------|------|------|------|------|
|   00     |  0   |  0   |  0   |  d   |
|   01     |  0   |  0   |  d   |  0   |
|   10     |  0   |  d   |  0   |  0   |
|   11     |  d   |  0   |  0   |  0   |

### Code Walkthrough

```systemverilog
module demux1to4 (
    input  logic       d,    // One data input
    input  logic [1:0] sel,  // 2-bit select (4 destinations)
    output logic [3:0] y     // 4-bit output bus
);

    always_comb begin
        y = 4'b0000;   // Step 1: zero out all outputs
        case (sel)
            2'b00: y[0] = d;  // Step 2: override the selected output
            2'b01: y[1] = d;
            2'b10: y[2] = d;
            2'b11: y[3] = d;
            // No default needed here: y is already assigned above
        endcase
    end

endmodule
```

Notice there's no `default` branch — because `y = 4'b0000` at the top of the block already covers any undefined `sel` value. The synthesizer sees that all cases are covered.

---

## Testbench Walkthrough (`demux1to4_tb.sv`)

```systemverilog
module demux1to4_tb;       // No ports

    logic       d;
    logic [1:0] sel;
    logic [3:0] y;

    demux1to4 dut (.d(d), .sel(sel), .y(y));

    initial begin
        d = 1'b1;            // Send a logic 1 through the demux

        sel = 2'b00; #10;    // Expect y = 0001
        sel = 2'b01; #10;    // Expect y = 0010
        sel = 2'b10; #10;    // Expect y = 0100
        sel = 2'b11; #10;    // Expect y = 1000

        d = 1'b0;            // Now send 0 — all outputs stay 0

        sel = 2'b00; #10;    // Expect y = 0000
        ...
        $finish;
    end

endmodule
```

With `d=1`, each `sel` value lights up exactly one output. With `d=0`, all outputs are zero regardless of `sel` — proving the circuit correctly propagates the input value.

---

## How to Simulate

Using **Icarus Verilog** (free, open source):

```bash
# Compile design + testbench
iverilog -g2012 -o demux1to4_sim demux1to4.sv demux1to4_tb.sv

# Run
vvp demux1to4_sim
```

Expected output:
```
Time=0  | d=1 | sel=00 | y=0001 (y3=0 y2=0 y1=0 y0=1)
Time=10 | d=1 | sel=01 | y=0010 (y3=0 y2=0 y1=1 y0=0)
Time=20 | d=1 | sel=10 | y=0100 (y3=0 y2=1 y1=0 y0=0)
Time=30 | d=1 | sel=11 | y=1000 (y3=1 y2=0 y1=0 y0=0)
Time=40 | d=0 | sel=00 | y=0000 (y3=0 y2=0 y1=0 y0=0)
Time=50 | d=0 | sel=01 | y=0000 (y3=0 y2=0 y1=0 y0=0)
Time=60 | d=0 | sel=10 | y=0000 (y3=0 y2=0 y1=0 y0=0)
Time=70 | d=0 | sel=11 | y=0000 (y3=0 y2=0 y1=0 y0=0)
Simulation complete.
```

---

## Files in This Folder

| File              | Description                                             |
|-------------------|---------------------------------------------------------|
| `demux1to2.sv`    | Simple 1-to-2 DEMUX using case with explicit 0-outputs  |
| `demux1to4.sv`    | 1-to-4 DEMUX using the default-zero + case pattern      |
| `demux1to4_tb.sv` | Testbench: tests d=1 and d=0 across all select values   |

---

## Key Takeaways

- A DEMUX routes **one input to one of N outputs**; all other outputs are 0.
- With `k` select bits, you can route to `2^k` outputs (2 bits → 4 outputs).
- The `y = 0; case (...) y[sel] = d; endcase` pattern is the cleanest way to write a DEMUX.
- DEMUX + MUX pairs are fundamental to **bus arbitration**, **memory address decoding**, and **data routing** in real chips.
- Always cover the unselected outputs explicitly (drive to 0), or you risk inferred latches in synthesis.
