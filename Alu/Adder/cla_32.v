module cla_32(
    output [3:0] carry,
    input [3:0] PG, GG);

    wire w1_0, w2_0, w2_1, w3_0, w3_1, w3_2, w4_0, w4_1, w4_2, w4_3;

    and andCarry1_0(w1_0, PG[0], carry[0]);
    or orCarry1_0(carry[1], GG[0], w1_0);

    and andCarry2_0(w2_0, PG[0], PG[1], carry[0]);
    and andCarry2_1(w2_1, GG[0], PG[1]);
    or orCarry2(carry[2], GG[1], w2_0, w2_1);

    and andCarry3_0(w3_0, PG[0], PG[1], PG[2], carry[0]);
    and andCarry3_1(w3_1, GG[0], PG[1], PG[2]);
    and andCarry3_2(w3_2, GG[1], PG[2]);
    or orCarry3(carry[3], GG[2], w3_0, w3_1, w3_2);

endmodule
