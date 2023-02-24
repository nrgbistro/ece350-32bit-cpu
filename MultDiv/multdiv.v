module multdiv(
	data_operandA, data_operandB,
	ctrl_MULT, ctrl_DIV,
	clock,
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire [31:0] mult_result, div_result, latchA, latchB;
    wire [4:0] count;
    wire reset, multiCount0, multOverflow, divError, multReady, divReady, latchDiv, latchMult;

    assign data_result = latchDiv ? div_result : mult_result;
    assign data_resultRDY = latchDiv ? divReady : multReady;
    assign data_exception = latchDiv ? divError : multOverflow;

    resetDetection rstDetector(reset, ctrl_DIV, ctrl_MULT, clock);

    mult multiplier(mult_result, multOverflow, multReady, multiCount0, latchA, latchB, clock, reset);
    div divider(div_result, divError, divReady, latchA, latchB, clock, reset);

    // Store inputs unless counter == 0000
    register_32 registerA(
        latchA,
        data_operandA,
        ~clock,
        multiCount0,
        reset);
    register_32 registerB(
        latchB,
        data_operandB,
        ~clock,
        multiCount0,
        reset);

    dffe_ref registerDiv(
        latchDiv,
        ctrl_DIV,
        ~clock,
        ctrl_MULT | ctrl_DIV,
        1'b0);

    dffe_ref registerMult(
        latchMult,
        ctrl_MULT,
        ~clock,
        ctrl_MULT | ctrl_DIV,
        1'b0);

endmodule
