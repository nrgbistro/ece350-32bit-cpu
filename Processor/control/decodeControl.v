module DecodeControl(
    output [1:0] insType,
    input [31:0] ins);

    TypeDetector typeDetector(insType, ins);

endmodule
