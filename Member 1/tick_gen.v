/*******************************************************************************
 * Project        : 24-Hour Digital Clock ASIC Design (HH:MM:SS)
 * Project ID     : DC-RTL-001
 *
 * Faculty Guide  : Prof. Ajaykumar Devarapalli
 * Designation    : Assistant Professor
 * Department     : Electronics and Communication Engineering
 * Institution    : BMS College of Engineering, Bengaluru
 *
 * Module Name    : tick_gen
 * File Name      : tick_gen.v
 *
 * Description    : Generates a one-clock-cycle 1-second enable pulse (tick_1s) from clk.
 *
 * Design Owner   : Member 1 - Clock Divider
 * Design Team    : Digital Clock RTL Design Team (Members 1-5)
 *
 * Language       : Verilog HDL
 * Standard       : IEEE 1364-2001
 *
 * Clock          : clk
 * Reset          : Asynchronous, Active Low (rst_n)
 *
 * Parameters     :
 *   CLK_FREQ_HZ  : Input system clock frequency in Hz (default 50000000)
 *
 * Inputs         :
 *   clk          : System clock
 *   rst_n        : Active-low asynchronous reset
 *
 * Outputs        :
 *   tick_1s      : One-second enable pulse (1 clock cycle wide)
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
 * 1.0       23-11-2026   Member 1        Initial RTL development per Interface Agreement
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

module tick_gen #(
    parameter integer CLK_FREQ_HZ = 50000000
) (
    input  wire clk,
    input  wire rst_n,
    output reg  tick_1s
);

    localparam integer MAX_COUNT = (CLK_FREQ_HZ > 0) ? (CLK_FREQ_HZ - 1) : 0;

    function integer clog2_1364;
        input integer value;
        integer i;
        begin
            clog2_1364 = 0;
            for (i = value - 1; i > 0; i = i >> 1) begin
                clog2_1364 = clog2_1364 + 1;
            end
        end
    endfunction

    localparam integer CNT_WIDTH = (MAX_COUNT > 0) ? clog2_1364(MAX_COUNT + 1) : 1;

    reg [CNT_WIDTH-1:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count   <= {CNT_WIDTH{1'b0}};
            tick_1s <= 1'b0;
        end else if (MAX_COUNT == 0) begin
            count   <= {CNT_WIDTH{1'b0}};
            tick_1s <= 1'b1;
        end else if (count == MAX_COUNT[CNT_WIDTH-1:0]) begin
            count   <= {CNT_WIDTH{1'b0}};
            tick_1s <= 1'b1;
        end else begin
            count   <= count + {{(CNT_WIDTH-1){1'b0}}, 1'b1};
            tick_1s <= 1'b0;
        end
    end

endmodule