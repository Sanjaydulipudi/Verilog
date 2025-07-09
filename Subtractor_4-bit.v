// =============================================
// Module: subtr
// Function: 4-bit Subtractor
// =============================================

module subtr (
    input [3:0] a,
    input [3:0] b,
    output [3:0] diff,
    output borrow
);
    assign {borrow, diff} = {1'b0, a} - b;
endmodule

// =============================================
// Testbench: tb_subtr
// =============================================

module tb_subtr;
    reg [3:0] a, b;
    wire [3:0] diff;
    wire borrow;

    subtr dut (.a(a), .b(b), .diff(diff), .borrow(borrow));

    initial begin
        $display("============ 4-bit Subtractor ============");
        $display("     A     |     B     |   DIFF   | BORROW");
        $display("------------------------------------------");
        repeat (6) begin
            a = $random;
            b = $random;
            #5 $display("  %b |  %b |  %b |   %b", a, b, diff, borrow);
        end
        $finish;
    end
endmodule
