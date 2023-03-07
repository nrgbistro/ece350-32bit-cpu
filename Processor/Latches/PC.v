module ProgramCounter(
    output [31:0] oldPC,
    input [31:0] newPC,
    input clock, reset);

    register_32 reg1(oldPC, newPC, clock, 1'b1, reset);

endmodule
