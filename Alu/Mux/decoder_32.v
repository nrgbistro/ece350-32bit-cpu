module decoder_32(
    output [31:0] out,
    input enable,
    input [4:0] select);

    assign out = enable << select;

endmodule
