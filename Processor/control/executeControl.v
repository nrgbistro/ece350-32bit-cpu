module ExecuteControl(
    output [1:0] insType,
    output [4:0] aluOpCode, shiftAmt,
    output aluBSelector, startMult, startDiv,
    input [31:0] ins,
    input clock, multDivDone);

    wire [1:0] insType;

    TypeDetector typeDetector(insType, ins);

    assign aluOpCode = insType == 2'b00 ? ins[6:2] : 5'b0;
    assign aluBSelector = (insType == 2'b01) && (ins[31:27] != 5'b00010 && ins[31:27] != 5'b00110);
    assign shiftAmt = ins[11:7];
    assign startMult = insType == 2'b00 && aluOpCode == 5'b00110;
    assign startDiv = insType == 2'b00 && aluOpCode == 5'b00111;

endmodule
