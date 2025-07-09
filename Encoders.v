// =================================================
// Module: encoder_4x2
// Function: Basic 4-to-2 Encoder (One Input)
// =================================================

module encoder_4x2 (
    input [3:0] in,
    output reg [1:0] out
);
    always @(*) begin
        if (in[0]) out = 2'b00;
        else if (in[1]) out = 2'b01;
        else if (in[2]) out = 2'b10;
        else if (in[3]) out = 2'b11;
        else out = 2'b00;
    end
endmodule

// =================================================
// Module: encoder_8x3_priority
// Function: Basic 8-to-3 Priority Encoder
// =================================================

module encoder_8x3_priority (
    input [7:0] in,
    output reg [2:0] out,
    output reg valid
);
    always @(*) begin
        valid = 1'b1;
        if (in[7]) out = 3'b111;
        else if (in[6]) out = 3'b110;
        else if (in[5]) out = 3'b101;
        else if (in[4]) out = 3'b100;
        else if (in[3]) out = 3'b011;
        else if (in[2]) out = 3'b010;
        else if (in[1]) out = 3'b001;
        else if (in[0]) out = 3'b000;
        else begin
            out = 3'b000;
            valid = 1'b0;
        end
    end
endmodule

// =================================================
// Testbench: tb_encoders_simple
// Tests: encoder_4x2, encoder_8x3_priority
// =================================================

module tb_encoders_simple;

    // === 4x2 Encoder ===
    reg [3:0] in4;
    wire [1:0] out4;
    encoder_4x2 enc4 (.in(in4), .out(out4));

    // === 8x3 Priority Encoder ===
    reg [7:0] in8;
    wire [2:0] out8;
    wire valid8;
    encoder_8x3_priority enc8 (.in(in8), .out(out8), .valid(valid8));

    integer i;

    initial begin
        $display("\n========= 4x2 Encoder Test =========");
        for (i = 0; i < 4; i = i + 1) begin
            in4 = 4'b0001 << i;
            #2 $display("Input: %b | Output: %b", in4, out4);
        end

        $display("\n====== 8x3 Priority Encoder Test ======");
        for (i = 0; i < 8; i = i + 1) begin
            in8 = 8'b00000001 << i;
            #2 $display("Input: %b | Output: %b | Valid: %b", in8, out8, valid8);
        end

        // Test with multiple high bits
        in8 = 8'b00101010;
        #2 $display("Input: %b | Output: %b | Valid: %b", in8, out8, valid8);

        // Test with all zeros
        in8 = 8'b00000000;
        #2 $display("Input: %b | Output: %b | Valid: %b", in8, out8, valid8);

        $finish;
    end
endmodule
