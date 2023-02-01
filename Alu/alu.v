module alu(
    input [31:0] data_operandA, data_operandB,
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt,
    output [31:0] data_result,
    output isNotEqual, isLessThan, overflow);

    wire [31:0] andWire, orWire, addWire, subWire, SLWire, SRWire;

    and32 and32(andWire, data_operandA, data_operandB);
    or32 or32(orWire, data_operandA, data_operandB);
    adder_32 adder_32(addWire, overflow, data_operandA, data_operandB);

    alu_op alu_op(data_result, ctrl_ALUopcode[2:0], andWire, orWire, addWire, subWire, SLWire, SRWire);
endmodule
