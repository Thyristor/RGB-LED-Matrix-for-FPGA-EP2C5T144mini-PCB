# 5x5 RGB LED Matrix for the EP2C5T144 mini FPGA board

An open-source hardware add-on board with 25 RGB LEDs (5x5) for the low-cost **EP2C5T144 mini** FPGA board (Intel/Altera **Cyclone II EP2C5T144C8**), plus the Verilog designs I wrote to drive it.

I designed it end to end: schematic, PCB layout, board manufacture files and FPGA logic. The point of the project was to take a small board from idea to something that lights up, and to document it well enough that someone else can rebuild it.

[![Demo video](https://img.shields.io/badge/demo-video-blue)](RGB-LED_MATRIX_FPGA_EP2C5T144mini_PCB.mp4)

> **Status:** hobby project, 2017 (Altium Designer) and ported to KiCad in 2021. Provided as is.

## What is in this repository

| Path | What it is |
|---|---|
| `pcb/` | Altium Designer project: schematic sheets (`[01]`…`[05]`), PCB layout (`RGB_LED MATRIX.PcbDoc`), 3D STEP model, BOM and fabrication outputs (Gerbers, drill files) |
| `RGB_LED_Matrix.zip` | The same board ported to **KiCad**: schematic, PCB, Gerbers and PDF |
| `src/rgb_led_chromatic/` | Verilog (Quartus II): PWM colour mixing to show the colour palette |
| `src/rgb_led_matrix/` | Verilog (Quartus II): button-controlled colour effect on the 25 LEDs |
| `src/rgb_led_shifter/` | Verilog (Quartus II): shift-register animation, with a testbench (`shifter_tb.v`) |
| `ep2c5t144mini/` | Original schematic PDF of the EP2C5T144 mini FPGA board (third-party reference) |
| `RGB-LED_MATRIX_FPGA_EP2C5T144mini_PCB.mp4` | Short demo video |

## Hardware

- **Target FPGA board:** EP2C5T144 mini (Cyclone II EP2C5T144C8, 3.3 V LVTTL I/O, 50 MHz clock).
- **LEDs:** 25 RGB LEDs arranged as a 5x5 matrix. Each LED has its own R, G and B line, so the FPGA drives 75 outputs.
- **Design tools:** Altium Designer (original), KiCad (port).
- **Manufacturing:** Gerber files ready for any PCB fab. My [OSH Park profile](https://oshpark.com/profiles/Thyristor) has the shared board.

## FPGA designs

All three projects are Quartus II projects (`.qpf` / `.qsf`) targeting the `EP2C5T144C8` device.

- **`rgb_led_chromatic`**: three PWM generators (R, G, B) with different counter widths mix colours, and a debouncer with edge detection handles the push button. Open it to see how the palette is produced.
- **`rgb_led_matrix`**: same building blocks, driven by a button with up/down colour control.
- **`rgb_led_shifter`**: a shift register moves a pattern across the 25 LEDs. Includes a simulation testbench.

The debouncer waits about 40 ms at 50 MHz (a 21-bit counter) before accepting a button press, and produces separate rising- and falling-edge pulses.

## How to rebuild it

1. Open `pcb/FPGA_RGB_LED_Matrix.PrjPcb` in Altium Designer, or unzip `RGB_LED_Matrix.zip` and open `FPGA_RGB_LED_Matrix.pro` in KiCad.
2. Send the Gerbers (`pcb/Project Outputs for FPGA_RGB_LED_Matrix/`, or the `Gerbers/` folder inside the zip) to a PCB manufacturer. The BOM is in `FPGA_RGB_LED_Matrix.xls`.
3. Open one of the projects in `src/` with Quartus II, compile it for `EP2C5T144C8` and program the FPGA board.

## What this project shows

- Reading a vendor schematic (`ep2c5t144mini/`) and designing a compatible add-on board around it.
- Multi-sheet schematic capture, component libraries, PCB layout with teardrops, fiducials and a 3D model.
- Preparing the full manufacturing package: Gerbers, drill files and BOM.
- Digital design in Verilog: PWM, debouncing, edge detection, shift registers and a testbench.
- Documenting hardware so that others can reproduce it, and publishing it as open-source hardware.

## Author

Javier Jiménez, known online as **Javier JIPE**. Electronics and firmware engineer, now moving into forensics and incident response on embedded devices.

[LinkedIn](https://www.linkedin.com/in/jipejavier/)
