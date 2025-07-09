// =============================================
// Module: comple
// Function: 4-bit 2's Complement Generator
// =============================================

module comple (
    input [3:0] a,
    output [3:0] comp
);
    assign comp = ~a + 1;
endmodule

// =============================================
// Testbench: tb_comple
// =============================================

module tb_comple;
    reg [3:0] a;
    wire [3:0] comp;

    comple dut (.a(a), .comp(comp));

    initial begin
        $display("========= 4-bit 2's Complement =========");
        $display("     A     |  2's Complement (COMP)  ");
        $display("----------------------------------------");
        repeat (6) begin
            a = $random;
            #5 $display("   %b   |        %b", a, comp);
        end
        $finish;
    end
endmodule
