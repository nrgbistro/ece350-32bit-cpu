module SignExtender_16(
    output [31:0] out,
    input [16:0] in);

    assign out[31:17] = in[16] ? {15{1'b1}} : 15'b0;
    assign out[16:0] = in;

endmodule
