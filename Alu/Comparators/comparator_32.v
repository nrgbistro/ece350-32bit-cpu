module comparator_32(
    output LT, EQ,
    input [31:0] a, b);

    wire LT3, EQ3, LT2, EQ2, LT1, EQ1, LT_in, EQ_in;

    not b32Inverse(b32Inverse, b[31]);

    and twosCompCheck(LT_in, a[31], b32Inverse);
    assign EQ_in = 1;

    comparator_8 comp3(LT3, EQ3, LT_in, EQ_in, a[31:24], b[31:24]);
    comparator_8 comp2(LT2, EQ2, LT3, EQ3, a[23:16], b[23:16]);
    comparator_8 comp1(LT1, EQ1, LT2, EQ2, a[15:8], b[15:8]);
    comparator_8 comp0(LT, EQ, LT1, EQ1, a[7:0], b[7:0]);

endmodule
