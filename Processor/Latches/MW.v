module MemoryWriteback(
    output [31:0] oldIR, oldO, oldD,
    input [31:0] newIR, newO, newD,
    input clock, reset);

    register_32 reg1(oldIR, newIR, clock, 1, reset);
    register_32 reg2(oldO, newO, clock, 1, reset);
    register_32 reg3(oldD, newD, clock, 1, reset);
endmodule
