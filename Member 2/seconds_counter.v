/*******************************************************************************
 * Project        : 24-Hour Digital Clock ASIC Design (HH:MM:SS)
 * Project ID     : DC-RTL-001
 *
 * Faculty Guide  : Prof. Ajaykumar Devarapalli
 * Designation    : Assistant Professor
 * Department     : Electronics and Communication Engineering
 * Institution    : BMS College of Engineering, Bengaluru
 *
 * Module Name    : seconds_counter
 * File Name      : seconds_counter.v
 *
 * Description    : Counts seconds from 0 to 59 on tick_1s and asserts 1-cycle min_tick on rollover.
 *
 * Design Owner   : Member 2 - Seconds Counter
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
 *   tick_1s      : Seconds increment enable
 *
 * Outputs        :
 *   sec_count    : Seconds value, 0-59 (6 bits)
 *   min_tick     : One-cycle pulse when seconds roll over (59 -> 0)
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
 * 1.0       23-11-2026   Member 2        Initial RTL development per Interface Agreement
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

module seconds_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tick_1s,
    output reg  [5:0] sec_count,
    output reg        min_tick
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sec_count <= 6'd0;
            min_tick  <= 1'b0;
        end else begin
            min_tick <= 1'b0;
            if (tick_1s) begin
                if (sec_count == 6'd59) begin
                    sec_count <= 6'd0;
                    min_tick  <= 1'b1;
                end else begin
                    sec_count <= sec_count + 6'd1;
                end
            end
        end
    end

endmodule
