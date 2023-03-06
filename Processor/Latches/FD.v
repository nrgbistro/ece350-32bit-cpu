module FetchDecode(
    output [31:0] oldIR,
    input [31:0] newIR,
    input clock, reset);

    register_32 reg(oldIR, newIR, clock, 1, reset);
endmodule
