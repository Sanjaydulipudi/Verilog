// ===================================================
// Title     : Basic Flip-Flops Collection
// Author    : Laashmith Sanjay
// Modules   : D Flip-Flop, T Flip-Flop, JK Flip-Flop, SR Flip-Flop
// ===================================================


// ===================================================
// Module: D Flip-Flop
// Stores the input D on the rising edge of clock
// ===================================================
module dff (
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule


// ===================================================
// Module: T Flip-Flop
// Toggles the output Q when T = 1
// ===================================================
module tff (
    input clk,
    input reset,
    input t,
    output reg q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else if (t)
            q <= ~q;
    end
endmodule


// ===================================================
// Module: JK Flip-Flop
// J=1 & K=0 sets Q, J=0 & K=1 resets Q, J=K=1 toggles
// ===================================================
module jkff (
    input clk,
    input reset,
    input j, k,
    output reg q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else if (j == 0 && k == 0)
            q <= q;          // no change
        else if (j == 0 && k == 1)
            q <= 1'b0;       // reset
        else if (j == 1 && k == 0)
            q <= 1'b1;       // set
        else
            q <= ~q;         // toggle
    end
endmodule


// ===================================================
// Module: SR Flip-Flop
// S=1 & R=0 sets Q, S=0 & R=1 resets Q
// S=R=1 is invalid
// ===================================================
module srff (
    input clk,
    input reset,
    input s, r,
    output reg q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else if (s == 0 && r == 0)
            q <= q;           // no change
        else if (s == 0 && r == 1)
            q <= 1'b0;        // reset
        else if (s == 1 && r == 0)
            q <= 1'b1;        // set
        else
            q <= 1'bx;        // invalid condition
    end
endmodule


// ===================================================
// Testbench: tb_flipflops
// Description: Tests all four flip-flops with reset
// ===================================================
module tb_flipflops;

    // Common signals
    reg clk, reset;

    // D Flip-Flop
    reg d;
    wire q_d;

    // T Flip-Flop
    reg t;
    wire q_t;

    // JK Flip-Flop
    reg j, k;
    wire q_jk;

    // SR Flip-Flop
    reg s, r;
    wire q_sr;

    // Instantiate all flip-flops
    dff d_inst (.clk(clk), .reset(reset), .d(d), .q(q_d));
    tff t_inst (.clk(clk), .reset(reset), .t(t), .q(q_t));
    jkff jk_inst (.clk(clk), .reset(reset), .j(j), .k(k), .q(q_jk));
    srff sr_inst (.clk(clk), .reset(reset), .s(s), .r(r), .q(q_sr));

    // Generate clock: toggles every 5 time units
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Apply test cases
    initial begin
        // Initial values
        reset = 1;
        d = 0; t = 0; j = 0; k = 0; s = 0; r = 0;

        #10 reset = 0;

        // D Flip-Flop test
        $display("\n===== D Flip-Flop =====");
        d = 1; #10;
        d = 0; #10;

        // T Flip-Flop test
        $display("\n===== T Flip-Flop =====");
        t = 1; #20;
        t = 0; #10;

        // JK Flip-Flop test
        $display("\n===== JK Flip-Flop =====");
        j = 1; k = 0; #10;   // set
        j = 0; k = 1; #10;   // reset
        j = 1; k = 1; #10;   // toggle

        // SR Flip-Flop test
        $display("\n===== SR Flip-Flop =====");
        s = 1; r = 0; #10;   // set
        s = 0; r = 1; #10;   // reset
        s = 1; r = 1; #10;   // invalid

        $finish;
    end
endmodule
