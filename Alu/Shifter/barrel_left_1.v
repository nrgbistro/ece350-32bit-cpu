module shift_left_1(
    output [31:0] out,
    input shift,
    input [31:0] in);

    wire [31:0] shifted;

    assign shifted[31:1] = in[30:0];
    assign shifted[0] = 1'b0;

    mux_2 mux(out, shift, in, shifted);
endmodule
