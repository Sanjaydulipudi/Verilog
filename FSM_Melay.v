// ==================================================================
// Mealy FSM - Overlapping "1010" Sequence Detector
// ==================================================================
module mealy_1010_overlap(
    input wire clk, reset, in,
    output reg out
);

    parameter s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;
    reg [1:0] current, next;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            current <= s0;
        else
            current <= next;
    end

    // Next state & output logic
    always @(*) begin
        case (current)
            s0: begin
                next = in ? s1 : s0;
                out = 0;
            end
            s1: begin
                next = in ? s1 : s2;
                out = 0;
            end
            s2: begin
                next = in ? s3 : s0;
                out = 0;
            end
            s3: begin
                next = in ? s1 : s2;
                out = ~in; // out=1 when in=0 (detecting 1010)
            end
        endcase
    end
endmodule


// ====================================================================
// FSM: Non-overlapping Mealy Sequence Detector for "1010"
// ====================================================================

module fsm_mealy_nonoverlap_1010(
    input wire clock, reset, in,
    output reg out,
    output [1:0] state
);

    parameter s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;

    reg [1:0] present, next;
    assign state = present;

    // State Register
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            present <= s0;
            out <= 0;
        end else begin
            present <= next;
        end
    end

    // Next State & Output Logic
    always @(*) begin
        case (present)
            s0: begin
                next = in ? s1 : s0;
                out = 0;
            end
            s1: begin
                next = in ? s1 : s2;
                out = 0;
            end
            s2: begin
                next = in ? s3 : s0;
                out = 0;
            end
            s3: begin
                next = s0;
                out = (in == 1'b0) ? 1 : 0;  // Sequence "1010" complete
            end
        endcase
    end

endmodule

`timescale 1ns / 1ps
`include "fsm_mealy_nonoverlap_1010.v"

module fsm_mealy_nonoverlap_1010_tb();

    reg clock, reset, in;
    wire out;
    wire [1:0] state;

    fsm_mealy_nonoverlap_1010 dut(.clock(clock), .reset(reset), .in(in), .out(out), .state(state));

    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    initial begin
        reset = 1; in = 0;
        #10 reset = 0;
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 0;  // should detect 1010 here
        #10 in = 1;
        #10 in = 0;
        #10 in = 1;
        #10 in = 0;
        #10 $finish;
    end

    initial begin
        $monitor("Time=%0t Reset=%b In=%b State=%b Out=%b", $time, reset, in, state, out);
    end

endmodule

