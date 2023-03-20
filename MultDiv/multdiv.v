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
    wire reset, multiCount0, multOverflow, divError, multReady, divReady, latchDiv, latchMult, pulseMultWire, pulseDivWire;

    assign data_result = latchDiv ? div_result : mult_result;
    assign data_resultRDY = latchDiv ? divReady : latchMult ? multReady : 1'b0;
    assign data_exception = latchDiv && ctrl_DIV ? divError : multOverflow;

    Pulse pulseMult(pulseMultWire, clock, ctrl_MULT, data_resultRDY);
    Pulse pulseDiv(pulseDivWire, clock, ctrl_DIV, data_resultRDY);

    resetDetection rstDetector(reset, pulseDivWire, pulseMultWire, clock);

    mult multiplier(mult_result, multOverflow, multReady, multiCount0, latchA, latchB, clock, reset);
    div divider(div_result, divError, divReady, data_operandA, data_operandB, clock, reset);

    // Store inputs unless counter == 0000
    register_32 registerA(
        latchA,
        data_operandA,
        clock,
        multiCount0,
        reset);
    register_32 registerB(
        latchB,
        data_operandB,
        clock,
        multiCount0,
        reset);

    dffe_ref registerDiv(
        latchDiv,
        ctrl_DIV,
        ~clock,
        ctrl_MULT | ctrl_DIV | data_resultRDY,
        1'b0);

    dffe_ref registerMult(
        latchMult,
        ctrl_MULT,
        ~clock,
        ctrl_MULT | ctrl_DIV | data_resultRDY,
        1'b0);

endmodule
