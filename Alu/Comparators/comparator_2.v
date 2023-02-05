module comparator_2(
    output LT, EQ,
    input LT_in, EQ_in,
    input [1:0] a, b);

    wire eq0, eq1, eq2, lt0, lt1, lt2, lt3, lt4;
    wire notA1Wire, notA0Wire, notB1Wire, notB0Wire;

    not notA1(notA1Wire, a[1]);
    not notA0(notA0Wire, a[0]);
    not notB1(notB1Wire, b[1]);
    not notB0(notB0Wire, b[0]);

    xnor xnor0(eq0, a[0], b[0]);
    xnor xnor1(eq1, a[1], b[1]);
    and EQAnd(EQ, eq0, eq1, EQ_in);

    and and0(lt0, notA1Wire, notA0Wire, notB1Wire, b[0]);
    and and1(lt1, notA1Wire, b[1]);
    and and2(lt2, a[1], notA0Wire, b[1], b[0]);
    or LTOr(lt3, lt0, lt1, lt2);
    and LTAnd(lt4, lt3, EQ_in);
    or LTOr2(LT, lt4, LT_in);
endmodule
