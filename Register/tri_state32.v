module tri_state32(
    output [31:0] out,
    input enable,
    input [31:0] in);

    assign out = enable ? in : 32'bz;

endmodule
