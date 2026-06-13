# System Verilog Class

Labs, assignments, and projects from my SystemVerilog class. Board is the DE10-Lite.

## Setup

Uses [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build) for simulation. The folder is gitignored so download it yourself and activate it:

```bash
source oss-cad-suite/activate
```

For flashing to the board, Quartus Prime.


## Simulating

```bash
iverilog -g2012 -o sim top.sv tb.sv
vvp sim
gtkwave dump.vcd
```

Pin scripts are in `Pins_etc/`, run them in Quartus via Tools > Tcl Scripts.
