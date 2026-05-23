# Practice 5: PWM Signal Generator

## Description
This project generates a Pulse Width Modulation (PWM) signal to control a servo motor or LED brightness. The duty cycle of the PWM signal is adjusted based on the input switches, corresponding to specific angles (0°, 90°, 180°).

## Modules
*   **PWM_W.v**: Top-level wrapper connecting switches and displays to the PWM logic.
*   **comparator.v**: Logic to generate the PWM pulse based on a counter and input value.
*   **clk_divide.v**: Clock divider to generate the required frequency for PWM.
*   **BCD_4display.v**: Displays the current angle (0, 90, 180) on the 7-segment displays.

## Inputs & Outputs (MAX10 Lite)
*   **Switches (SW)**: Select the target angle/duty cycle.
    *   `SW[0]`: 0°
    *   `SW[1]`: 90°
    *   `SW[2]`: 180°
*   **ARDUINO_IO[0]**: PWM Output signal.
*   **7-Segment Displays**: Show the selected angle in decimal.

## How to Run

### Simulation (macOS / OSS CAD Suite)
To simulate the design using Icarus Verilog and view waveforms in GTKWave:

1.  Open a terminal in the project directory.
2.  Compile the design:
    ```bash
    iverilog -o sim.out PWM_tb.v PWM_W.v comparator.v clk_divide.v BCD_4display.v BCD.v counter.v
    ```
    *(Note: Ensure all dependency files like `BCD.v`, `counter.v` are present or adjust the command)*
3.  Run the simulation:
    ```bash
    vvp sim.out
    ```
4.  View the waveform:
    ```bash
    gtkwave PWM_tb.vcd
    ```

### Implementation (Windows / Quartus Prime)
To synthesize and program the FPGA:

1.  Open the project in Quartus Prime on Windows.
2.  Add all design files to the project.
3.  Assign pins (ensure `ARDUINO_IO[0]` is mapped correctly).
4.  Compile the design.
5.  Program the MAX10 Lite board using the Programmer tool.
6.  Connect a Servo Motor or LED to `ARDUINO_IO[0]`.
7.  Toggle switches to change the PWM duty cycle and observe the motor position or LED brightness.
