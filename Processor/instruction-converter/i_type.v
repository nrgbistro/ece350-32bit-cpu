module I_type(
    output [4:0] opcode,
    output [4:0] rd,
    output [4:0] rs,
    output [31:0] imm,
    input [31:0] ins);

    assign opcode = ins[31:27];
    assign rd = ins[26:22];
    assign rs = ins[21:17];

    // Sign extend immediate to 32 bits
    SignExtender_16 signExtender_16(
        .out(imm),
        .in(ins[16:0])
    );

endmodule
