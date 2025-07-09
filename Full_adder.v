// =========================
// Module: fulladder.v
// Description: Full Adder — adds three 1-bit inputs (A, B, Cin) and gives Sum and Cout
// =========================

module fulladder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// =============================================
// Module: fulladder_behav
// Function: Full Adder (Behavioral)
// =============================================

module fulladder_behav (
    input logic a,
    input logic b,
    input logic cin,
    output logic sum,
    output logic cout
);
    always_comb begin
        {cout, sum} = a + b + cin;
    end
endmodule

// =============================================
// Module: full
// Function: Gate-Level Full Adder
// =============================================

module full (
    input logic a,
    input logic b,
    input logic cin,
    output logic sum,
    output logic cout
);
    logic s1, c1, c2;

    assign s1 = a ^ b;
    assign sum = s1 ^ cin;
    assign c1 = a & b;
    assign c2 = s1 & cin;
    assign cout = c1 | c2;
endmodule

// =========================
// Testbench: tb_fulladder.v
// =========================

module tb_fulladder;
    reg a, b, cin;
    wire sum, cout;

    fulladder uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        $display("A B Cin | Sum Cout");
        a = 0; b = 0; cin = 0; #10 $display("%b %b  %b  |  %b    %b", a, b, cin, sum, cout);
        a = 0; b = 0; cin = 1; #10 $display("%b %b  %b  |  %b    %b", a, b, cin, sum, cout);
        a = 0; b = 1; cin = 0; #10 $display("%b %b  %b  |  %b    %b", a, b, cin, sum, cout);
        a = 0; b = 1; cin = 1; #10 $display("%b %b  %b  |  %b    %b", a, b, cin, sum, cout);
        a = 1; b = 0; cin = 0; #10 $display("%b %b  %b  |  %b    %b", a, b, cin, sum, cout);
        a = 1; b = 0; cin = 1; #10 $display("%b %b  %b  |  %b    %b", a, b, cin, sum, cout);
        a = 1; b = 1; cin = 0; #10 $display("%b %b  %b  |  %b    %b", a, b, cin, sum, cout);
        a = 1; b = 1; cin = 1; #10 $display("%b %b  %b  |  %b    %b", a, b, cin, sum, cout);
        $finish;
    end
endmodule
