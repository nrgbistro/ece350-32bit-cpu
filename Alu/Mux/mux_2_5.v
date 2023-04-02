module mux_2_5(out, select, in0, in1);
    output [4:0] out;
    input select;
    input [4:0] in0, in1;
    assign out = select ? in1 : in0;
endmodule
