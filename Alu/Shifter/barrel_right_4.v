module shift_right_4(
    output [31:0] out,
    input shift,
    input [31:0] in);

    wire [31:0] shifted;

    assign shifted[27:0] = in[31:4];

    genvar i;
    for(i = 28; i < 32; i = i + 1) begin
        assign shifted[i] = in[31];
    end

    mux_2 mux(out, shift, in, shifted);
endmodule
