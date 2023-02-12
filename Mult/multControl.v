module multControl(
    output [1:0] productInputCode,
    output sub, shiftMultiplicand,
    input [2:0] opCode,
    input count0bool, enable);

    wire chooseAdd;

    assign productInputCode[0] = chooseAdd;
    assign productInputCode[1] = count0bool;

    assign shiftMultiplicand = (~opCode[0] & opCode[1] & opCode[2]) | (opCode[0] & ~opCode[1] & ~opCode[2]) ? 1'b1 : 1'b0;

endmodule
