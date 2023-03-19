module DecodeControl(
    output [1:0] insType,
    input [31:0] ins);

    wire [1:0] insType;

    TypeDetector typeDetector(insType, ins);

endmodule
