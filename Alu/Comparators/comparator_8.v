module comparator_8(
    output LT, EQ,
    input LT_in, EQ_in,
    input [7:0] a, b);

    wire LT3, EQ3, LT2, EQ2, LT1, EQ1;

    comparator_2 comp3(LT3, EQ3, LT_in, EQ_in, a[7:6], b[7:6]);
    comparator_2 comp2(LT2, EQ2, LT3, EQ3, a[5:4], b[5:4]);
    comparator_2 comp1(LT1, EQ1, LT2, EQ2, a[3:2], b[3:2]);
    comparator_2 comp0(LT, EQ, LT1, EQ1, a[1:0], b[1:0]);

endmodule
