module comparator_32(
    output LT, EQ,
    input [31:0] a, b);

    wire LT3, EQ3, LT2, EQ2, LT1, EQ1, LT_in, LT_chain_output, EQ_in, a32InverseWire, b32InverseWire, forceGTWire;

    not a32Inverse(a32InverseWire, a[31]);
    not b32Inverse(b32InverseWire, b[31]);
    and forceLT(LT_in, a[31], b32InverseWire);
    and forceGT(forceGTWire, b[31], a32InverseWire);
    assign EQ_in = 1;

    comparator_8 comp3(LT3, EQ3, LT_in, EQ_in, a[31:24], b[31:24]);
    comparator_8 comp2(LT2, EQ2, LT3, EQ3, a[23:16], b[23:16]);
    comparator_8 comp1(LT1, EQ1, LT2, EQ2, a[15:8], b[15:8]);
    comparator_8 comp0(LT_chain_output, EQ, LT1, EQ1, a[7:0], b[7:0]);

    mux_2_1 mux(LT, forceGTWire, LT_chain_output, 1'b0);

endmodule
