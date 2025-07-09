// ============================================
// Module: decoder_2x4
// Function: 2-to-4 Decoder with enable
// ============================================

module decoder_2x4 (
    input [1:0] in,
    input en,
    output [3:0] out
);
    assign out = (en == 1'b1) ? (4'b0001 << in) : 4'b0000;
endmodule

// ============================================
// Module: decoder_3x8
// Function: 3-to-8 Decoder with enable
// ============================================

module decoder_3x8 (
    input [2:0] in,
    input en,
    output [7:0] out
);
    assign out = (en == 1'b1) ? (8'b00000001 << in) : 8'b00000000;
endmodule

// ============================================
// Module: decoder_8x1_hier
// Function: 8-to-1 Decoder using 2x4 + 4x1 logic
// ============================================

module decoder_8x1_hier (
    input [2:0] in,
    input en,
    output [7:0] out
);
    wire [3:0] low, high;

    decoder_2x4 d_low  (.in(in[1:0]), .en(~in[2] & en), .out(low));
    decoder_2x4 d_high (.in(in[1:0]), .en(in[2] & en),  .out(high));

    assign out = {high, low};
endmodule

// ============================================
// Testbench: tb_decoders
// Tests: decoder_2x4, decoder_3x8, decoder_8x1_hier
// ============================================

module tb_decoders;
    // --- 2x4 Decoder ---
    reg [1:0] in2;
    reg en2;
    wire [3:0] out2;

    decoder_2x4 d2 (.in(in2), .en(en2), .out(out2));

    // --- 3x8 Decoder ---
    reg [2:0] in3;
    reg en3;
    wire [7:0] out3;

    decoder_3x8 d3 (.in(in3), .en(en3), .out(out3));

    // --- 8x1 Hierarchical Decoder ---
    reg [2:0] in8;
    reg en8;
    wire [7:0] out8;

    decoder_8x1_hier d8 (.in(in8), .en(en8), .out(out8));

    integer i;

    initial begin
        // Test 2x4
        $display("\n========== 2x4 Decoder ==========");
        en2 = 1;
        for (i = 0; i < 4; i = i + 1) begin
            in2 = i[1:0];
            #2 $display("IN=%b | OUT=%b", in2, out2);
        end

        // Test 3x8
        $display("\n========== 3x8 Decoder ==========");
        en3 = 1;
        for (i = 0; i < 8; i = i + 1) begin
            in3 = i[2:0];
            #2 $display("IN=%b | OUT=%b", in3, out3);
        end

        // Test 8x1 Hierarchical Decoder
        $display("\n======= Hierarchical 8x1 Decoder =======");
        en8 = 1;
        for (i = 0; i < 8; i = i + 1) begin
            in8 = i[2:0];
            #2 $display("IN=%b | OUT=%b", in8, out8);
        end

        $finish;
    end
endmodule
