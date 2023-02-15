module counter(
    output [3:0] out,
    input clk, reset);

    // Leave counter enabled unless reset is 1 to ensure latches are set correctly before count increments
    t_flip_flop c0(out[0], ~reset, clk, reset);
    t_flip_flop c1(out[1], out[0], clk, reset);
    t_flip_flop c2(out[2], out[0] & out[1], clk, reset);
    t_flip_flop c3(out[3], out[0] & out[1] & out[2], clk, reset);

endmodule
