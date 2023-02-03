module twos_complement(
    output [31:0] out,
    input [31:0] a);

    wire [31:0] a_inverted;

    // Flip all bits
    not_32 invertA(a_inverted, a);

    // Add 1
    adder_32 add1(out, overflow, a_inverted, 1);
endmodule
