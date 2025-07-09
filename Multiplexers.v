// =============================================
// Module: mux_2x1
// Function: 2:1 Multiplexer
// =============================================

module mux_2x1 (
    input a0,
    input a1,
    input sel,
    output y
);
    assign y = sel ? a1 : a0;
endmodule

// =============================================
// Module: mux_4x1
// Function: 4:1 Multiplexer
// =============================================

module mux_4x1 (
    input a0, a1, a2, a3,
    input [1:0] sel,
    output y
);
    assign y = (sel == 2'b00) ? a0 :
               (sel == 2'b01) ? a1 :
               (sel == 2'b10) ? a2 :
                                a3;
endmodule

module mux_4x1_struct (
    input d0, d1, d2, d3,
    input [1:0] sel,
    output y
);
    wire y0, y1;
    mux_2x1 m1 (.a0(d0), .a1(d1), .sel(sel[0]), .y(y0));
    mux_2x1 m2 (.a0(d2), .a1(d3), .sel(sel[0]), .y(y1));
    mux_2x1 m3 (.a0(y0), .a1(y1), .sel(sel[1]), .y(y));
endmodule


// =============================================
// Module: mux_8x1
// Function: 8:1 Multiplexer using mux_2x1
// =============================================

module mux_8x1 (
    input d0, d1, d2, d3, d4, d5, d6, d7,
    input [2:0] sel,
    output y
);
    wire y0, y1, y2, y3;

    mux_2x1 m1 (.a0(d0), .a1(d1), .sel(sel[0]), .y(y0));
    mux_2x1 m2 (.a0(d2), .a1(d3), .sel(sel[0]), .y(y1));
    mux_2x1 m3 (.a0(d4), .a1(d5), .sel(sel[0]), .y(y2));
    mux_2x1 m4 (.a0(d6), .a1(d7), .sel(sel[0]), .y(y3));

    wire y4, y5;
    mux_2x1 m5 (.a0(y0), .a1(y1), .sel(sel[1]), .y(y4));
    mux_2x1 m6 (.a0(y2), .a1(y3), .sel(sel[1]), .y(y5));

    mux_2x1 m7 (.a0(y4), .a1(y5), .sel(sel[2]), .y(y));
endmodule

// ===================================================
// Module: mux_16x1_struct
// Function: 16:1 Multiplexer using 8:1, 4:1 and 2:1
// ===================================================

module mux_16x1_struct (
    input [15:0] d,
    input [3:0] sel,
    output y
);
    wire y0, y1;

    mux_8x1_struct m1 (
        .d0(d[0]),  .d1(d[1]),  .d2(d[2]),  .d3(d[3]),
        .d4(d[4]),  .d5(d[5]),  .d6(d[6]),  .d7(d[7]),
        .sel(sel[2:0]), .y(y0)
    );

    mux_8x1_struct m2 (
        .d0(d[8]),  .d1(d[9]),  .d2(d[10]), .d3(d[11]),
        .d4(d[12]), .d5(d[13]), .d6(d[14]), .d7(d[15]),
        .sel(sel[2:0]), .y(y1)
    );

    mux_2x1 m3 (.a0(y0), .a1(y1), .sel(sel[3]), .y(y));
endmodule


// =============================================
// Testbench: tb_mux_all
// Tests mux_2x1, mux_4x1, mux_8x1
// =============================================

module tb_mux_all;
    // --- mux_2x1 ---
    reg a0, a1, sel2;
    wire y2;

    mux_2x1 dut2 (.a0(a0), .a1(a1), .sel(sel2), .y(y2));

    // --- mux_4x1 ---
    reg b0, b1, b2, b3;
    reg [1:0] sel4;
    wire y4;

    mux_4x1 dut4 (.a0(b0), .a1(b1), .a2(b2), .a3(b3), .sel(sel4), .y(y4));

    // --- mux_8x1 ---
    reg [7:0] d;
    reg [2:0] sel8;
    wire y8;

    mux_8x1 dut8 (
        .d0(d[0]), .d1(d[1]), .d2(d[2]), .d3(d[3]),
        .d4(d[4]), .d5(d[5]), .d6(d[6]), .d7(d[7]),
        .sel(sel8), .y(y8)
    );

    initial begin
        $display("\n=========== Testing mux_2x1 ===========");
        a0 = 0; a1 = 1;
        sel2 = 0; #5 $display("SEL=%b A0=%b A1=%b | Y=%b", sel2, a0, a1, y2);
        sel2 = 1; #5 $display("SEL=%b A0=%b A1=%b | Y=%b", sel2, a0, a1, y2);

        $display("\n=========== Testing mux_4x1 ===========");
        b0 = 0; b1 = 1; b2 = 0; b3 = 1;
        for (integer i = 0; i < 4; i = i + 1) begin
            sel4 = i[1:0];
            #5 $display("SEL=%b | Y=%b", sel4, y4);
        end

        $display("\n=========== Testing mux_8x1 ===========");
        d = 8'b10110011;
        for (integer i = 0; i < 8; i = i + 1) begin
            sel8 = i[2:0];
            #5 $display("SEL=%b | D[%0d]=%b | Y=%b", sel8, i, d[i], y8);
        end

        $finish;
    end
endmodule

// =============================================
// Testbench: tb_mux_16x1_struc
// =============================================

module tb_mux_16x1_struct;
    reg [15:0] d;
    reg [3:0] sel;
    wire y;

    mux_16x1_struct dut (.d(d), .sel(sel), .y(y));

    initial begin
        $display("========= 16:1 Multiplexer =========");
        $display("   SEL   |   Y");
        $display("-------------------");

        d = 16'b1011001110010110;  // Sample data

        for (integer i = 0; i < 16; i = i + 1) begin
            sel = i[3:0];
            #5 $display("  %b  |  %b", sel, y);
        end

        $finish;
    end
endmodule

