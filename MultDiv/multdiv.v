module multdiv(
	data_operandA, data_operandB,
	ctrl_MULT, ctrl_DIV,
	clock,
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // data exception
    assign data_exception = (ctrl_DIV & b0bool) | multOverflow;

    wire [31:0] mult_result, div_result, latchA, latchB;
    wire [3:0] count;
    wire reset, count0bool, b0bool, multOverflow;

    // TEMP
    assign data_result = mult_result;

    // 1 when count == 0000
    assign count0bool = ~count[0] & ~count[1] & ~count[2] & ~count[3];
    // 1 when count == 1111
    assign data_resultRDY = count[0] & count[1] & count[2] & count[3];
    // 1 when operandB == 0000...0000
    assign b0bool = ~latchB[0] & ~latchB[1] & ~latchB[2] & ~latchB[3] & ~latchB[4] & ~latchB[5] & ~latchB[6] & ~latchB[7] & ~latchB[8] & ~latchB[9] & ~latchB[10] & ~latchB[11] & ~latchB[12] & ~latchB[13] & ~latchB[14] & ~latchB[15] & ~latchB[16] & ~latchB[17] & ~latchB[18] & ~latchB[19] & ~latchB[20] & ~latchB[21] & ~latchB[22] & ~latchB[23] & ~latchB[24] & ~latchB[25] & ~latchB[26] & ~latchB[27] & ~latchB[28] & ~latchB[29] & ~latchB[30] & ~latchB[31];

    resetDetection rstDetector(reset, ctrl_DIV, ctrl_MULT, clock);

    mult multiplier(mult_result, multOverflow, latchA, latchB, clock, count0bool, reset);

    // Counts from 0 to 15
    counter counter0(
        count,
        clock,
        reset);

    // Latch inputs unless counter == 0000
    register_32 registerA(
        latchA,
        data_operandA,
        clock,
        count0bool,
        reset);
    register_32 registerB(
        latchB,
        data_operandB,
        clock,
        count0bool,
        reset);

endmodule
