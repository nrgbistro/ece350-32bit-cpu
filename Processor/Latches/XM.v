module ExecuteMemory(
    output [31:0] oldIR, oldO, oldB,
    input [31:0] newIR, newO, newB,
    input clock, stall, reset);

    register_32 reg1(oldIR, newIR, clock, ~stall, reset);
    register_32 reg2(oldO, newO, clock, ~stall, reset);
    register_32 reg3(oldB, newB, clock, ~stall, reset);
endmodule
