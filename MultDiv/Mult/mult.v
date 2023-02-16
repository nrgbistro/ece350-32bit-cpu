module mult(
    output [31:0] ans,
    output overflow,
    input [31:0] multiplicand, multiplier,
    input clk, count0bool, rst);

    wire [64:0] product_out, product_in, initialProduct, adderResultWithMultiplier;
    wire [31:0] adderResult, multiplicandShifterResult, regMultiplicandOut, productRegLeft;
    wire [2:0] multOpCode;
    wire [1:0] productInputSelectWire;

    register_65 regProduct( .out(product_out), .data(product_in), .clock(clk), .enable(1'b1), .reset(rst));

    // TEMP
    assign overflow = 1'b0;

    wire subCode, adderOverflow, shiftMultiplicand;

    assign ans = $signed(product_out[32:1]) >>> 2;
    assign productRegLeft = product_out[64:33];
    assign multOpCode[2:0] = product_out[2:0];

    // Set initial product to multiplier in lower product bits
    assign initialProduct[32:1] = multiplier;
    // Zero out other initial bits
    assign initialProduct[0] = 1'b0;
    assign initialProduct[64:33] = 32'b0;

    assign adderResultWithMultiplier[32:0] = product_out[32:0];
    assign adderResultWithMultiplier[64:33] = adderResult;

    adder_32 adder(adderResult, adderOverflow, multiplicandShifterResult, productRegLeft, subCode);

    multControl controller(productInputSelectWire, subCode, shiftMultiplicand, multOpCode, count0bool);

    // if (productInputSelectWire[1]) {product_in = initial product;}
    // if (productInputSelectWire[0]) {product_in = shifted product out;} else {product_in = adder result with multiplier;}
    mux_4_65 regProductInputSelector(product_in, productInputSelectWire, $signed(product_out) >>> 2, adderResultWithMultiplier >>> 2, initialProduct, initialProduct);
    mux_2 regMultiplicandShiftSelector(multiplicandShifterResult, shiftMultiplicand, multiplicand, multiplicand <<< 1);

endmodule
