module MemoryControl(
    output [1:0] insType,
    output writeEnable,
    input [31:0] ins);

    wire [4:0] opcode;

    TypeDetector typeDetector(insType, ins);

    assign opcode = ins[31:27];
    assign writeEnable = opcode == 5'b00111;

endmodule
