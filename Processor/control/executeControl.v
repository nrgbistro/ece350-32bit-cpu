module ExecuteControl(
    output [1:0] insType,
    output [4:0] aluOpCode, shiftAmt,
    output aluBSelector,
    input [31:0] ins);

    wire [1:0] insType;

    TypeDetector typeDetector(insType, ins);

    assign aluOpCode = ~insType[1] & ~insType[0] ? ins[6:2] : 5'b0;
    assign aluBSelector = ~insType[1] & insType[0];
    assign shiftAmt = ins[11:7];

endmodule
