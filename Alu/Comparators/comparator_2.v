module comparator_2(
    input [1:0] a, b,
    input GT_in, EQ_in,
    output GT, EQ);

    wire eq0, eq1, eq2, gt0, gt1, gt2, gt3, gt4;

    xnor xnor0(eq0, a[0], b[0]);
    xnor xnor1(eq1, a[1], b[1]);
    and EQAnd(EQ, eq0, eq1, EQ_in);

    and and0(gt0, ~a[1], a[0], ~b[1], ~b[0]);
    and and1(gt1, a[1], ~b[1]);
    and and2(gt2, a[1], a[0], b[1], ~b[0]);
    or GTOr(gt3, gt0, gt1, gt2);
    and GTAnd(gt4, gt3, EQ_in);
    or GTOr2(GT, gt4, GT_in);
endmodule
