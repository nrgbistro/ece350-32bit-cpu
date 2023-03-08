module TypeDetector(
    output [1:0] insType,
    input [31:0] ins);

    wire [4:0] opcode;

    assign opcode = ins[31:27];

    // 01: I-type, 00: R-type
    assign insType[0] = (~opcode[4] & ~opcode[3] & opcode[2] & ~opcode[1] & opcode[0]);

    // 11: J2-type, 10: J1-type
    assign insType[1] = 1'b0;


endmodule
