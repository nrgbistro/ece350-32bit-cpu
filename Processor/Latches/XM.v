module ExecuteMemory(
    output [31:0] oldIR, oldO, oldB,
    input [31:0] newIR, newO, newB
    input clock, reset);

    register_32 reg1(oldIR, newIR, clock, 1, reset);
    register_32 reg2(oldO, newO, clock, 1, reset);
    register_32 reg3(oldB, newB, clock, 1, reset);
endmodule
