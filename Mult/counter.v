module counter(
    output [2:0] out,
    input clk, reset, start);

    wire out0, out1, in2, out2;

    assign in2 = out0 & out1;

    dffe_reg c0(out0, start, clk, 1'b1, reset);
    dffe_reg c1(out1, out0, clk, 1'b1, reset);
    dffe_reg c2(out2, in2, clk, 1'b1, reset);

endmodule
