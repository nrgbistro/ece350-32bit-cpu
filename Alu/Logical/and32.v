module and32(
    output [31:0] result,
    input [31:0] a, b);

    genvar i;
    for(i = 0; i < 32; i = i + 1) begin : andGates
        and(result[i], a[i], b[i]);
    end
endmodule
