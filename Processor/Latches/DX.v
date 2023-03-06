module DecodeExecute(
    output [31:0] oldIR, oldA, oldB,
    input [31:0] newIR, newA, newB,
    input clock, reset);

    register_32 reg1(oldIR, newIR, clock, 1, reset);
    register_32 reg2(oldA, newA, clock, 1, reset);
    register_32 reg3(oldB, newB, clock, 1, reset);
endmodule
