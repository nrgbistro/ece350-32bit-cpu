module WritebackControl(
    output [1:0] insType,
    output dataSelector, writeEnable,
    input [31:0] ins);

    wire [4:0] op;
    wire [1:0] insType;

    TypeDetector typeDetector(insType, ins);

    assign op = ins[31:27];
    assign dataSelector = op == 5'b01000;
    assign writeEnable = op == 5'b00000 || op == 5'b00101 ||
                         op == 5'b01000 || op == 5'b00011 ||
                         op == 5'b10101;

endmodule
