// =============================================
// Module: fullsub
// Function: Full Subtractor
// =============================================

module fullsub (
    input a,
    input b,
    input bin,
    output diff,
    output bout
);
    assign diff = a ^ b ^ bin;
    assign bout = (~a & b) | ((~(a ^ b)) & bin);
endmodule

// =============================================
// Testbench: tb_fullsub
// =============================================

module tb_fullsub;
    reg a, b, bin;
    wire diff, bout;

    fullsub dut (.a(a), .b(b), .bin(bin), .diff(diff), .bout(bout));

    initial begin
        $display("========== Full Subtractor ==========");
        $display(" A | B | BIN | DIFF | BOUT ");
        $display("--------------------------------------");
        repeat (6) begin
            a = $random % 2;
            b = $random % 2;
            bin = $random % 2;
            #5 $display(" %b | %b |  %b  |  %b   |  %b", a, b, bin, diff, bout);
        end
        $finish;
    end
endmodule
