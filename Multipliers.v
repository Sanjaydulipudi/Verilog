// ==============================================================
// Multipliers Collection (2-bit, 4-bit, 8-bit, 16-bit)
// Laashmith Sanjay
// ==============================================================

// ------------------------
// Half Adder (for hierarchy)
// ------------------------
module ha(input a, b, output sum, carry);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

// ------------------------
// 2-bit Multiplier (direct logic)
// ------------------------
module mul_2bit(input [1:0] A, B, output [3:0] P);
    wire a0b1, a1b0, a1b1, carry;
    assign P[0] = A[0] & B[0];
    assign a0b1 = A[0] & B[1];
    assign a1b0 = A[1] & B[0];
    assign a1b1 = A[1] & B[1];
    ha h1(a0b1, a1b0, P[1], carry);
    ha h2(a1b1, carry, P[2], P[3]);
endmodule

// ------------------------
// 4-bit Multiplier using shifts and adds
// ------------------------
module mul_4bit(input [3:0] A, B, output [7:0] P);
    wire [3:0] p0, p1, p2, p3;
    assign p0 = A & {4{B[0]}};
    assign p1 = A & {4{B[1]}};
    assign p2 = A & {4{B[2]}};
    assign p3 = A & {4{B[3]}};
    assign P = p0 + (p1 << 1) + (p2 << 2) + (p3 << 3);
endmodule

// ------------------------
// RCA 8-bit using FA
// ------------------------
module fa(input a, b, cin, output sum, carry);
    assign sum = a ^ b ^ cin;
    assign carry = (a & b) | (b & cin) | (cin & a);
endmodule

module rca_8bit(input [7:0] A, B, input Cin, output [7:0] Sum, output Cout);
    wire [6:0] carry;
    fa fa0(A[0], B[0], Cin, Sum[0], carry[0]);
    fa fa1(A[1], B[1], carry[0], Sum[1], carry[1]);
    fa fa2(A[2], B[2], carry[1], Sum[2], carry[2]);
    fa fa3(A[3], B[3], carry[2], Sum[3], carry[3]);
    fa fa4(A[4], B[4], carry[3], Sum[4], carry[4]);
    fa fa5(A[5], B[5], carry[4], Sum[5], carry[5]);
    fa fa6(A[6], B[6], carry[5], Sum[6], carry[6]);
    fa fa7(A[7], B[7], carry[6], Sum[7], Cout);
endmodule


// ------------------------
// 8-bit Multiplier using 4-bit multipliers and 8-bit RCA
// ------------------------
module mul_8bit(input [7:0] A, B, output [15:0] P, output C);
    wire [7:0] p0, p1, p2, p3;
    wire [7:0] s1, s2;
    wire Cout1, Cout2, Cout3;
    wire HA_sum, HA_carry;
    wire [7:0] t1, t2;

    mul_4bit m0(.A(A[3:0]), .B(B[3:0]), .P(p0));
    mul_4bit m1(.A(A[7:4]), .B(B[3:0]), .P(p1));
    mul_4bit m2(.A(A[3:0]), .B(B[7:4]), .P(p2));
    mul_4bit m3(.A(A[7:4]), .B(B[7:4]), .P(p3));

    assign P[3:0] = p0[3:0];
    assign t1 = {4'b0000, p0[7:4]};

    rca_8bit r1(.A(p1), .B(p2), .Cin(1'b0), .Sum(s1), .Cout(Cout1));
    rca_8bit r2(.A(s1), .B(t1), .Cin(1'b0), .Sum(s2), .Cout(Cout2));

    ha h1(Cout1, Cout2, HA_sum, HA_carry);

    assign t2 = {2'b00, HA_sum, HA_carry, s2[7:4]};
    assign P[7:4] = s2[3:0];

    rca_8bit r3(.A(p3), .B(t2), .Cin(1'b0), .Sum(P[15:8]), .Cout(Cout3));
    assign C = Cout3;
endmodule

// ------------------------
// RCA 16-bit
// ------------------------
module rca_16bit(input [15:0] A, B, input Cin, output [15:0] Sum, output Cout);
    wire c;
    rca_8bit r0(A[7:0], B[7:0], Cin, Sum[7:0], c);
    rca_8bit r1(A[15:8], B[15:8], c, Sum[15:8], Cout);
endmodule

// ------------------------
// 16-bit Multiplier using behavioral code
// ------------------------
module mul_16bit(input [15:0] A, B, output [31:0] P);
    wire [15:0] p0, p1, p2, p3;
    wire [15:0] s1, s2;
    wire [15:0] shift1, shift2;
    wire Cout1, Cout2;

    // 4 partial products using 8x8 multipliers
    mul_8bit m0(A[7:0],  B[7:0],  p0);
    mul_8bit m1(A[15:8], B[7:0],  p1);
    mul_8bit m2(A[7:0],  B[15:8], p2);
    mul_8bit m3(A[15:8], B[15:8], p3);

    // Shifted intermediate terms
    assign shift1 = {8'b0, p0[15:8]};
    assign shift2 = {8'b0, p1[15:8]};

    // Sum the middle partial products: p1[7:0] + p2[7:0]
    rca_16bit r0({8'b0, p1[7:0]}, {8'b0, p2[7:0]}, 1'b0, s1, Cout1);

    // Add shifted p0 and s1
    rca_16bit r1(s1, shift1, 1'b0, s2, Cout2);

    // Final output mapping
    assign P[7:0]   = p0[7:0];
    assign P[23:8]  = s2;
    assign P[31:24] = p3[7:0]; // Approximation: high byte of final term
endmodule


// ------------------------
// Testbench for All Multipliers
// ------------------------
module tb_all_muls();
    reg [7:0] A8, B8;
    wire [15:0] P8;
    wire Carry8;

    mul_8bit dut(.A(A8), .B(B8), .P(P8), .C(Carry8));

    initial begin
        A8 = 8'd10; B8 = 8'd5;
        #10 A8 = 8'd255; B8 = 8'd1;
        #10 A8 = 8'd13; B8 = 8'd11;
        #10 $finish;
    end
endmodule


// ------------------------
// Testbench for 16-bit Multiplier
// ------------------------
module tb_mul_16bit();
    reg [15:0] A, B;
    wire [31:0] P;

    mul_16bit dut(.A(A), .B(B), .P(P));

    initial begin
        A = 16'd12345; B = 16'd54321;
        #10 A = 16'hFFFF; B = 16'h0001;
        #10 A = 16'd32767; B = 16'd2;
        #10 $finish;
    end
endmodule
