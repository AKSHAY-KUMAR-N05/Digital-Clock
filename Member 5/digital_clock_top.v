/*******************************************************************************
 * Project        : 24-Hour Digital Clock ASIC Design (HH:MM:SS)
 * Project ID     : DC-RTL-001
 *
 * Faculty Guide  : Prof. Ajaykumar Devarapalli
 * Designation    : Assistant Professor
 * Department     : Electronics and Communication Engineering
 * Institution    : BMS College of Engineering, Bengaluru
 *
 * Module Name    : digital_clock_top
 * File Name      : digital_clock_top.v
 *
 * Description    : Top-level integration module connecting tick_gen, seconds, minutes, hours, and display_ctrl.
 *
 * Design Owner   : Member 5 - Top-Level Integration
 * Design Team    : Digital Clock RTL Design Team (Members 1-5)
 *
 * Language       : Verilog HDL
 * Standard       : IEEE 1364-2001
 *
 * Clock          : clk
 * Reset          : Asynchronous, Active Low (rst_n)
 *
 * Parameters     :
 *   CLK_FREQ_HZ  : System clock frequency in Hz (default 50000000)
 *
 * Inputs         :
 *   clk          : System clock
 *   rst_n        : Active-low asynchronous reset
 *
 * Outputs        :
 *   hour_tens    : Hours tens digit (BCD)
 *   hour_ones    : Hours ones digit (BCD)
 *   min_tens     : Minutes tens digit (BCD)
 *   min_ones     : Minutes ones digit (BCD)
 *   sec_tens     : Seconds tens digit (BCD)
 *   sec_ones     : Seconds ones digit (BCD)
 *
 * Dependencies   : tick_gen.v, seconds_counter.v, minutes_counter.v, hours_counter.v, display_ctrl.v
 *
 * Tools Used     :
 *   Simulation   : Icarus Verilog / Verilator
 *   Waveform     : GTKWave
 *   Synthesis    : Yosys
 *   STA / P&R    : OpenSTA / OpenROAD / OpenLane
 *
 * Revision History:
 * -----------------------------------------------------------------------------
 * Version   Date         Author          Description
 * -----------------------------------------------------------------------------
 * 1.0       23-11-2026   Member 5        Initial RTL development per Interface Agreement
 *
 * Verification Status:
 *   [x] RTL Compilation
 *   [x] Functional Simulation
 *   [ ] Code Review
 *   [ ] Synthesis
 *   [ ] Timing Analysis
 *
 * Project Type   : Academic / Industry-Oriented ASIC RTL Design
 *
 ******************************************************************************/

`timescale 1ns / 1ps

module digital_clock_top #(
    parameter integer CLK_FREQ_HZ = 50000000
) (
    input  wire       clk,
    input  wire       rst_n,
    output wire [3:0] hour_tens,
    output wire [3:0] hour_ones,
    output wire [3:0] min_tens,
    output wire [3:0] min_ones,
    output wire [3:0] sec_tens,
    output wire [3:0] sec_ones
);

    wire       tick_1s;
    wire       min_tick;
    wire       hour_tick;
    wire [5:0] sec_count;
    wire [5:0] min_count;
    wire [4:0] hour_count;

    tick_gen #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ)
    ) U_TICK_GEN (
        .clk    (clk),
        .rst_n  (rst_n),
        .tick_1s(tick_1s)
    );

    seconds_counter U_SECONDS (
        .clk      (clk),
        .rst_n    (rst_n),
        .tick_1s  (tick_1s),
        .sec_count(sec_count),
        .min_tick (min_tick)
    );

    minutes_counter U_MINUTES (
        .clk      (clk),
        .rst_n    (rst_n),
        .min_tick (min_tick),
        .min_count(min_count),
        .hour_tick(hour_tick)
    );

    hours_counter U_HOURS (
        .clk       (clk),
        .rst_n     (rst_n),
        .hour_tick (hour_tick),
        .hour_count(hour_count)
    );

    display_ctrl U_DISPLAY (
        .hour_count(hour_count),
        .min_count (min_count),
        .sec_count (sec_count),
        .hour_tens (hour_tens),
        .hour_ones (hour_ones),
        .min_tens  (min_tens),
        .min_ones  (min_ones),
        .sec_tens  (sec_tens),
        .sec_ones  (sec_ones)
    );

endmodule