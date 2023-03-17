module Bypass(
    output [1:0] ALU_A_bypass, ALU_B_bypass,
    output dmem_bypass,
    input [31:0] executeIR, memoryIR, writebackIR);

    wire [4:0] executeRS1, executeRS2, memoryRD, writebackRD, executeOpcode, memoryOpcode, writebackOpcode;

    assign executeRS1 = executeIR[21:17];
    assign executeRS2 = executeIR[16:12];
    assign memoryRD = memoryIR[26:22];
    assign writebackRD = writebackIR[26:22];
    assign executeOpcode = executeIR[31:27];
    assign memoryOpcode = memoryIR[31:27];
    assign writebackOpcode = writebackIR[31:27];

    // ALU Codes:
    // 2'b00: Bypass from memory O
    // 2'b01: Bypass from writeback
    // 2'b1x: No bypass

    // ALU A
    assign ALU_A_bypass = (executeRS1 == memoryRD && executeOpcode != 5'b00111) ? 2'b00 :
                          (executeRS1 == writebackRD && executeOpcode != 5'b00111) ? 2'b01 : 2'b10;

    // ALU B
    assign ALU_B_bypass = (executeRS2 == memoryRD) ? 2'b00 :
                          (executeRS2 == writebackRD) ? 2'b01 : 2'b10;

    // assign ALU_A_bypass = 2'b10;

    // Dmem
    assign dmem_bypass = memoryRD == writebackRD;

endmodule
