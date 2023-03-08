module FetchControl(
    output [1:0] insType,
    output writeEnable,
    input [31:0] ins);

    wire [1:0] insType;

    TypeDetector typeDetector(insType, ins);

    assign writeEnable = 1'b1;

endmodule
