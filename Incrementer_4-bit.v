// =============================================
// Module: incre
// Function: 4-bit Incrementer
// =============================================

module incre (
    input [3:0] in,
    output [3:0] out
);
    assign out = in + 1;
endmodule

// =============================================
// Testbench: tb_incre
// =============================================

module tb_incre;
    reg [3:0] in;
    wire [3:0] out;

    incre dut (.in(in), .out(out));

    initial begin
        $display("============= 4-bit Incrementer =============");
        $display("   INPUT (IN)   |   OUTPUT (OUT = IN + 1)   ");
        $display("---------------------------------------------");
        repeat (6) begin
            in = $random;
            #5 $display("     %b      |         %b", in, out);
        end
        $finish;
    end
endmodule
