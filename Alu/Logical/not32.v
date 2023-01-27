module not32(
    output [31:0] result,
    input [31:0] in);

    genvar i;
    for(i = 0; i < 32; i = i + 1) begin : gen_loop
        not(result[i], in[i]);
    end
endmodule
