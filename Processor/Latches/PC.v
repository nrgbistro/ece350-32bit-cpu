module ProgramCounter(
    output [31:0] oldPC,
    input [31:0] newPC,
    input clock, reset);

    register_32 reg(olcPC, newPC, clock, 1, reset);

endmodule
