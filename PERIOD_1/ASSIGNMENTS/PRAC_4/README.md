# Practice 4: Password FSM

## Description
This project implements a Finite State Machine (FSM) that detects a specific sequence of inputs. The system transitions through states based on the input signal, effectively acting as a password or sequence detector. When the correct sequence is detected, the output signal is asserted.

## Modules
*   **prac4.v**: The core FSM logic.
    *   **Inputs**: `rst`, `clk`, `in`
    *   **Outputs**: `out`
    *   **States**: `idle`, `S1`, `S2`, `S3`, `S4`, `bad`, `gut`
*   **main.v**: Top-level module connecting the FSM to the MAX10 Lite peripherals.
*   **BCD_4display.v**: Helper module for 7-segment displays (if used for state visualization).

## Inputs & Outputs (MAX10 Lite)
*   **Clock**: 50 MHz System Clock
*   **Reset**: KEY[0] (or similar)
*   **Input**: Switch/Button for sequence entry.
*   **Output**: LED or 7-Segment Display indicating success (`gut` state) or failure (`bad` state).

## How to Run

### Simulation (macOS / OSS CAD Suite)
To simulate the design using Icarus Verilog and view waveforms in GTKWave:

1.  Open a terminal in the project directory.
2.  Compile the design:
    ```bash
    iverilog -o sim.out prac4_tb.v prac4.v
    ```
3.  Run the simulation:
    ```bash
    vvp sim.out
    ```
4.  View the waveform:
    ```bash
    gtkwave pract4_tb.vcd
    ```

### Implementation (Windows / Quartus Prime)
To synthesize and program the FPGA:

1.  Open the project in Quartus Prime on Windows.
2.  Add the design files (`prac4.v`, `main.v`, etc.) to the project.
3.  Assign pins (import `pin_assigment_de10_lite.tcl` if available).
4.  Compile the design.
5.  Program the MAX10 Lite board using the Programmer tool.
6.  Input the sequence using the designated switch/button.
7.  Observe the output (LED/Display) to verify sequence detection.
