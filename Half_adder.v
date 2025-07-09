// Module: halfadder
// Description: Half Adder — adds two 1-bit inputs and produces sum and carry

module halfadder(
    input a, b,
    output sum, carry
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule


// Testbench for halfadder

module tb_halfadder;
    reg a, b;
    wire sum, carry;

    halfadder uut (.a(a), .b(b), .sum(sum), .carry(carry));

    initial begin
        $display("A B | Sum Carry");
        a = 0; b = 0; #10 $display("%b %b |  %b    %b", a, b, sum, carry);
        a = 0; b = 1; #10 $display("%b %b |  %b    %b", a, b, sum, carry);
        a = 1; b = 0; #10 $display("%b %b |  %b    %b", a, b, sum, carry);
        a = 1; b = 1; #10 $display("%b %b |  %b    %b", a, b, sum, carry);
        $finish;
    end
endmodule
