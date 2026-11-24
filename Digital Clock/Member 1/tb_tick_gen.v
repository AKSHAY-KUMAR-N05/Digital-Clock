/*******************************************************************************
 * Project        : 24-Hour Digital Clock ASIC Design (HH:MM:SS)
 * Project ID     : DC-RTL-001
 *
 * Faculty Guide  : Prof. Ajaykumar Devarapalli
 * Designation    : Assistant Professor
 * Department     : Electronics and Communication Engineering
 * Institution    : BMS College of Engineering, Bengaluru
 *
 * Module Name    : tb_tick_gen
 * File Name      : tb_tick_gen.v
 *
 * Description    : Self-checking testbench for tick_gen using small CLK_FREQ_HZ=10 override.
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
 *   SIM_CLK_FREQ : 10 (fast simulation override)
 *
 * Inputs         :
 *   None (Testbench)
 *
 * Outputs        :
 *   None (Testbench)
 *
 * Dependencies   : rtl/tick_gen.v
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

module tb_tick_gen;

    localparam integer SIM_CLK_FREQ = 10;

    reg  clk;
    reg  rst_n;
    wire tick_1s;

    integer errors;
    integer i;
    integer pulse_count;

    tick_gen #(
        .CLK_FREQ_HZ(SIM_CLK_FREQ)
    ) dut (
        .clk    (clk),
        .rst_n  (rst_n),
        .tick_1s(tick_1s)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_tick_gen.vcd");
        $dumpvars(0, tb_tick_gen);

        errors = 0;
        pulse_count = 0;
        rst_n = 1'b0;

        #12;
        if (tick_1s !== 1'b0) begin
            $display("ERROR: tick_1s not 0 during reset at time %0t", $time);
            errors = errors + 1;
        end

        @(negedge clk);
        rst_n = 1'b1;

        for (i = 0; i < 35; i = i + 1) begin
            @(posedge clk);
            #1;
            if (tick_1s === 1'b1) begin
                pulse_count = pulse_count + 1;
                if (((i + 1) % SIM_CLK_FREQ) != 0) begin
                    $display("ERROR: Unexpected tick_1s pulse at cycle %0d", i + 1);
                    errors = errors + 1;
                end
            end
        end

        if (pulse_count != 3) begin
            $display("ERROR: Expected 3 tick_1s pulses, got %0d", pulse_count);
            errors = errors + 1;
        end

        if (errors == 0)
            $display("PASS: tb_tick_gen completed with 0 errors.");
        else
            $display("FAIL: tb_tick_gen completed with %0d errors.", errors);

        $finish;
    end

endmodule