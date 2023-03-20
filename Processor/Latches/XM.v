module ExecuteMemory(
    output [31:0] oldIR, oldO, oldB,
    output errorOut,
    input [31:0] newIR, newO, newB,
    input errorIn,
    input clock, stall, reset);

    register_32 regIR(oldIR, newIR, clock, ~stall, reset);
    register_32 regO(oldO, newO, clock, ~stall, reset);
    register_32 regB(oldB, newB, clock, ~stall, reset);
    dffe_ref regError(errorOut, errorIn, clock, ~stall, reset);
endmodule
