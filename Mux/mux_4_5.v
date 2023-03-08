module mux_4_5(out, select, in0, in1, in2, in3);
    output [4:0] out;
    input [1:0] select;
    input [4:0] in0, in1, in2, in3;
    wire [4:0] w1, w2;

    mux_2_5 mux0_top(.out(w1), .select(select[0]), .in0(in0), .in1(in1));
    mux_2_5 mux0_bot(.out(w2), .select(select[0]), .in0(in2), .in1(in3));
    mux_2_5 mux1(.out(out), .select(select[1]), .in0(w1), .in1(w2));

endmodule
