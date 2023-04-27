module TypeDetector(
    output [1:0] insType,
    input [31:0] ins);

    wire [4:0] opcode;
    wire r_type, i_type, j1_type, j2_type;

    assign opcode = ins[31:27];

    // 00: R_type
    // 01: I_type
    // 10: J1_type
    // 11: J2_type
    assign insType = r_type ? 2'b00 : i_type ? 2'b01 : j1_type ? 2'b10 : j2_type ? 2'b11 : 2'bz;


    assign r_type = opcode == 5'b00000;
    assign i_type = opcode == 5'b00101 || opcode == 5'b00111 ||
                        opcode == 5'b01000 || opcode == 5'b00010 ||
                        opcode == 5'b00110 || opcode == 5'b10001;
    assign j1_type = opcode == 5'b00001 || opcode == 5'b00011 ||
                     opcode == 5'b10110 || opcode == 5'b10101;
    assign j2_type = opcode == 5'b00100;

endmodule
