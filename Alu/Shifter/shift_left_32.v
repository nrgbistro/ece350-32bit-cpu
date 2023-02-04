module shift_left(
    output [31:0] out,
    input [4:0] shiftAmt,
    input [31:0] in);

    wire [31:0] shifted_16, shifted_8, shifted_4, shifted_2;

    shift_left_16 shift16(shifted_16, shiftAmt[4], in);

    shift_left_8 shift8(shifted_8, shiftAmt[3], shifted_16);

    shift_left_4 shift4(shifted_4, shiftAmt[2], shifted_8);

    shift_left_2 shift2(shifted_2, shiftAmt[1], shifted_4);

    shift_left_1 shift1(out, shiftAmt[0], shifted_2);


endmodule
