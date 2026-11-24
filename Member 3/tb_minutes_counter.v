/*******************************************************************************
 * Project        : 24-Hour Digital Clock ASIC Design (HH:MM:SS)
 * Project ID     : DC-RTL-001
 *
 * Faculty Guide  : Prof. Ajaykumar Devarapalli
 * Designation    : Assistant Professor
 * Department     : Electronics and Communication Engineering
 * Institution    : BMS College of Engineering, Bengaluru
 *
 * Module Name    : tb_minutes_counter
 * File Name      : tb_minutes_counter.v
 *
 * Description    : Self-checking testbench verifying minutes count (0-59) and 1-cycle hour_tick pulse.
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
 *   None (Testbench)
 *
 * Outputs        :
 *   None (Testbench)
 *
 * Dependencies   : rtl/minutes_counter.v
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

module tb_minutes_counter;

    reg        clk;
    reg        rst_n;
    reg        min_tick;
    wire [5:0] min_count;
    wire       hour_tick;

    integer errors;
    integer i;

    minutes_counter dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .min_tick (min_tick),
        .min_count(min_count),
        .hour_tick(hour_tick)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_minutes_counter.vcd");
        $dumpvars(0, tb_minutes_counter);

        errors   = 0;
        rst_n    = 1'b0;
        min_tick = 1'b0;

        #12;
        if (min_count !== 6'd0 || hour_tick !== 1'b0) begin
            $display("ERROR: Reset state mismatch");
            errors = errors + 1;
        end

        @(negedge clk);
        rst_n = 1'b1;

        for (i = 1; i <= 60; i = i + 1) begin
            @(negedge clk);
            min_tick = 1'b1;
            @(posedge clk);
            #1;
            if (i < 60) begin
                if (min_count !== i[5:0] || hour_tick !== 1'b0) begin
                    $display("ERROR: Step %0d got min=%0d hour_tick=%b", i, min_count, hour_tick);
                    errors = errors + 1;
                end
            end else begin
                if (min_count !== 6'd0 || hour_tick !== 1'b1) begin
                    $display("ERROR: Rollover mismatch: min=%0d hour_tick=%b", min_count, hour_tick);
                    errors = errors + 1;
                end
            end
        end

        @(negedge clk);
        min_tick = 1'b0;
        @(posedge clk);
        #1;
        if (hour_tick !== 1'b0) begin
            $display("ERROR: hour_tick not 1 cycle wide");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("PASS: tb_minutes_counter completed with 0 errors.");
        else
            $display("FAIL: tb_minutes_counter completed with %0d errors.", errors);

        $finish;
    end

endmodule