--------------------------------------------------------------------------------
PRAC 6: Pong Game on MAX10 DE10-Lite FPGA
--------------------------------------------------------------------------------

Project Description:
This project implements a classic Pong game using the VGA output of the DE10-Lite board.
It includes a VGA controller (640x480 @ 60Hz), game logic for ball and paddles, 
and score display on the 7-segment displays.

--------------------------------------------------------------------------------
Files Included:
--------------------------------------------------------------------------------
1. pong_top.v          - Top-level module connecting all submodules.
2. hvsync_generator.v  - VGA timing controller (sync signal generation).
3. pong_fsm.v          - Game logic (ball/paddle physics, scoring, state).
4. pong_pixel_gen.v    - Pixel generation logic (drawing ball, paddles, net).
5. seven_segment.v     - 7-segment display decoder for score display.
6. README.txt          - This file.

--------------------------------------------------------------------------------
How to Create and Compile the Project in Quartus Prime:
--------------------------------------------------------------------------------
1. Open Quartus Prime Lite.
2. Create a "New Project Wizard":
   - Working Directory: [Your Path]/ASSIGNMENTS/PRAC_6
   - Project Name: pong_game
   - Top-Level Entity: pong_top
3. Device Selection:
   - Family: MAX 10
   - Device: 10M50DAF484C7G (Check your board, usually this one for DE10-Lite)
4. Add Files:
   - Add ALL .v files in this directory.
5. Finish the setup.

--------------------------------------------------------------------------------
Pin Assignment Process:
--------------------------------------------------------------------------------
To configure the pins accurately using the provided resources:

1. Locate the TCL script: `Pins_etc/pin_assigment_de10_lite.tcl` in the parent directory.
2. In Quartus, go to: Tools > Tcl Scripts...
3. If the script is not listed, click "Add to Project" or browse to find it.
4. Select the script and click "Run".
   - Alternatively, open the "Tcl Console" (View > Utility Windows > Tcl Console) and type:
     source ../../Pins_etc/pin_assigment_de10_lite.tcl
     (Adjust path as necessary relative to your project file).
5. Verification:
   - After running the script, check the "Assignment Editor" to ensure pins like MAX10_CLK1_50, VGA_*, SW, KEY, and HEX are assigned.

Note: The TCL script assigns pins for many peripherals (DRAM, Arduino, etc.). 
Since 'pong_top' only uses VGA, SW, KEY, HEX, and CLK, the other assignments will be ignored/warned by Quartus, which is normal.

--------------------------------------------------------------------------------
Pin Mapping & Hardware Configuration:
--------------------------------------------------------------------------------
The design uses the following mapping based on the DE10-Lite schematic:

| Signal Name     | PIN Location | Description                     |
|-----------------|--------------|---------------------------------|
| MAX10_CLK1_50   | PIN_P11      | 50 MHz System Clock             |
| VGA_HS          | PIN_N3       | VGA Horizontal Sync             |
| VGA_VS          | PIN_N1       | VGA Vertical Sync               |
| VGA_R[3:0]      | PIN_AA1...   | VGA Red Channels                |
| VGA_G[3:0]      | PIN_W1...    | VGA Green Channels              |
| VGA_B[3:0]      | PIN_P1...    | VGA Blue Channels               |
| SW[1:0]         | PIN_C11, C10 | Left Paddle Control (Up/Down)   |
| SW[9:8]         | PIN_F15, B14 | Right Paddle Control (Up/Down)  |
| SW[4]           | PIN_A12      | Paddle Length (0=Normal, 1=Long)|
| SW[5]           | PIN_B12      | Paddle Thickness (0=Norm, 1=Thick)|
| KEY[0]          | PIN_B8       | Reset Game (Active Low)         |
| HEX5            | PIN_N20...   | Left Player Score               |
| HEX4            | PIN_F20...   | Right Player Score              |

--------------------------------------------------------------------------------
Functional Testing:
--------------------------------------------------------------------------------
1. Connect the DE10-Lite to a VGA monitor.
2. Program the FPGA with the generated .sof file.
3. Observe the VGA Output:
   - You should see a black screen with white paddles, a ball, and a dotted net.
4. Test Controls:
   - SW1/SW0: Move Left Paddle.
   - SW9/SW8: Move Right Paddle.
   - SW4: Toggle Paddle Length.
   - SW5: Toggle Paddle Thickness.
   - KEY0: Reset the ball and scores.
5. Gameplay:
   - The ball should bounce off top/bottom walls and paddles.
   - Scoring points should update the HEX displays (HEX5 for Left, HEX4 for Right).
   - Game continues indefinitely.

--------------------------------------------------------------------------------
Modifications from Standard Lab:
--------------------------------------------------------------------------------
- Integrated specific paddle size controls (Length/Thickness) as requested.
- Implemented score display on 7-segment indicators for better visibility.
- Added collision "push-out" logic to prevent ball sticking to paddles.
- Modularized code into `pong_fsm.v` (Game Logic) and `pong_pixel_gen.v` (Rendering) for cleaner top-level design.
