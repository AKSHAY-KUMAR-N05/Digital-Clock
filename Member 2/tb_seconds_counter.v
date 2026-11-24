/*******************************************************************************
 * Project        : 24-Hour Digital Clock ASIC Design (HH:MM:SS)
 * Project ID     : DC-RTL-001
 *
 * Faculty Guide  : Prof. Ajaykumar Devarapalli
 * Designation    : Assistant Professor
 * Department     : Electronics and Communication Engineering
 * Institution    : BMS College of Engineering, Bengaluru
 *
 * Module Name    : tb_seconds_counter
 * File Name      : tb_seconds_counter.v
 *
 * Description    : Self-checking testbench verifying seconds count (0-59), hold behavior, and min_tick pulse.
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
 *   None (Testbench)
 *
 * Outputs        :
 *   None (Testbench)
 *
 * Dependencies   : rtl/seconds_counter.v
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

module tb_seconds_counter;

    reg        clk;
    reg        rst_n;
    reg        tick_1s;
    wire [5:0] sec_count;
    wire       min_tick;

    integer errors;
    integer i;

    seconds_counter dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .tick_1s  (tick_1s),
        .sec_count(sec_count),
        .min_tick (min_tick)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_seconds_counter.vcd");
        $dumpvars(0, tb_seconds_counter);

        errors  = 0;
        rst_n   = 1'b0;
        tick_1s = 1'b0;

        #12;
        if (sec_count !== 6'd0 || min_tick !== 1'b0) begin
            $display("ERROR: Reset state mismatch");
            errors = errors + 1;
        end

        @(negedge clk);
        rst_n = 1'b1;

        repeat (3) @(posedge clk);
        #1;
        if (sec_count !== 6'd0) begin
            $display("ERROR: sec_count incremented when tick_1s=0");
            errors = errors + 1;
        end

        for (i = 1; i <= 60; i = i + 1) begin
            @(negedge clk);
            tick_1s = 1'b1;
            @(posedge clk);
            #1;
            if (i < 60) begin
                if (sec_count !== i[5:0] || min_tick !== 1'b0) begin
                    $display("ERROR: At step %0d expected sec=%0d min_tick=0, got sec=%0d min_tick=%b",
                             i, i, sec_count, min_tick);
                    errors = errors + 1;
                end
            end else begin
                if (sec_count !== 6'd0 || min_tick !== 1'b1) begin
                    $display("ERROR: Rollover mismatch: sec=%0d min_tick=%b", sec_count, min_tick);
                    errors = errors + 1;
                end
            end
        end

        @(negedge clk);
        tick_1s = 1'b0;
        @(posedge clk);
        #1;
        if (min_tick !== 1'b0 || sec_count !== 6'd0) begin
            $display("ERROR: min_tick not 1 cycle wide");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("PASS: tb_seconds_counter completed with 0 errors.");
        else
            $display("FAIL: tb_seconds_counter completed with %0d errors.", errors);

        $finish;
    end

endmodule