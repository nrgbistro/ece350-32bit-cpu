module mult(
    output [31:0] ans,
    input [31:0] multiplicand, multiplier,
    input enable, clk, count0bool, rst);

    wire [65:0] product_out, product_in, initialProduct;
    wire [2:0] multOpCode;
    wire [1:0] productInputSelectWire;
    wire subCode;

    assign ans = product_out[33:2];
    assign opCode[1:0] = product_out[1:0];
    assign opCode[2] = product_out[2];

    assign initialProduct[1:0] = 2'b0;
    assign initialProduct[33:2] = multiplier;
    assign initialProduct[65:34] = 32'b0;

    multControl controller(productInputSelectWire, subCode, multOpCode, count0bool, enable);

    mux4_1 regProductInputSelector(product_in, productInputSelectWire, product_out >>> 1, 0, initialProduct, initialProduct);

    register66 regProduct( .out(product_out), .data(product_in), .clock(clk), .enable(enable), .reset(rst) );
    register32 regMultiplicand(.out(b), .data(b), .clock(clk), .enable(count0bool), .reset(rst));

endmodule
