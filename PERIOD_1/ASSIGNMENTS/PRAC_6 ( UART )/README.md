# Practice 6: UART Communication

## Description
This project implements a Universal Asynchronous Receiver-Transmitter (UART) interface. It includes both Transmitter (Tx) and Receiver (Rx) modules to enable serial communication between the FPGA and another device (like a PC or another FPGA).

## Modules
*   **UART_Rx.v**: Receiver module that deserializes incoming bits.
*   **UART_Tx.v**: Transmitter module that serializes parallel data for transmission.
*   **top_rx.v / top_tx.v**: Top-level modules for testing Rx and Tx functionality separately or together.
*   **BCD_4display.v**: Used to display received data on the 7-segment displays.

## Inputs & Outputs (MAX10 Lite)
*   **UART_RXD**: Serial Input (Receive).
*   **UART_TXD**: Serial Output (Transmit).
*   **Switches**: Data input for transmission.
*   **Buttons**: Trigger transmission.
*   **7-Segment Displays**: Show received data bytes.

## How to Run

### Simulation (macOS / OSS CAD Suite)
To simulate the design using Icarus Verilog and view waveforms in GTKWave:

1.  Open a terminal in the project directory.
2.  Compile the design:
    ```bash
    iverilog -o sim.out UART_tb.v UART_Tx.v UART_Rx.v
    ```
3.  Run the simulation:
    ```bash
    vvp sim.out
    ```
4.  View the waveform:
    ```bash
    gtkwave UART_tb.vcd
    ```

### Implementation (Windows / Quartus Prime)
To synthesize and program the FPGA:

1.  Open the project in Quartus Prime on Windows.
2.  Add the design files to the project.
3.  Assign pins (Connect UART pins to USB-TTL adapter or onboard USB-UART if available).
4.  Compile the design.
5.  Program the MAX10 Lite board using the Programmer tool.
6.  Connect the UART pins to a USB-TTL adapter or another UART device.
7.  Use a serial terminal (like Putty or TeraTerm) on your PC to send/receive characters (Baud Rate: 9600).
