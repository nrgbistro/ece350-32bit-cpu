module DecodeControl(
    output [1:0] insType,
    input [31:0] ins);

    wire [4:0] opcode;
    wire [1:0] insType;

    TypeDetector typeDetector(insType, ins);

    assign opcode = ins[31:27];

endmodule
