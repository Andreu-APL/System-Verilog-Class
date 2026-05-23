# System Verilog Class

Course work for a SystemVerilog / digital-design class, targeting the **DE10-Lite** FPGA board. Includes labs, graded assignments, exams, and a final robotic-arm project.

## Toolchain

Simulation and synthesis use the [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build) (Yosys, Icarus Verilog, GHDL, nextpnr, etc.). The `oss-cad-suite/` directory is excluded from version control — download and unpack it locally, then activate the environment:

```bash
source oss-cad-suite/activate
```

Hardware programming targets Intel/Altera Quartus Prime.

## Repository layout

```
.
├── PERIOD_1/
│   ├── LABS/               # Weekly lab exercises
│   │   ├── GATES/          # Basic logic gates
│   │   ├── FULL ADDER/     # 1-bit and ripple-carry adders
│   │   ├── SUM/            # Combinational adders
│   │   ├── SUM_ITERATIVE/  # Iterative/sequential adder
│   │   ├── MUX/            # Multiplexers
│   │   ├── BCD/            # BCD encoder/decoder
│   │   ├── CALCULATOR/     # Multi-function calculator
│   │   ├── CLOCKDIV/       # Clock divider
│   │   ├── COUNTER/        # Up/down counters
│   │   ├── FLIPFLOPS/      # D, T, JK flip-flops
│   │   ├── M_ESTADOS/      # Finite state machines
│   │   ├── MIN_MAX_FINDER/ # Min/max circuit
│   │   ├── CAM_Lab/        # Content-addressable memory (guided)
│   │   ├── CAM_mio/        # Content-addressable memory (own version)
│   │   ├── VGA/            # VGA display controller
│   │   ├── PONG/           # Pong game on VGA
│   │   └── GUIDE_EXERCISES/
│   │
│   ├── ASSIGNMENTS/        # Graded practicals
│   │   ├── PRAC_1/
│   │   ├── PRAC_2/
│   │   ├── PRAC_3/
│   │   ├── PRAC_4/
│   │   ├── PRAC_5 ( PWM )/   # PWM signal generator
│   │   ├── PRAC_6 ( UART )/  # UART transmitter/receiver
│   │   └── PRAC_7 ( vga chees )/ # VGA chess display
│   │
│   ├── Examen/             # Exam submissions
│   │   ├── Chronometer/
│   │   ├── MIN_MAX_FINDER/
│   │   └── Sumator/
│   │
│   ├── Robotic_Arm/        # Final project: FPGA-controlled robotic arm
│   │   └── Accelerometer/  # Accelerometer interface
│   │
│   └── Pins_etc/           # DE10-Lite pin assignment scripts and manual
│
└── SemiconductorsCourse/   # Companion semiconductors course exercises
    ├── MUX/                # 2-to-1 and 4-to-1 multiplexers
    └── DEMUX/              # 1-to-2 and 1-to-4 demultiplexers
```

## Running a simulation

With the OSS CAD Suite activated, a typical Icarus Verilog flow:

```bash
iverilog -g2012 -o sim top.sv tb.sv
vvp sim
gtkwave dump.vcd
```

## Board target

**Terasic DE10-Lite** (Intel MAX 10 — 10M50DAF484C7G)

Pin assignment scripts for both DE10-Lite and DE10-Standard are in `PERIOD_1/Pins_etc/`. Source them in Quartus via *Tools → Tcl Scripts*.
