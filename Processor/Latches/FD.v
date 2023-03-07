module FetchDecode(
    output [31:0] oldIR, oldPC,
    input [31:0] newIR, newPC,
    input clock, reset);

    register_32 reg1(oldIR, newIR, clock, 1'b1, reset);
    ProgramCounter programCounter(oldPC, newPC, clock, reset);
endmodule
