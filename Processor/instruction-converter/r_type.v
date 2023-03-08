module R_type(
    output [4:0] opcode,
    output [4:0] rd,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] shamt,
    output [4:0] aluOp,
    output [1:0] zeros,
    input [31:0] ins
    );

    assign opcode = ins[31:27];
    assign rd = ins[26:22];
    assign rs = ins[21:17];
    assign rt = ins[16:12];
    assign shamt = ins[11:7];
    assign aluOp = ins[6:2];
    assign zeros = ins[1:0];

endmodule
