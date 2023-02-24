module mult(
    output [31:0] ans,
    output overflow, resultRDY, count0,
    input [31:0] multiplicand, multiplier,
    input clk, rst);

    wire [64:0] product_out, product_in, initialProduct, adderResultWithMultiplier, finalShiftedProduct;
    wire [31:0] adderResult, multiplicandShifterResult, regMultiplicandOut, productRegLeft, adderInputB;
    wire [4:0] count;
    wire [2:0] multOpCode;
    wire [1:0] productInputSelectWire;
    wire subCode, adderOverflow, shiftMultiplicand, regLeftAllZero, regLeftAllOne, specialOverflowCase0, specialOverflowCase1;


    // 1 when count == 00000
    assign count0 = ~count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4];
    // 1 when count == 10000 (16 steps)
    assign resultRDY = count[4];

    // Counts from 0 to 17
    counter_16 counter0(
        count,
        clk,
        rst);

    register_65 regProduct( .out(product_out), .data(product_in), .clock(clk), .enable(1'b1), .reset(rst));

    checkBits_32 checkResult(regLeftAllZero, regLeftAllOne, productRegLeft);

    specialCaseChecker specialCaseChecker0(specialOverflowCase0, multiplicand, multiplier);
    specialCaseChecker specialCaseChecker1(specialOverflowCase1, multiplier, multiplicand);

    assign overflow = specialOverflowCase0 | specialOverflowCase1 ? 1'b0 : (~regLeftAllZero & ~regLeftAllOne) || (ans[31] & regLeftAllZero) || (~ans[31] & regLeftAllOne);

    assign finalShiftedProduct = $signed(product_out) >>> 2;
    assign ans = finalShiftedProduct[32:1];
    assign productRegLeft = product_out[64:33];
    assign multOpCode = product_out[2:0];

    // Set initial product to multiplier in lower product bits
    assign initialProduct[32:1] = multiplier;
    // Zero out other initial bits
    assign initialProduct[0] = 1'b0;
    assign initialProduct[64:33] = 32'b0;

    assign adderResultWithMultiplier[32:0] = product_out[32:0];
    assign adderResultWithMultiplier[64:33] = adderResult;

    adder_32 adder(adderResult, adderOverflow, productRegLeft, adderInputB, subCode);

    multControl controller(productInputSelectWire, subCode, shiftMultiplicand, multOpCode, count0);

    // if (productInputSelectWire[1]) {product_in = initial product;}
    // if (productInputSelectWire[0]) {product_in = shifted product out;} else {product_in = adder result with multiplier;}
    mux_4_65 regProductInputSelector(product_in, productInputSelectWire, $signed(product_out) >>> 2, $signed(adderResultWithMultiplier) >>> 2, initialProduct, $signed(adderResultWithMultiplier) >>> 2);
    assign multiplicandShifterResult = shiftMultiplicand ? multiplicand <<< 1 : multiplicand;
    assign adderInputB = count0 ? initialProduct : multiplicandShifterResult;

endmodule
