module ExecuteControl(
    output [1:0] insType,
    output [4:0] aluOpCode, shiftAmt,
    output aluBSelector,
    input [31:0] ins);

    wire [1:0] insType;

    TypeDetector typeDetector(insType, ins);

    assign writeEnable = 1'b1;
    assign aluOpCode = 5'd0;
    assign aluBSelector = 1'b1;
    assign shiftAmt = 5'd0;

endmodule
