module mult(
    output [31:0] ans, overflow,
    input [31:0] multiplicand, multiplier,
    input enable, clk, count0bool, rst);

    wire [64:0] product_out, product_in, initialProduct;
    wire [31:0] adderResult, multiplicandShifterResult, regMultiplicandOut, productRegLeft;
    wire [2:0] multOpCode;
    wire [1:0] productInputSelectWire;

    wire subCode, adderOverflow, shiftMultiplicand;

    assign opCode[2:0] = product_out[2:0];
    assign ans = product_out[32:1];
    assign productRegLeft = product_out[64:33];

    // Set initial product to multiplier in lower bits and 0 else
    assign initialProduct[0] = 1'b0;
    assign initialProduct[32:1] = multiplier;
    assign initialProduct[64:33] = 32'b0;

    adder_32 adder(adderResult, adderOverflow, multiplicandShifterResult, productRegLeft, subCode);

    assign multOpCode[2:0] = product_out[2:0];

    multControl controller(productInputSelectWire, subCode, shiftMultiplicand, multOpCode, count0bool, enable);

    // if (productInputSelectWire[1]) {product_in = initialProduct;}
    mux4_65 regProductInputSelector(product_in, productInputSelectWire, product_out >>> 2, adder_result >>> 2, initialProduct, initialProduct);
    mux2 regMultiplicandShiftSelector(multiplicandShifterResult, shiftMultiplicand, multiplicand, multiplicand <<< 1);

    register65 regProduct( .out(product_out), .data(product_in), .clock(clk), .enable(enable), .reset(rst) );
    register32 regMultiplicand(.out(regMultiplicandOut), .data(productInputSelectWire), .clock(clk), .enable(count0bool), .reset(rst));

endmodule
