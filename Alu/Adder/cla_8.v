module cla_8(
    output PG, GG,
    output [7:0] Cout,
    input [7:0] P, G,
    input Cin);

    wire w0_0, w1_0, w1_1, w2_0, w2_1, w2_2, w3_0, w3_1, w3_2, w3_3,
         w4_0, w4_1, w4_2, w4_3, w4_4, w5_0, w5_1, w5_2, w5_3, w5_4, w5_5,
         w6_0, w6_1, w6_2, w6_3, w6_4, w6_5, w6_6, w7_0, g0, g1, g2, g3,
         g4, g5, g6, wCout7;

    // Bit 0
    and andCOut0_0(w0_0, P[0], Cin);
    or orCOut0(Cout[0], G[0], w0_0);

    // Bit 1
    and andCOut1_0(w1_0, G[0], P[1]);
    and andCOut1_1(w1_1, P[0], P[1], Cin);
    or orCOut1(Cout[1], G[1], w1_0, w1_1);

    // Bit 2
    and andCOut2_0(w2_0, G[1], P[2]);
    and andCOut2_1(w2_1, G[0], P[1], P[2]);
    and andCOut2_2(w2_2, Cin, P[0], P[1], P[2]);
    or orCOut2(Cout[2], G[2], w2_0, w2_1, w2_2);

    // Bit 3
    and andCOut3_0(w3_0, G[2], P[3]);
    and andCOut3_1(w3_1, G[1], P[2], P[3]);
    and andCOut3_2(w3_2, G[0], P[1], P[2], P[3]);
    and andCOut3_3(w3_3, Cin, P[0], P[1], P[2], P[3]);
    or orCOut3(Cout[3], G[3], w3_0, w3_1, w3_2, w3_3);

    // Bit 4
    and andCOut4_0(w4_0, G[3], P[4]);
    and andCOut4_1(w4_1, G[2], P[3], P[4]);
    and andCOut4_2(w4_2, G[1], P[2], P[3], P[4]);
    and andCOut4_3(w4_3, G[0], P[1], P[2], P[3], P[4]);
    and andCOut4_4(w4_4, Cin, P[0], P[1], P[2], P[3], P[4]);
    or orCOut4(Cout[4], G[4], w4_0, w4_1, w4_2, w4_3, w4_4);

    // Bit 5
    and andCOut5_0(w5_0, G[4], P[5]);
    and andCOut5_1(w5_1, G[3], P[4], P[5]);
    and andCOut5_2(w5_2, G[2], P[3], P[4], P[5]);
    and andCOut5_3(w5_3, G[1], P[2], P[3], P[4], P[5]);
    and andCOut5_4(w5_4, G[0], P[1], P[2], P[3], P[4], P[5]);
    and andCOut5_5(w5_5, Cin, P[0], P[1], P[2], P[3], P[4], P[5]);
    or orCOut5(Cout[5], G[5], w5_0, w5_1, w5_2, w5_3, w5_4, w5_5);

    // Bit 6
    and andCOut6_0(w6_0, G[5], P[6]);
    and andCOut6_1(w6_1, G[4], P[5], P[6]);
    and andCOut6_2(w6_2, G[3], P[4], P[5], P[6]);
    and andCOut6_3(w6_3, G[2], P[3], P[4], P[5], P[6]);
    and andCOut6_4(w6_4, G[1], P[2], P[3], P[4], P[5], P[6]);
    and andCOut6_5(w6_5, G[0], P[1], P[2], P[3], P[4], P[5], P[6]);
    and andCOut6_6(w6_6, Cin, P[0], P[1], P[2], P[3], P[4], P[5], P[6]);
    or orCOut6(Cout[6], G[6], w6_0, w6_1, w6_2, w6_3, w6_4, w6_5, w6_6);

    // Bit 7
    and andCOut7_0(wCout7, Cin, PG);
    or orCOut7(Cout[7], GG, wCout7);

    // PG
    and andPG(PG, P[7], P[6], P[5], P[4], P[3], P[2], P[1], P[0]);

    // GG
    and andGG1(g6, G[6], P[7]);
    and andGG2(g5, G[5], P[6], P[7]);
    and andGG3(g4, G[4], P[5], P[6], P[7]);
    and andGG4(g3, G[3], P[4], P[5], P[6], P[7]);
    and andGG5(g2, G[2], P[3], P[4], P[5], P[6], P[7]);
    and andGG6(g1, G[1], P[2], P[3], P[4], P[5], P[6], P[7]);
    and andGG7(g0, G[0], P[1], P[2], P[3], P[4], P[5], P[6], P[7]);
    or combinedGG(GG, G[7], g0, g1, g2, g3, g4, g5, g6);

endmodule
