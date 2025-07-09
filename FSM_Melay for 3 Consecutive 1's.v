// -----------------------------------------------------------------------------
// Module: mealy_threeones
// Function: Detects three or more consecutive 1's using Mealy FSM (Overlapping)
// -----------------------------------------------------------------------------

module mealy_threeones(input wire clk, reset, in, output reg out);

    // State encoding
    parameter S0 = 2'b00, // Initial state
              S1 = 2'b01, // 1 seen
              S2 = 2'b10, // 11 seen
              S3 = 2'b11; // 111 or more seen

    reg [1:0] state, nxt_state;

    // State update block
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            out <= 0;
        end else begin
            state <= nxt_state;
        end
    end

    // Next state logic and output
    always @(*) begin
        case (state)
            S0: begin
                nxt_state = (in == 1'b1) ? S1 : S0;
                out = 0;
            end
            S1: begin
                nxt_state = (in == 1'b1) ? S2 : S0;
                out = 0;
            end
            S2: begin
                nxt_state = (in == 1'b1) ? S3 : S0;
                out = 0;
            end
            S3: begin
                nxt_state = (in == 1'b1) ? S3 : S0;
                out = 1; // Output goes high when 111 or more seen
            end
            default: begin
                nxt_state = S0;
                out = 0;
            end
        endcase
    end

endmodule

`timescale 1ns / 1ps
`include "mealy_threeones.v"

// -----------------------------------------------------------------------------
// Testbench: mealy_threeones_tb
// Purpose: Stimulates the Mealy FSM to detect three or more 1's
// -----------------------------------------------------------------------------

module mealy_threeones_tb;

    reg clk, reset, in;
    wire out;

    // DUT instantiation
    mealy_threeones dut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Input stimulus
    initial begin
        $display("Time\tClk\tReset\tIn\tOut");
        $monitor("%g\t%b\t%b\t%b\t%b", $time, clk, reset, in, out);

        reset = 1; in = 0;
        #10 reset = 0;

        // Try various patterns including 3+ consecutive 1's
        #10 in = 1;
        #10 in = 1;
        #10 in = 1; // Detection starts here
        #10 in = 1;
        #10 in = 0; // Reset state
        #10 in = 1;
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 1;
        #10 in = 1; // Detection again
        #10 in = 1;
        #20 $finish;
    end

endmodule
