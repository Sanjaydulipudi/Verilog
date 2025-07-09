// ==================================================================
// Moore FSM - Overlapping "1010" Sequence Detector
// ==================================================================
module moore_1010_overlap(
    input clk, reset, in,
    output reg out
);

    parameter s0=3'b000, s1=3'b001, s2=3'b010, s3=3'b011, s4=3'b100;
    reg [2:0] current, next;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            current <= s0;
        else
            current <= next;
    end

    // Next state logic
    always @(*) begin
        case (current)
            s0: next = in ? s1 : s0;
            s1: next = in ? s1 : s2;
            s2: next = in ? s3 : s0;
            s3: next = in ? s1 : s4;
            s4: next = in ? s1 : s0;
            default: next = s0;
        endcase
    end

    // Output logic (Moore)
    always @(posedge clk or posedge reset) begin
        if (reset)
            out <= 0;
        else if (current == s4)
            out <= 1;
        else
            out <= 0;
    end
endmodule

// ==================================================================
// Moore FSM - Non-Overlapping "1010" Sequence Detector
// ==================================================================
module moore_1010_nonoverlap(
    input clk, reset, in,
    output reg out
);

    parameter s0=3'b000, s1=3'b001, s2=3'b010, s3=3'b011, s4=3'b100;
    reg [2:0] current, next;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            current <= s0;
        else
            current <= next;
    end

    // Next state logic
    always @(*) begin
        case (current)
            s0: next = in ? s1 : s0;
            s1: next = in ? s1 : s2;
            s2: next = in ? s3 : s0;
            s3: next = in ? s1 : s4;
            s4: next = s0; // Reset to start
            default: next = s0;
        endcase
    end

    // Output logic (Moore)
    always @(posedge clk or posedge reset) begin
        if (reset)
            out <= 0;
        else if (current == s4)
            out <= 1;
        else
            out <= 0;
    end
endmodule

`timescale 1ns / 1ps
`include "moore_1010_overlap.v"

module moore_1010_overlap_tb;

    // Signal declarations
    reg clk, reset, in;
    wire out;

    // DUT instantiation
    moore_1010_overlap dut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Apply input stimulus
    initial begin
        $display("Time\tClk\tReset\tIn\tOut");
        $monitor("%g\t%b\t%b\t%b\t%b", $time, clk, reset, in, out);

        // Apply reset
        reset = 1; in = 0;
        #10 reset = 0;

        // Input sequence to detect 1010
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 0; // Output should go high for 1010
        #10 in = 1;
        #10 in = 0; // Another overlapping detection
        #10 in = 1;
        #10 in = 1;
        #10 in = 0;
        #10 in = 0;
        #20 $finish;
    end

endmodule
