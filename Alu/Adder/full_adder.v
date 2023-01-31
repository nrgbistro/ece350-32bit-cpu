module full_adder(
    output S, P, G,
    input A, B, Cin);

    wire w1, w2, w3;

    xor sumOut(S, A, B, Cin);
    and AND1(w1, A, B);
    and AND2(w2, A, Cin);
    and AND3(w3, B, Cin);

    and gen(G, A, B);
    or prop(P, A, B);

endmodule
