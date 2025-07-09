// ===================================================
// Title     : Shift Registers Collection
// Author    : Laashmith Sanjay
// Modules   : SISO, SIPO, PISO, PIPO
// ===================================================


// ===================================================
// Module: SISO (Serial In Serial Out)
// Shifts bits serially one by one from left to right
// ===================================================
module siso (
    input clk,
    input reset,
    input sin,           // serial input
    output reg sout      // serial output
);
    reg [3:0] shift;

    always @(posedge clk or posedge reset) begin
        if (reset)
            shift <= 4'b0000;
        else
            shift <= {shift[2:0], sin};  // shift left
    end

    always @(*) begin
        sout = shift[3]; // output last bit
    end
endmodule


// ===================================================
// Module: SIPO (Serial In Parallel Out)
// Accepts serial input and gives parallel output
// ===================================================
module sipo (
    input clk,
    input reset,
    input sin,
    output reg [3:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 4'b0000;
        else
            q <= {q[2:0], sin};  // shift left
    end
endmodule


// ===================================================
// Module: PISO (Parallel In Serial Out)
// Loads all bits and then shifts them out serially
// ===================================================
module piso (
    input clk,
    input reset,
    input load,
    input [3:0] d,       // parallel input
    output reg sout
);
    reg [3:0] temp;

    always @(posedge clk or posedge reset) begin
        if (reset)
            temp <= 4'b0000;
        else if (load)
            temp <= d;
        else
            temp <= {temp[2:0], 1'b0}; // shift left
    end

    always @(*) begin
        sout = temp[3]; // output MSB
    end
endmodule


// ===================================================
// Module: PIPO (Parallel In Parallel Out)
// Just latches the parallel input on clk
// ===================================================
module pipo (
    input clk,
    input reset,
    input [3:0] d,
    output reg [3:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 4'b0000;
        else
            q <= d;
    end
endmodule


// ===================================================
// Testbench: tb_shift_registers
// Tests all 4 shift registers: SISO, SIPO, PISO, PIPO
// ===================================================
module tb_shift_registers;

    reg clk, reset, sin, load;
    reg [3:0] d;
    wire sout_siso, sout_piso;
    wire [3:0] q_sipo, q_pipo;

    // Instantiate modules
    siso  siso_inst  (.clk(clk), .reset(reset), .sin(sin), .sout(sout_siso));
    sipo  sipo_inst  (.clk(clk), .reset(reset), .sin(sin), .q(q_sipo));
    piso  piso_inst  (.clk(clk), .reset(reset), .load(load), .d(d), .sout(sout_piso));
    pipo  pipo_inst  (.clk(clk), .reset(reset), .d(d), .q(q_pipo));

    // Clock generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("\n====== Shift Registers Test ======");
        reset = 1; sin = 0; d = 4'b0000; load = 0;
        #10 reset = 0;

        // --- SISO & SIPO Test (Serial input: 1,0,1,1) ---
        sin = 1; #10;
        sin = 0; #10;
        sin = 1; #10;
        sin = 1; #10;
        $display("SISO Output = %b", sout_siso);
        $display("SIPO Output = %b", q_sipo);

        // --- PISO Test (Load = 1, Data = 1101) ---
        load = 1; d = 4'b1101; #10;
        load = 0;
        #10; $display("PISO Shift 1 -> %b", sout_piso);
        #10; $display("PISO Shift 2 -> %b", sout_piso);
        #10; $display("PISO Shift 3 -> %b", sout_piso);
        #10; $display("PISO Shift 4 -> %b", sout_piso);

        // --- PIPO Test ---
        d = 4'b1010; #10;
        $display("PIPO Output = %b", q_pipo);

        $finish;
    end
endmodule
