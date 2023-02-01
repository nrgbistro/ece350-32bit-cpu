`timescale 1 ns / 100 ps
module adder_8_tb;
    reg a0, a1, a2, a3, a4, a5, a6, a7;
    reg b0, b1, b2, b3, b4, b5, b6, b7;
    wire [7:0] A, B;

    reg Cin;
    wire [7:0] Sum;
    wire PG, GG;

    adder_8 adder(Sum, PG, GG, A, B, Cin);

    // Initialize Registers
    initial begin
        Cin = 0;
        a0 = 0;
        a1 = 0;
        a2 = 0;
        a3 = 0;
        a4 = 0;
        a5 = 0;
        a6 = 0;
        a7 = 0;

        b0 = 1;
        b1 = 0;
        b2 = 0;
        b3 = 0;
        b4 = 0;
        b5 = 0;
        b6 = 0;
        b7 = 0;
    end
    assign A[0] = a0;
    assign A[1] = a1;
    assign A[2] = a2;
    assign A[3] = a3;
    assign A[4] = a4;
    assign A[5] = a5;
    assign A[6] = a6;
    assign A[7] = a7;

    assign B[0] = b0;
    assign B[1] = b1;
    assign B[2] = b2;
    assign B[3] = b3;
    assign B[4] = b4;
    assign B[5] = b5;
    assign B[6] = b6;
    assign B[7] = b7;


    always
        #10 a0 = ~a0;
    always
        #20 a1 = ~a1;
    always
        #40 a2 = ~a2;
    always
        #80 a3 = ~a3;
    always
        #160 a4 = ~a4;
    always
        #320 a5 = ~a5;
    always
        #640 a6 = ~a6;
    always
        #1280 a7 = ~a7;

    always
        #15 b0 = ~b0;
    always
        #30 b1 = ~b1;
    always
        #60 b2 = ~b2;
    always
        #120 b3 = ~b3;
    always
        #240 b4 = ~b4;
    always
        #480 b5 = ~b5;
    always
        #960 b6 = ~b6;
    always
        #1920 b7 = ~b7;

    // Print out results
    always @(A, B, Sum) begin
        #1;
        $display("%d + %d = %d", A, B, Sum);

        if (A + B >= 256) begin
            $finish;
        end
    end

    initial begin
        $dumpfile("adder_8_tb.vcd");
        $dumpvars(0, adder_8_tb);
    end

endmodule
