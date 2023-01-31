module cla(
    output [7:0] PG, GG, Cout,
    input [7:0] P, G,
    input Cin);

    wire w0_0, w1_0, w1_1;

    and andCOut0_0(w0_0, P[0], Cin);
    or orCOut0(Cout[0], G[0], w0_0);

    and andCOut1_0(w1_0, G[0], P[1]);
    and andCOut1_1(w1_1, P[0], P[1], Cin);
    or orCOut1(Cout[1], G[1], w1_0, w1_1);
endmodule
