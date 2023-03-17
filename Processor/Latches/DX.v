module DecodeExecute(
    output [31:0] oldIR, oldA, oldB, oldPC,
    input [31:0] newIR, newA, newB, newPC,
    input clock, stall, reset);

    register_32 reg1(oldIR, newIR, clock, ~stall, reset);
    register_32 reg2(oldA, newA, clock, ~stall, reset);
    register_32 reg3(oldB, newB, clock, ~stall, reset);

    ProgramCounter programCounter(oldPC, newPC, clock, stall, reset);
endmodule
