module cla_32(
    output [4:0] carry,
    input [3:0] PG, GG);

    wire w0_0, w1_0, w1_1, w2_0, w2_1, w2_2;

    assign carry[0] = 0;

    assign carry[1] = GG[0];

    and andCarry2(w0_0, GG[0], PG[1]);
    or orCarry2(carry[2], GG[1], w0_0);


    and andCarry3_0(w1_0, GG[0], PG[1], PG[2]);
    and andCarry3_1(w1_1, GG[1], PG[2]);
    or orCarry3(carry[3], GG[2], w1_0, w1_1);

    and andCarry4_0(w2_0, GG[0], PG[1], PG[2], PG[3]);
    and andCarry4_1(w2_1, GG[1], PG[2], PG[3]);
    and andCarry4_2(w2_2, GG[2], PG[3]);
    or orCarryOut(carry[4], GG[3], w2_0, w2_1, w2_2);


endmodule
