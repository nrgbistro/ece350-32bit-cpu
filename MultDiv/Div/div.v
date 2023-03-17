module div(
    output [31:0] ans,
    output error, resultRDY,
    input [31:0] A, B,
    input clk, rst);

    wire [64:0] quotient_out, quotient_in;
    wire [63:0] old_AQ, new_AQ, initialQuotient;
    wire [31:0] dividend, divisor, negativeA, negativeB, negativeAns;
    wire [5:0] count;
    wire count0, divisorAll0, divisorAll1, overflowA, overflowB, overflowAns, negateAns;

    // Ensure dividend and divisor are always >= 0
    adder_32 adderA(negativeA, overflowA, 32'b0, A, 1'b1);
    adder_32 adderB(negativeB, overflowB, 32'b0, B, 1'b1);
    assign dividend = A[31] ? negativeA : A;
    assign divisor = B[31] ? negativeB : B;

    // Fix answer for negative inputs
    xor checkNegativeInputsXOR(negateAns, A[31], B[31]);
    adder_32 adderAns(negativeAns, overflowAns, 32'b0, quotient_out[31:0] >>> 1, 1'b1);
    assign ans = divisorAll0 ? 32'b0 : negateAns ? negativeAns : quotient_out[31:0] >>> 1;

    // 1 when count == 000000
    assign count0 = ~count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4] & ~count[5];
    // 1 when count == 100010 (32 steps)
    assign resultRDY = (count[5] & count[0]) | divisorAll0 & ~count0;
    assign error = divisorAll0;

    checkBits_32 checkDivisor0(divisorAll0, divisorAll1, divisor);

    // Counts from 0 to 32
    counter_32 counter0(
        count,
        clk,
        rst);

    register_65 regProduct( .out(quotient_out), .data(quotient_in), .clock(clk), .enable(1'b1), .reset(rst));


    // Set initial product to dividend in lower product bits
    assign initialQuotient[31:0] = dividend;
    // Zero out upper initial bits
    assign initialQuotient[63:32] = 32'b0;

    assign old_AQ = quotient_out[63:0];
    assign quotient_in[63:0] = count0 ? initialQuotient << 1 : new_AQ;

    divControl controller(new_AQ, old_AQ, divisor);

    // Top bit leftover from mult; leave 0 always
    assign quotient_in[64] = 1'b0;
endmodule
