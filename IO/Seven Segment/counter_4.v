module counter_4(
    output [1:0] out,
    input clk, reset);

    t_flip_flop c0(out[0], 1'b1, clk, reset);
    t_flip_flop c1(out[1], out[0], clk, reset);

endmodule
