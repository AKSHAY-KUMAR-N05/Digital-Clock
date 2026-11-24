/*******************************************************************************
 * Project        : 24-Hour Digital Clock ASIC Design (HH:MM:SS)
 * Project ID     : DC-RTL-001
 *
 * Faculty Guide  : Prof. Ajaykumar Devarapalli
 * Designation    : Assistant Professor
 * Department     : Electronics and Communication Engineering
 * Institution    : BMS College of Engineering, Bengaluru
 *
 * Module Name    : display_ctrl
 * File Name      : display_ctrl.v
 *
 * Description    : Combinational binary-to-BCD converter for hours (0-23), minutes (0-59), and seconds (0-59).
 *
 * Design Owner   : Member 5 - Display Controller
 * Design Team    : Digital Clock RTL Design Team (Members 1-5)
 *
 * Language       : Verilog HDL
 * Standard       : IEEE 1364-2001
 *
 * Clock          : clk
 * Reset          : None (Combinational Logic)
 *
 * Parameters     :
 *   None
 *
 * Inputs         :
 *   hour_count   : Binary hours, 0-23 (5 bits)
 *   min_count    : Binary minutes, 0-59 (6 bits)
 *   sec_count    : Binary seconds, 0-59 (6 bits)
 *
 * Outputs        :
 *   hour_tens    : Tens BCD digit of hours (4 bits)
 *   hour_ones    : Ones BCD digit of hours (4 bits)
 *   min_tens     : Tens BCD digit of minutes (4 bits)
 *   min_ones     : Ones BCD digit of minutes (4 bits)
 *   sec_tens     : Tens BCD digit of seconds (4 bits)
 *   sec_ones     : Ones BCD digit of seconds (4 bits)
 *
 * Dependencies   : None
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

module display_ctrl (
    input  wire [4:0] hour_count,
    input  wire [5:0] min_count,
    input  wire [5:0] sec_count,
    output reg  [3:0] hour_tens,
    output reg  [3:0] hour_ones,
    output reg  [3:0] min_tens,
    output reg  [3:0] min_ones,
    output reg  [3:0] sec_tens,
    output reg  [3:0] sec_ones
);

    always @(*) begin
        // Hours (0 to 23)
        if (hour_count >= 5'd20) begin
            hour_tens = 4'd2;
            hour_ones = hour_count - 5'd20;
        end else if (hour_count >= 5'd10) begin
            hour_tens = 4'd1;
            hour_ones = hour_count - 5'd10;
        end else begin
            hour_tens = 4'd0;
            hour_ones = hour_count[3:0];
        end

        // Minutes (0 to 59)
        if (min_count >= 6'd50) begin
            min_tens = 4'd5;
            min_ones = min_count - 6'd50;
        end else if (min_count >= 6'd40) begin
            min_tens = 4'd4;
            min_ones = min_count - 6'd40;
        end else if (min_count >= 6'd30) begin
            min_tens = 4'd3;
            min_ones = min_count - 6'd30;
        end else if (min_count >= 6'd20) begin
            min_tens = 4'd2;
            min_ones = min_count - 6'd20;
        end else if (min_count >= 6'd10) begin
            min_tens = 4'd1;
            min_ones = min_count - 6'd10;
        end else begin
            min_tens = 4'd0;
            min_ones = min_count[3:0];
        end

        // Seconds (0 to 59)
        if (sec_count >= 6'd50) begin
            sec_tens = 4'd5;
            sec_ones = sec_count - 6'd50;
        end else if (sec_count >= 6'd40) begin
            sec_tens = 4'd4;
            sec_ones = sec_count - 6'd40;
        end else if (sec_count >= 6'd30) begin
            sec_tens = 4'd3;
            sec_ones = sec_count - 6'd30;
        end else if (sec_count >= 6'd20) begin
            sec_tens = 4'd2;
            sec_ones = sec_count - 6'd20;
        end else if (sec_count >= 6'd10) begin
            sec_tens = 4'd1;
            sec_ones = sec_count - 6'd10;
        end else begin
            sec_tens = 4'd0;
            sec_ones = sec_count[3:0];
        end
    end

endmodule