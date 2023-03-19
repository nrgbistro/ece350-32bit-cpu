module Bypass(
    output [1:0] ALU_A_bypass, ALU_B_bypass,
    output dmem_bypass,
    input [31:0] executeIR, memoryIR, writebackIR);

    wire [4:0] executeRD, executeRS1, executeRS2, memoryRD, writebackRD, executeOpcode, memoryOpcode, writebackOpcode;
    wire altInstruction;

    // Change which registers are used for detection when the instruction is a branch
    assign altInstruction = executeOpcode == 5'b00010 ||
                            executeOpcode == 5'b00110 ||
                            executeOpcode == 5'b00100;
    assign executeRD = executeIR[26:22];
    assign executeRS1 = altInstruction ? executeIR[26:22] : executeIR[21:17];
    assign executeRS2 = altInstruction ? executeIR[21:17] : executeIR[16:12];
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
    assign ALU_A_bypass = (executeRS1 != 5'b0 && (executeRS1 == writebackRD || (executeOpcode == 5'b00111 && executeRD == writebackRD))) ? 2'b01 :
                          (executeRS1 != 5'b0 && (executeRS1 == memoryRD || (executeOpcode == 5'b00111 && executeRD == memoryRD))) ? 2'b00 : 2'b10;

    // ALU B
    assign ALU_B_bypass = (executeRS2 != 5'b0 && executeRS2 == writebackRD) ? 2'b01 :
                          (executeRS2 != 5'b0 && executeRS2 == memoryRD) ? 2'b00 : 2'b10;

    // Dmem
    assign dmem_bypass = memoryRD == writebackRD;

endmodule
