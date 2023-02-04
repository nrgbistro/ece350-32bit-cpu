module shift_left_8(
    output [31:0] out,
    input shift,
    input [31:0] in);

    wire [31:0] shifted;

    assign shifted[31:8] = in[23:0];
    assign shifted[7:0] = 1'b0;

    mux_2 mux(out, shift, in, shifted);
endmodule
