module J1_type(
    output [4:0] opcode,
    output [26:0] target,
    input [31:0] ins);

    assign opcode = ins[31:27];
    assign target = ins[26:0];

endmodule
