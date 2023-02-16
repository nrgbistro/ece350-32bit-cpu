module counter(
    output [4:0] out,
    input clk, reset);

    // Stop counting at 17
    wire Disable, rst;
    assign Disable = out[4] & ~out[3] & ~out[2] & ~out[1] & out[0] ? 1'b1 : 1'b0;
    assign rst = Disable ? 1'b1 : reset;

    // Leave counter enabled unless count >= 18 to ensure answer stays consistent during data_resultRDY
    t_flip_flop c0(out[0], 1'b1, clk, rst);
    t_flip_flop c1(out[1], out[0], clk, rst);
    t_flip_flop c2(out[2], out[0] & out[1], clk, rst);
    t_flip_flop c3(out[3], out[0] & out[1] & out[2], clk, rst);
    t_flip_flop c4(out[4], out[0] & out[1] & out[2] & out[3], clk, rst);

endmodule
