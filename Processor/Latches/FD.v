module FetchDecode(
    output [31:0] oldIR, oldPC,
    input [31:0] newIR, newPC,
    input clock, stall, reset);

    register_32 reg1(oldIR, newIR, clock, ~stall, reset);
    ProgramCounter programCounter(oldPC, newPC, clock, stall, reset);
endmodule
