module alu(
    input [31:0] data_operandA, data_operandB,
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt,
    output [31:0] data_result,
    output isNotEqual, isLessThan, overflow);

    wire [31:0] andWire, orWire, addWire, SLWire, SRWire;
    wire eq;

    and_32 and_32(andWire, data_operandA, data_operandB);
    or_32 or_32(orWire, data_operandA, data_operandB);

    comparator_32 comparator_32(isLessThan, eq, data_operandA, data_operandB);
    not NEQNot(isNotEqual, eq);

    adder_32 adder_32(addWire, overflow, data_operandA, data_operandB, ctrl_ALUopcode[0]);

    shift_left SLL(SLWire, ctrl_shiftamt, data_operandA);
    shift_right SRA(SRWire, ctrl_shiftamt, data_operandA);

    alu_op alu_op(data_result, ctrl_ALUopcode[2:0], andWire, orWire, addWire, addWire, SLWire, SRWire);
endmodule
