module mult(
    output [31:0] ans,
    input [31:0] multiplicand, multiplier,
    input enable, clk, count0bool, rst);

    wire [64:0] product_out, product_in, initialProduct;
    wire [31:0] adderResult;
    wire [2:0] multOpCode;
    wire [1:0] productInputSelectWire;
    wire subCode, adderOverflow;

    assign ans = product_out[32:1];
    assign opCode[1:0] = product_out[1:0];
    assign opCode[2] = product_out[2];

    assign initialProduct[0] = 2'b0;
    assign initialProduct[32:1] = multiplier;
    assign initialProduct[64:33] = 32'b0;

    adder_32 adder(adderResult, adderOverflow, );

    assign multOpCode[2:0] = product_out[2:0];

    multControl controller(productInputSelectWire, subCode, multOpCode, count0bool, enable);

    //
    mux4_65 regProductInputSelector(product_in, productInputSelectWire, product_out >>> 2, adder_result >>> 2, initialProduct, initialProduct);

    register65 regProduct( .out(product_out), .data(product_in), .clock(clk), .enable(enable), .reset(rst) );
    register32 regMultiplicand(.out(b), .data(b), .clock(clk), .enable(count0bool), .reset(rst));

endmodule
