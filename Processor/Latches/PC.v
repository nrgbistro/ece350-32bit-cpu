module ProgramCounter(
    output [31:0] oldPC,
    input [31:0] newPC,
    input clock, stall, reset);

    register_32 reg1(oldPC, newPC, clock, ~stall, reset);

endmodule
