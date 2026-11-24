/*******************************************************************************
 * Project        : 24-Hour Digital Clock ASIC Design (HH:MM:SS)
 * Project ID     : DC-RTL-001
 *
 * Faculty Guide  : Prof. Ajaykumar Devarapalli
 * Designation    : Assistant Professor
 * Department     : Electronics and Communication Engineering
 * Institution    : BMS College of Engineering, Bengaluru
 *
 * Module Name    : tb_hours_counter
 * File Name      : tb_hours_counter.v
 *
 * Description    : Self-checking testbench verifying 24-hour counter (0-23) and 23 -> 0 rollover.
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
 *   None (Testbench)
 *
 * Outputs        :
 *   None (Testbench)
 *
 * Dependencies   : rtl/hours_counter.v
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

module tb_hours_counter;

    reg        clk;
    reg        rst_n;
    reg        hour_tick;
    wire [4:0] hour_count;

    integer errors;
    integer i;

    hours_counter dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .hour_tick (hour_tick),
        .hour_count(hour_count)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_hours_counter.vcd");
        $dumpvars(0, tb_hours_counter);

        errors    = 0;
        rst_n     = 1'b0;
        hour_tick = 1'b0;

        #12;
        if (hour_count !== 5'd0) begin
            $display("ERROR: Reset state mismatch");
            errors = errors + 1;
        end

        @(negedge clk);
        rst_n = 1'b1;

        for (i = 1; i <= 25; i = i + 1) begin
            @(negedge clk);
            hour_tick = 1'b1;
            @(posedge clk);
            #1;
            if (hour_count !== (i % 24)) begin
                $display("ERROR: Step %0d expected hour=%0d, got %0d", i, (i % 24), hour_count);
                errors = errors + 1;
            end
        end

        if (errors == 0)
            $display("PASS: tb_hours_counter completed with 0 errors.");
        else
            $display("FAIL: tb_hours_counter completed with %0d errors.", errors);

        $finish;
    end

endmodule