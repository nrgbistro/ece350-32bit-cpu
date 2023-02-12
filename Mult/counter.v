module counter(
    output [2:0] out,
    input clk, reset, start);

    t_flip_flop c0(out[0], start, clk, reset);
    t_flip_flop c1(out[1], out[0], clk, reset);
    t_flip_flop c2(out[2], out[0] & out[1], clk, reset);

endmodule
