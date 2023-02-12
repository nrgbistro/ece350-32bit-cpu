module t_flip_flop(
    output q,
    input t, clk, reset);

    dffe_ref d(q, (q & ~t) | (~q & t), clk, 1'b1, reset);

endmodule
