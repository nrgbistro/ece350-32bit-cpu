module MultDivStall(
    output stall,
    input [31:0] ins,
    input operationDone);

    wire [4:0] aluOpCode;
    wire [1:0] insType;
    TypeDetector insTypeDetector(insType, ins);

    assign aluOpCode = ins[6:2];

    assign stall = (insType == 2'b00) && (aluOpCode[4:1] == 4'b0011) && ~operationDone;

endmodule
