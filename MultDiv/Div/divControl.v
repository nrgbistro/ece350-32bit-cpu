module divControl(
    output [63:0] newAQ,
    input[63:0] AQ,
    input[31:0] M);

    wire [63:0] unshiftedAQ;
    wire [31:0] adderResult, adderInputA;
    wire adderOverflow;

    // AdderResult = A - M
    adder_32 adder(adderResult, adderOverflow, adderInputA, M, 1'b1);
    assign adderInputA = AQ[63:32];

    // If MSB == 1, newAQ[0] == 0
    assign newAQ = unshiftedAQ << 1;

    assign unshiftedAQ[0] = ~adderResult[31];
    assign unshiftedAQ[31:1] = AQ[31:1];
    assign unshiftedAQ[63:32] = adderResult[31] ? AQ[63:32] : adderResult;

endmodule
