module multControl(
    output [1:0] productInputCode,
    output sub, shiftMultiplicand,
    input [4:0] count,
    input [2:0] opCode);

    // Force initial input when count == 00001
    assign productInputCode[1] = count == 5'b1;
    // Add unless opCode == 111 or 000
    assign productInputCode[0] = (opCode[0] | opCode[1] | opCode[2]) & (~opCode[0] | ~opCode[1] | ~opCode[2]) ? 1'b1 : 1'b0;

    assign shiftMultiplicand = (~opCode[2] & opCode[1] & opCode[0]) | (opCode[2] & ~opCode[1] & ~opCode[0]) ? 1'b1 : 1'b0;
    assign sub = opCode[2] ? 1'b1 : 1'b0;
endmodule
