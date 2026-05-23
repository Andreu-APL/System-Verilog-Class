# Practice 7: VGA Chessboard

## Description
This project demonstrates basic VGA signal generation by displaying a checkerboard pattern on a monitor. It generates the necessary Horizontal Sync (HS) and Vertical Sync (VS) signals along with RGB color data.

## Modules
*   **vga.v**: VGA Controller that generates synchronization signals and pixel coordinates (X, Y).
*   **vga_demo.v**: Top-level module that uses the VGA controller and generates the checkerboard pattern based on pixel coordinates.

## Inputs & Outputs (MAX10 Lite)
*   **Clock**: 50 MHz System Clock.
*   **VGA_HS**: Horizontal Sync Output.
*   **VGA_VS**: Vertical Sync Output.
*   **VGA_R, VGA_G, VGA_B**: Red, Green, Blue color signals (4-bit each).

## How to Run

### Simulation (macOS / OSS CAD Suite)
*Note: Visual verification of VGA is best done on hardware. Simulation is useful for checking timing signals.*

To simulate the design using Icarus Verilog and view waveforms in GTKWave:

1.  Open a terminal in the project directory.
2.  Compile the design (you may need to create a testbench `vga_tb.v` if not present):
    ```bash
    iverilog -o sim.out vga_demo.v vga.v
    ```
3.  Run the simulation:
    ```bash
    vvp sim.out
    ```
4.  View the waveform:
    ```bash
    gtkwave dump.vcd
    ```
    *(Ensure your testbench includes `$dumpfile` and `$dumpvars` commands)*

### Implementation (Windows / Quartus Prime)
To synthesize and program the FPGA:

1.  Open the project in Quartus Prime on Windows.
2.  Add the design files (`vga_demo.v`, `vga.v`) to the project.
3.  Assign pins (VGA pins are standard on MAX10 Lite).
4.  Compile the design.
5.  Program the MAX10 Lite board using the Programmer tool.
6.  Connect a VGA monitor to the VGA port on the MAX10 Lite board.
7.  Observe the checkerboard pattern on the screen.
