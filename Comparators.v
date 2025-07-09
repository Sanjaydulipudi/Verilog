// ==============================================
// Module: comparator_4bit
// Function: Checks if A == B, A > B, or A < B
// ==============================================

module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output reg equal,
    output reg greater,
    output reg lesser
);
    always @(*) begin
        if (A == B) begin
            equal = 1;
            greater = 0;
            lesser = 0;
        end else if (A > B) begin
            equal = 0;
            greater = 1;
            lesser = 0;
        end else begin
            equal = 0;
            greater = 0;
            lesser = 1;
        end
    end
endmodule

// ==============================================
// Module: comparator_8bit
// Function: Checks if A == B, A > B, or A < B
// ==============================================

module comparator_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg equal,
    output reg greater,
    output reg lesser
);
    always @(*) begin
        if (A == B) begin
            equal = 1;
            greater = 0;
            lesser = 0;
        end else if (A > B) begin
            equal = 0;
            greater = 1;
            lesser = 0;
        end else begin
            equal = 0;
            greater = 0;
            lesser = 1;
        end
    end
endmodule

// ==============================================
// Testbench: tb_comparators
// Function: Test both 4-bit and 8-bit comparators
// ==============================================

module tb_comparators;

    // ==== 4-bit Comparator Signals ====
    reg [3:0] a4, b4;
    wire eq4, gt4, lt4;
    comparator_4bit c4 (.A(a4), .B(b4), .equal(eq4), .greater(gt4), .lesser(lt4));

    // ==== 8-bit Comparator Signals ====
    reg [7:0] a8, b8;
    wire eq8, gt8, lt8;
    comparator_8bit c8 (.A(a8), .B(b8), .equal(eq8), .greater(gt8), .lesser(lt8));

    initial begin
        $display("\n======== 4-bit Comparator ========");
        a4 = 4'b0101; b4 = 4'b0101; #5;
        $display("A = %b, B = %b => Equal = %b, Greater = %b, Lesser = %b", a4, b4, eq4, gt4, lt4);

        a4 = 4'b1010; b4 = 4'b0101; #5;
        $display("A = %b, B = %b => Equal = %b, Greater = %b, Lesser = %b", a4, b4, eq4, gt4, lt4);

        a4 = 4'b0010; b4 = 4'b0110; #5;
        $display("A = %b, B = %b => Equal = %b, Greater = %b, Lesser = %b", a4, b4, eq4, gt4, lt4);

        $display("\n======== 8-bit Comparator ========");
        a8 = 8'd100; b8 = 8'd100; #5;
        $display("A = %d, B = %d => Equal = %b, Greater = %b, Lesser = %b", a8, b8, eq8, gt8, lt8);

        a8 = 8'd200; b8 = 8'd100; #5;
        $display("A = %d, B = %d => Equal = %b, Greater = %b, Lesser = %b", a8, b8, eq8, gt8, lt8);

        a8 = 8'd50; b8 = 8'd100; #5;
        $display("A = %d, B = %d => Equal = %b, Greater = %b, Lesser = %b", a8, b8, eq8, gt8, lt8);

        $finish;
    end
endmodule
