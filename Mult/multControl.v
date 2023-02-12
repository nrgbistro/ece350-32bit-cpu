module multControl(
    output [1:0] productInputCode,
    output sub,
    input [2:0] opCode,
    input count0bool, enable);

    wire chooseAdd;

    assign productInputCode[0] = chooseAdd;
    assign productInputCode[1] = count0bool;

endmodule
