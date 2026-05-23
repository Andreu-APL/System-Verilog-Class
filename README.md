# System Verilog Class

Labs, assignments, and projects from my SystemVerilog class. Board is the DE10-Lite.

## Setup

Uses [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build) for simulation. The folder is gitignored so download it yourself and activate it:

```bash
source oss-cad-suite/activate
```

For flashing to the board, Quartus Prime.

## Structure

```
PERIOD_1/
├── LABS/
│   ├── GATES/
│   ├── FULL ADDER/
│   ├── SUM/
│   ├── SUM_ITERATIVE/
│   ├── MUX/
│   ├── BCD/
│   ├── CALCULATOR/
│   ├── CLOCKDIV/
│   ├── COUNTER/
│   ├── FLIPFLOPS/
│   ├── M_ESTADOS/
│   ├── MIN_MAX_FINDER/
│   ├── CAM_Lab/
│   ├── CAM_mio/
│   ├── VGA/
│   ├── PONG/
│   └── GUIDE_EXERCISES/
├── ASSIGNMENTS/
│   ├── PRAC_1/
│   ├── PRAC_2/
│   ├── PRAC_3/
│   ├── PRAC_4/
│   ├── PRAC_5 ( PWM )/
│   ├── PRAC_6 ( UART )/
│   └── PRAC_7 ( vga chees )/
├── Examen/
│   ├── Chronometer/
│   ├── MIN_MAX_FINDER/
│   └── Sumator/
├── Robotic_Arm/
└── Pins_etc/           # pin assignment scripts + DE10-Lite manual

SemiconductorsCourse/
├── MUX/
└── DEMUX/
```

## Simulating

```bash
iverilog -g2012 -o sim top.sv tb.sv
vvp sim
gtkwave dump.vcd
```

Pin scripts are in `Pins_etc/`, run them in Quartus via Tools > Tcl Scripts.
