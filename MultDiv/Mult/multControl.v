module multControl(
    output [1:0] productInputCode,
    output sub, shiftMultiplicand,
    input [2:0] opCode,
    input count0bool, shiftOnly);

    wire chooseAdd;

    assign productInputCode[0] = chooseAdd;
    // Force initial input when count == 0000
    assign productInputCode[1] = count0bool;

    assign shiftMultiplicand = (~opCode[0] & opCode[1] & opCode[2]) | (opCode[0] & ~opCode[1] & ~opCode[2]) ? 1'b1 : 1'b0;
    assign sub = (opCode[0] & ~opCode[1]) | (opCode[0] & opCode[1] & opCode[2]) ? 1'b1 : 1'b0;
    assign chooseAdd = (opCode[0] | opCode[1] | opCode[2]) & (~opCode[0] | ~opCode[1] | ~opCode[2]) & (~shiftOnly) ? 1'b1 : 1'b0;
endmodule
