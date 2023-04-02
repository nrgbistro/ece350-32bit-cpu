module DecodeControl(
    output [1:0] insType,
    output [31:0] decodeT,
    output [4:0] ctrl_readRegA, ctrl_readRegB,
    input [31:0] ins);

    wire [4:0] rs1, rs2;

    TypeDetector typeDetector(insType, ins);

    assign decodeT[26:0] = insType == 2'b10 ? ins[26:0] : {27{1'bz}};
    assign decodeT[31:27] = 5'b0;

    mux_4_5 select_rs1(rs1, insType, ins[21:17], ins[21:17], 5'b0, ins[26:22]);
    mux_4_5 select_rs2(rs2, insType, ins[16:12], ins[26:22], 5'b0, 5'b0);

    assign ctrl_readRegA = ins[31:27] == 5'b10101 ? 5'b0 : ins[31:27] == 5'b10110 ? 5'd30 : ins[31:27] == 5'b00110 || ins[31:27] == 5'b00010 ? rs2 : rs1;
    assign ctrl_readRegB = ins[31:27] == 5'b10110 ? 5'b0 : ins[31:27] == 5'b00110 || ins[31:27] == 5'b00010 ? rs1 : rs2;

endmodule
