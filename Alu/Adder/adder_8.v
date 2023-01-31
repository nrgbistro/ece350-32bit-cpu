module adder_8(
    output [7:0] S,
    output Cout, PG, GG,
    input [7:0] a, b,
    input Cin);

    wire c1, c2, c3, c4, c5, c6, c7;
    wire [7:0] P, G;

    full_adder adder0(S[0], P[0], G[0], a[0], b[0], Cin);
    full_adder adder1(S[1], P[1], G[1], a[1], b[1], c1);
    full_adder adder2(S[2], P[2], G[2], a[2], b[2], c2);
    full_adder adder3(S[3], P[3], G[3], a[3], b[3], c3);
    full_adder adder4(S[4], P[4], G[4], a[4], b[4], c4);
    full_adder adder5(S[5], P[5], G[5], a[5], b[5], c5);
    full_adder adder6(S[6], P[6], G[6], a[6], b[6], c6);
    full_adder adder7(S[7], P[7], G[7], a[7], b[7], c7);

endmodule
