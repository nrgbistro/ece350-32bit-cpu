module MemoryWriteback(
    output [31:0] oldIR, oldO, oldD,
    output errorOut,
    input [31:0] newIR, newO, newD,
    input errorIn,
    input clock, stall, reset);

    register_32 regIR(oldIR, newIR, clock, ~stall, reset);
    register_32 regO(oldO, newO, clock, ~stall, reset);
    register_32 regD(oldD, newD, clock, ~stall, reset);
    dffe_ref regError(errorOut, errorIn, clock, ~stall, reset);
endmodule
