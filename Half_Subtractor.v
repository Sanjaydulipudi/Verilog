// =============================================
// Module: halfsub
// Function: Half Subtractor
// =============================================

module halfsub (
    input logic a,
    input logic b,
    output logic diff,
    output logic borrow
);
    assign diff = a ^ b;
    assign borrow = (~a) & b;
endmodule

// =============================================
// Testbench: tb_halfsub
// =============================================

module tb_halfsub;
    reg a, b;
    wire diff, borrow;

    halfsub uut (
        .a(a), .b(b),
        .diff(diff), .borrow(borrow)
    );

    initial begin
        $display("A B | DIFF BORROW");
        repeat (5) begin
            a = $random % 2;
            b = $random % 2;
            #5 $display("%b %b |  %b     %b", a, b, diff, borrow);
        end
        $finish;
    end
endmodule
