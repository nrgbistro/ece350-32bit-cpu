module alu_op(
    output [31:0] out,
    input [2:0] opcode,
    input [31:0] andData, orData, addData, subData, SLLData, SRAData);

    mux_8 mux(out, opcode, addData, subData, andData, orData, SLLData, SRAData, {32{1'bz}}, {32{1'bz}});
endmodule
