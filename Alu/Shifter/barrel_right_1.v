module shift_right_1(
    output [31:0] out,
    input shift,
    input [31:0] in);

    wire [31:0] shifted;

    assign shifted[30:0] = in[31:1];
    assign shifted[31] = in[31];

    mux_2 mux(out, shift, in, shifted);
endmodule
