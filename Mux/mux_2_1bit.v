module mux_2_1bit(out, select, in0, in1);
    output out;
    input select;
    input in0, in1;
    assign out = select ? in1 : in0;
endmodule
