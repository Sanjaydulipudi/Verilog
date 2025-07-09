// =====================================================
// Ripple Carry Adder Collection
// Author: Dulipudi Laashmith Sanjay
// =====================================================

// ------------------------
// Full Adder (1-bit)
// ------------------------
module fa(input a, b, cin, output sum, carry);
    assign sum = a ^ b ^ cin;
    assign carry = (a & b) | (b & cin) | (cin & a);
endmodule

// ------------------------
// 4-bit Ripple Carry Adder
// ------------------------
module rca_4bit(input [3:0] A, B, input Cin, output [3:0] Sum, output Cout);
    wire [2:0] C;
    fa fa0(A[0], B[0], Cin, Sum[0], C[0]);
    fa fa1(A[1], B[1], C[0], Sum[1], C[1]);
    fa fa2(A[2], B[2], C[1], Sum[2], C[2]);
    fa fa3(A[3], B[3], C[2], Sum[3], Cout);
endmodule

// ------------------------
// 8-bit Ripple Carry Adder
// ------------------------
module rca_8bit(input [7:0] A, B, input Cin, output [7:0] Sum, output Cout);
    wire C;
    rca_4bit r0(A[3:0], B[3:0], Cin, Sum[3:0], C);
    rca_4bit r1(A[7:4], B[7:4], C, Sum[7:4], Cout);
endmodule

// ------------------------
// 16-bit Ripple Carry Adder
// ------------------------
module rca_16bit(input [15:0] A, B, input Cin, output [15:0] Sum, output Cout);
    wire C;
    rca_8bit r0(A[7:0], B[7:0], Cin, Sum[7:0], C);
    rca_8bit r1(A[15:8], B[15:8], C, Sum[15:8], Cout);
endmodule

// ------------------------
// 32-bit Ripple Carry Adder
// ------------------------
module rca_32bit(input [31:0] A, B, input Cin, output [31:0] Sum, output Cout);
    wire C;
    rca_16bit r0(A[15:0], B[15:0], Cin, Sum[15:0], C);
    rca_16bit r1(A[31:16], B[31:16], C, Sum[31:16], Cout);
endmodule

// ------------------------
// Testbench for RCA Modules
// ------------------------
module tb_rca();
    reg [31:0] A, B;
    reg Cin;
    wire [31:0] Sum;
    wire Cout;

    rca_32bit dut(.A(A), .B(B), .Cin(Cin), .Sum(Sum), .Cout(Cout));

    initial begin
        A = 32'h12345678; B = 32'h87654321; Cin = 0;
        #10 A = 32'hFFFFFFFF; B = 32'h00000001; Cin = 0;
        #10 A = 32'hA5A5A5A5; B = 32'h5A5A5A5A; Cin = 1;
        #10 $finish;
    end
endmodule
