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
    assign data_exception = ctrl_DIV & b0bool;
    wire [63:0] mult_result;
    wire [31:0] latchA, latchB;
    wire [4:0] count;
    wire reset, count0bool, b0bool;

    assign count0bool = count[0] |~ count[1] |~ count[2] |~ count[3] |~ count[4];
    assign b0bool = ~latchB[0] & ~latchB[1] & ~latchB[2] & ~latchB[3] & ~latchB[4] & ~latchB[5] & ~latchB[6] & ~latchB[7] & ~latchB[8] & ~latchB[9] & ~latchB[10] & ~latchB[11] & ~latchB[12] & ~latchB[13] & ~latchB[14] & ~latchB[15] & ~latchB[16] & ~latchB[17] & ~latchB[18] & ~latchB[19] & ~latchB[20] & ~latchB[21] & ~latchB[22] & ~latchB[23] & ~latchB[24] & ~latchB[25] & ~latchB[26] & ~latchB[27] & ~latchB[28] & ~latchB[29] & ~latchB[30] & ~latchB[31];


    resetDetection rstDetector(rst, ctrl_DIV, ctrl_MULT, clk);

    mult multiplier(multi_result, latchA, latchB, ctrl_MULT, clock, count0bool, reset);

    counter counter0(
        count,
        clock,
        reset);

    assign data_resultRDY = count[0] & count[1] & count[2] & count[3] & count[4];

    register32 registerA(
        latchA,
        data_operandA,
        clock,
        count0bool,
        resetCount);

    register32 registerB(
        latchB,
        data_operandB,
        clock,
        count0bool,
        resetCount);

endmodule
