module counter_32(
    output [5:0] out,
    input clk, reset);

    // Stop counting at 38
    wire Disable, rst;
    assign Disable = out[5] & ~out[4] & ~out[3] & out[2] & out[1] & out[0];
    assign rst = Disable ? 1'b1 : reset;

    t_flip_flop c0(out[0], 1'b1, clk, rst);
    t_flip_flop c1(out[1], out[0], clk, rst);
    t_flip_flop c2(out[2], out[0] & out[1], clk, rst);
    t_flip_flop c3(out[3], out[0] & out[1] & out[2], clk, rst);
    t_flip_flop c4(out[4], out[0] & out[1] & out[2] & out[3], clk, rst);
    t_flip_flop c5(out[5], out[0] & out[1] & out[2] & out[3] & out[4], clk, rst);

endmodule
