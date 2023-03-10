module adder_32(
    output [31:0] sum,
    output overflow,
    input [31:0] A, B,
    input sub);

    wire [31:0] adderArgB, b_inverted;
    wire [3:0] carry;
    wire [3:0] PG, GG;
    wire [3:0] overflowBus;

    not_32 invertB(b_inverted, B);
    mux_2 add_sub_selector(adderArgB, sub, B, b_inverted);

    assign overflow = overflowBus[3];
    assign carry[0] = sub;

    adder_8 adder0(sum[7:0], PG[0], GG[0], overflowBus[0], A[7:0], adderArgB[7:0], carry[0]);
    adder_8 adder1(sum[15:8], PG[1], GG[1], overflowBus[1], A[15:8], adderArgB[15:8], carry[1]);
    adder_8 adder2(sum[23:16], PG[2], GG[2], overflowBus[2], A[23:16], adderArgB[23:16], carry[2]);
    adder_8 adder3(sum[31:24], PG[3], GG[3], overflowBus[3], A[31:24], adderArgB[31:24], carry[3]);

    cla_32 cla_32(carry, PG, GG);

endmodule
