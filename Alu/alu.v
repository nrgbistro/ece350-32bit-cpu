module alu(
    input [31:0] data_operandA, data_operandB,
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt,
    output [31:0] data_result,
    output isNotEqual, isLessThan, overflow);

    wire [31:0] andWire, orWire, addWire, subWire, SLWire, SRWire, subB, adderArgB;

    and_32 and_32(andWire, data_operandA, data_operandB);
    or_32 or_32(orWire, data_operandA, data_operandB);

    twos_complement twos_complement(subB, data_operandB);

    mux_2 add_sub_selector(adderArgB, ctrl_ALUopcode[0], data_operandB, subB);

    adder_32 adder_32(addWire, overflow, data_operandA, adderArgB);

    alu_op alu_op(data_result, ctrl_ALUopcode[2:0], andWire, orWire, addWire, addWire, SLWire, SRWire);
endmodule
