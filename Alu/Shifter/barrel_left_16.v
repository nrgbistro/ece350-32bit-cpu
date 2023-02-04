module shift_left_16(
    output [31:0] out,
    input shift,
    input [31:0] in);

    wire [31:0] shifted;

    assign shifted[31:16] = in[15:0];
    assign shifted[15:0] = 1'b0;

    mux_2 mux(out, shift, in, shifted);
endmodule
