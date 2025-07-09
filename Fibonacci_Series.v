// -----------------------------------------------------------------------------
// Module: fibonacci
// Function: Generates the Fibonacci sequence on each clock cycle
// -----------------------------------------------------------------------------

module fibonacci(
    input clock,
    input reset,
    output [31:0] value
);

    // Internal registers to hold previous Fibonacci values
    reg [31:0] a, b;

    // Sequential block to compute Fibonacci series
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            a <= 32'd0;
            b <= 32'd1;
        end else begin
            a <= b;
            b <= a + b;
        end
    end

    // Output current Fibonacci value
    assign value = b;

endmodule

`timescale 1ns / 1ps
`include "fibonacci.v"

// -----------------------------------------------------------------------------
// Testbench: fibonacci_tb
// Purpose: Tests the Fibonacci sequence generator
// -----------------------------------------------------------------------------

module tb_fibonacci;

    reg clock, reset;
    wire [31:0] value;

    // Instantiate the Device Under Test (DUT)
    fibonacci dut (
        .clock(clock),
        .reset(reset),
        .value(value)
    );

    integer i;

    // Clock generation: Toggle every 10 time units
    always #10 clock = ~clock;

    // Stimulus block
    initial begin
        $display("################### Fibonacci Sequence ###################");

        clock = 0;
        reset = 1;
        #20;

        reset = 0;

        for (i = 0; i < 10; i = i + 1) begin
            #20;
            $display("Term %0d: %0d", i+1, value);
        end

        $display("#########################################################");
        $finish;
    end

    // Optional waveform generation
    initial begin
        $fsdbDumpfile("fibonacci.fsdb");
        $fsdbDumpvars(0, tb_fibonacci);
    end

endmodule
