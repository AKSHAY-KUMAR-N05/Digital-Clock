24-Hour Digital Clock ASIC Design Using Verilog HDL
Project Overview

This project focuses on the design and implementation of a 24-hour digital clock using Verilog Hardware Description Language (Verilog HDL).

The digital clock displays time in HH:MM:SS format, supporting hours from 00 to 23 and minutes and seconds from 00 to 59.

The design follows a modular RTL architecture consisting of a clock tick generator, seconds counter, minutes counter, hours counter, and display controller. Each module performs a specific function, and all modules are integrated through a top-level module.

The project demonstrates fundamental concepts of digital design, sequential logic, counters, clock division, BCD conversion, and modular RTL design, with an ASIC-oriented design approach.

Project Objectives
Design a 24-hour digital clock using Verilog HDL.
Implement modular counters for seconds, minutes, and hours.
Generate a 1-second timing pulse from the system clock.
Implement automatic rollover between seconds, minutes, and hours.
Convert binary time values into BCD digits.
Integrate all functional blocks using a top-level module.
Verify the RTL design through simulation.
Design Specifications
Parameter	Specification
Project Type	Digital Clock ASIC RTL Design
Design Language	Verilog HDL
Verilog Standard	IEEE 1364-2001
Time Format	HH:MM:SS
Clock Frequency	50 MHz (default parameter)
Hours Range	00–23
Minutes Range	00–59
Seconds Range	00–59
Reset	Active-Low Asynchronous
Output Format	BCD
Block Diagram

The design follows the following architecture:

text
       System Clock (50 MHz)
                |
                v
        +---------------+
        |    tick_gen   |
        |  Clock Divider|
        +---------------+
                |
                | tick_1s
                v
        +---------------+
        | Seconds       |
        | Counter       |
        +---------------+
                |
                | min_tick
                v
        +---------------+
        | Minutes       |
        | Counter       |
        +---------------+
                |
                | hour_tick
                v
        +---------------+
        | Hours         |
        | Counter       |
        +---------------+
                |
                v
        +---------------+
        | Display       |
        | Controller    |
        +---------------+
                |
                v
       BCD Output (HH:MM:SS)

Module Description
1. tick_gen.v – Clock Tick Generator
Generates a one-second timing pulse from the input system clock.
Uses a frequency divider.
Provides the timing reference for the seconds counter.
Uses the configurable CLK_FREQ_HZ parameter.
2. seconds_counter.v – Seconds Counter
Counts seconds from 0 to 59.
Increments when the one-second enable pulse is received.
Resets to 0 after reaching 59.
Generates a one-cycle min_tick pulse when seconds roll over.
3. minutes_counter.v – Minutes Counter
Counts minutes from 0 to 59.
Increments when min_tick is received.
Resets to 0 after reaching 59.
Generates a one-cycle hour_tick pulse when minutes roll over.
4. hours_counter.v – Hours Counter
Counts hours from 0 to 23.
Increments when hour_tick is received.
Resets to 0 after reaching 23.
Implements 24-hour timekeeping.
5. display_ctrl.v – Display Controller
Converts binary hour, minute, and second values into BCD digits.
Separates each time value into tens and ones digits.
Uses combinational logic for binary-to-BCD conversion.
Produces six 4-bit BCD outputs.
6. digital_clock_top.v – Top-Level Integration
Integrates all functional modules.
Connects clock tick signals and counter outputs.
Distributes the reset signal.
Provides six BCD output digits representing HH:MM:SS.
Working Principle
The system receives a 50 MHz input clock by default.
The clock tick generator produces a one-second enable pulse.
The seconds counter increments on every one-second pulse.
When seconds reach 59, the counter resets to 0 and generates a minute increment pulse.
The minutes counter increments and generates an hour increment pulse after reaching 59.
The hours counter increments until 23 and then rolls over to 0.
The display controller converts the counter values into BCD digits.
The final output represents the current time in HH:MM:SS format.
Example Time Sequence
Event	Hours	Minutes	Seconds
Initial State	00	00	00
After 1 Second	00	00	01
After 59 Seconds	00	00	59
After 60 Seconds	00	01	00
After 1 Hour	01	00	00
After 24 Hours	00	00	00
Tools and Technologies
Verilog HDL – RTL Design
Icarus Verilog / Verilator – RTL Simulation
GTKWave – Waveform Analysis
Yosys – Logic Synthesis
OpenSTA – Static Timing Analysis
OpenROAD / OpenLane – Physical Design Flow
Project Directory Structure
text
Digital-Clock-ASIC/
│
├── tick_gen.v
├── seconds_counter.v
├── minutes_counter.v
├── hours_counter.v
├── display_ctrl.v
├── digital_clock_top.v
│
├── testbench/
│   └── digital_clock_tb.v
│
├── simulation/
│   └── waveform.vcd
│
└── README.md

Verification

The RTL source headers indicate that compilation and functional simulation have been checked for the supplied modules.

The complete top-level design should be compiled and simulated with all dependent modules to verify:

Correct seconds counting.
Seconds rollover from 59 to 00.
Correct minutes increment.
Minutes rollover from 59 to 00.
Correct hours increment.
Hours rollover from 23 to 00.
Correct BCD output conversion.
Asynchronous active-low reset operation.
Future Improvements
Add a seven-segment display decoder.
Implement time-setting functionality.
Add alarm functionality.
Perform complete RTL synthesis.
Perform static timing analysis.
Explore ASIC physical implementation.
Learning Outcomes

Through this project, the following concepts are explored:

RTL design using Verilog HDL.
Sequential and combinational logic.
Clock division and timing control.
Cascaded digital counters.
Binary-to-BCD conversion.
Modular hardware design.
ASIC design flow fundamentals.
Conclusion

This project demonstrates the design of a modular 24-hour digital clock using Verilog HDL. It combines clock division, cascaded counters, and BCD conversion to implement digital timekeeping.

The project provides practical exposure to RTL design and verification concepts while establishing a foundation for further ASIC design and physical implementation.

Project ID: DC-RTL-001
Department: Electronics and Communication Engineering
Institution: BMS College of Engineering, Bengaluru
Project Type: Academic / Industry-Oriented ASIC RTL Design
