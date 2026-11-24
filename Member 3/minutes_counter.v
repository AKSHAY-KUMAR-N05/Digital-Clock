/*******************************************************************************
 * Project        : 24-Hour Digital Clock ASIC Design (HH:MM:SS)
 * Project ID     : DC-RTL-001
 *
 * Faculty Guide  : Prof. Ajaykumar Devarapalli
 * Designation    : Assistant Professor
 * Department     : Electronics and Communication Engineering
 * Institution    : BMS College of Engineering, Bengaluru
 *
 * Module Name    : minutes_counter
 * File Name      : minutes_counter.v
 *
 * Description    : Counts minutes from 0 to 59 on min_tick and asserts 1-cycle hour_tick on rollover.
 *
 * Design Owner   : Member 3 - Minutes Counter
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
 *   min_tick     : Minute increment enable
 *
 * Outputs        :
 *   min_count    : Minutes value, 0-59 (6 bits)
 *   hour_tick    : One-cycle pulse when minutes roll over (59 -> 0)
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
 * 1.0       23-11-2026   Member 3        Initial RTL development per Interface Agreement
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

module minutes_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       min_tick,
    output reg  [5:0] min_count,
    output reg        hour_tick
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            min_count <= 6'd0;
            hour_tick <= 1'b0;
        end else begin
            hour_tick <= 1'b0;
            if (min_tick) begin
                if (min_count == 6'd59) begin
                    min_count <= 6'd0;
                    hour_tick <= 1'b1;
                end else begin
                    min_count <= min_count + 6'd1;
                end
            end
        end
    end

endmodule