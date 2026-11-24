/*******************************************************************************
 * Project        : 24-Hour Digital Clock ASIC Design (HH:MM:SS)
 * Project ID     : DC-RTL-001
 *
 * Faculty Guide  : Prof. Ajaykumar Devarapalli
 * Designation    : Assistant Professor
 * Department     : Electronics and Communication Engineering
 * Institution    : BMS College of Engineering, Bengaluru
 *
 * Module Name    : tb_digital_clock_top
 * File Name      : tb_digital_clock_top.v
 *
 * Description    : System-level self-checking testbench verifying full 24-hour clock, rollovers, and BCD digits.
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
 *   SIM_CLK_FREQ : 2 (1 tick every 2 clock cycles for rapid full-day simulation)
 *
 * Inputs         :
 *   None (Testbench)
 *
 * Outputs        :
 *   None (Testbench)
 *
 * Dependencies   : rtl/digital_clock_top.v
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

module tb_digital_clock_top;

    localparam integer SIM_CLK_FREQ = 2;

    reg        clk;
    reg        rst_n;
    wire [3:0] hour_tens;
    wire [3:0] hour_ones;
    wire [3:0] min_tens;
    wire [3:0] min_ones;
    wire [3:0] sec_tens;
    wire [3:0] sec_ones;

    integer errors;
    integer total_seconds;
    integer exp_h, exp_m, exp_s;

    digital_clock_top #(
        .CLK_FREQ_HZ(SIM_CLK_FREQ)
    ) dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .hour_tens(hour_tens),
        .hour_ones(hour_ones),
        .min_tens (min_tens),
        .min_ones (min_ones),
        .sec_tens (sec_tens),
        .sec_ones (sec_ones)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task check_time;
        input integer sec_elapsed;
        begin
            exp_s = sec_elapsed % 60;
            exp_m = (sec_elapsed / 60) % 60;
            exp_h = (sec_elapsed / 3600) % 24;

            if (hour_tens !== (exp_h / 10) || hour_ones !== (exp_h % 10) ||
                min_tens  !== (exp_m / 10) || min_ones  !== (exp_m % 10) ||
                sec_tens  !== (exp_s / 10) || sec_ones  !== (exp_s % 10)) begin
                $display("ERROR at elapsed=%0ds: Expected %0d%0d:%0d%0d:%0d%0d, Got %0d%0d:%0d%0d:%0d%0d",
                         sec_elapsed,
                         exp_h/10, exp_h%10, exp_m/10, exp_m%10, exp_s/10, exp_s%10,
                         hour_tens, hour_ones, min_tens, min_ones, sec_tens, sec_ones);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("tb_digital_clock_top.vcd");
        $dumpvars(0, tb_digital_clock_top);

        errors = 0;
        rst_n  = 1'b0;

        #12;
        check_time(0);

        @(negedge clk);
        rst_n = 1'b1;

        for (total_seconds = 1; total_seconds <= 86405; total_seconds = total_seconds + 1) begin
            repeat (SIM_CLK_FREQ) @(posedge clk);
            #1;
            check_time(total_seconds);

            if (total_seconds == (14*3600 + 35*60 + 48)) begin
                $display("Checkpoint 14:35:48 -> BCD = %0d%0d:%0d%0d:%0d%0d",
                         hour_tens, hour_ones, min_tens, min_ones, sec_tens, sec_ones);
            end
            if (total_seconds == 86399) begin
                $display("Checkpoint 23:59:59 -> BCD = %0d%0d:%0d%0d:%0d%0d",
                         hour_tens, hour_ones, min_tens, min_ones, sec_tens, sec_ones);
            end
            if (total_seconds == 86400) begin
                $display("Checkpoint 00:00:00 (Day Rollover) -> BCD = %0d%0d:%0d%0d:%0d%0d",
                         hour_tens, hour_ones, min_tens, min_ones, sec_tens, sec_ones);
            end
        end

        if (errors == 0)
            $display("PASS: tb_digital_clock_top verified 86,405 seconds (full 24h rollover) with 0 errors.");
        else
            $display("FAIL: tb_digital_clock_top completed with %0d errors.", errors);

        $finish;
    end

endmodule