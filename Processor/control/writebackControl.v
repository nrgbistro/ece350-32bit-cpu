module WritebackControl(
    output [1:0] insType,
    output dataSelector, writeEnable,
    input [31:0] ins);

    wire [4:0] op;
    wire [1:0] insType;

    TypeDetector typeDetector(insType, ins);

    assign op = ins[31:27];
    assign dataSelector = 1'b0;
    assign writeEnable = 1'b1;

endmodule
