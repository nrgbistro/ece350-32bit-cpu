module MemoryWriteback(
    output [31:0] oldIR, oldO, oldD,
    input [31:0] newIR, newO, newD,
    input clock, stall, reset);

    register_32 reg1(oldIR, newIR, clock, ~stall, reset);
    register_32 reg2(oldO, newO, clock, ~stall, reset);
    register_32 reg3(oldD, newD, clock, ~stall, reset);
endmodule
