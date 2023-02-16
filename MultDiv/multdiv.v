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
    wire [4:0] count;
    wire reset, count0bool, b0bool, bMaxBool, multOverflow;

    // TEMP
    assign data_result = mult_result;

    // 1 when count == 00000
    assign count0bool = ~count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4];
    // 1 when count == 10010 (18 steps)
    assign data_resultRDY = count[4];
    // 1 when operandB == 0000...0000
    checkBits_32 checkB0(b0bool, bMaxBool, data_operandB);

    resetDetection rstDetector(reset, ctrl_DIV, ctrl_MULT, clock);

    mult multiplier(mult_result, multOverflow, latchA, latchB, clock, count0bool, reset);

    // Counts from 0 to 15
    counter counter0(
        count,
        clock,
        reset);

    // Store inputs unless counter == 0000
    register_32 registerA(
        latchA,
        data_operandA,
        ~clock,
        count0bool,
        reset);
    register_32 registerB(
        latchB,
        data_operandB,
        ~clock,
        count0bool,
        reset);



endmodule
