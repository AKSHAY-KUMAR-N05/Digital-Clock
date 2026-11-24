/*******************************************************************************
 * Project        : 24-Hour Digital Clock ASIC Design (HH:MM:SS)
 * Project ID     : DC-RTL-001
 *
 * Faculty Guide  : Prof. Ajaykumar Devarapalli
 * Designation    : Assistant Professor
 * Department     : Electronics and Communication Engineering
 * Institution    : BMS College of Engineering, Bengaluru
 *
 * Module Name    : hours_counter
 * File Name      : hours_counter.v
 *
 * Description    : Counts 24-hour time from 0 to 23 on hour_tick (rolls over 23 -> 0).
 *
 * Design Owner   : Member 4 - Hours Counter
 * Design Team    : Digital Clock RTL Design Team (Members 1-5)
 *
 * Language       : Verilog HDL
 * Standard       : IEEE 1364-2001
 *
 * Clock          : clk
 * Reset          : Asynchronous, Active Low (rst_n)
 *
 * Parameters     :
 *   None
 *
 * Inputs         :
 *   clk          : System clock
 *   rst_n        : Active-low asynchronous reset
 *   hour_tick    : Hour increment enable
 *
 * Outputs        :
 *   hour_count   : Hours value, 0-23 (5 bits)
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
 * 1.0       23-11-2026   Member 4        Initial RTL development per Interface Agreement
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

module hours_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       hour_tick,
    output reg  [4:0] hour_count
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hour_count <= 5'd0;
        end else if (hour_tick) begin
            if (hour_count == 5'd23) begin
                hour_count <= 5'd0;
            end else begin
                hour_count <= hour_count + 5'd1;
            end
        end
    end

endmodule