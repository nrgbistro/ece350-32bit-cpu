module adder_8(
    output [7:0] S,
    output PG, GG, overflow,
    input [7:0] a, b,
    input Cin);

    wire [7:0] carryWire;
    wire [7:0] P, G;

    xor carryOutXOR(overflow, carryWire[7], carryWire[6]);

    full_adder adder0(S[0], P[0], G[0], a[0], b[0], Cin);

    genvar i;
    for(i = 1; i < 8; i = i + 1) begin : adder_loop
        full_adder adder(S[i], P[i], G[i], a[i], b[i], carryWire[i - 1]);
    end

    cla_8 cla(PG, GG, carryWire, P, G, Cin);

endmodule
