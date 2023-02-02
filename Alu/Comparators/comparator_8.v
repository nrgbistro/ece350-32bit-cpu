module comparator_8(
    input [15:0] SW,
    output [1:0] LED,
    input CLK100MHZ);

    wire GT3, EQ3, GT2, EQ2, GT1, EQ1;
    wire [7:0] a, b;
    wire GT, EQ;
    wire GT_in, EQ_in;

    assign GT_in = 0;
    assign EQ_in = 1;

    assign a = SW[7:0];
    assign b = SW[15:8];
    assign LED[0] = EQ;
    assign LED[1] = GT;

    comparator_2 comp3(a[7:6], b[7:6], GT_in, EQ_in, GT3, EQ3);
    comparator_2 comp2(a[5:4], b[5:4], GT3, EQ3, GT2, EQ2);
    comparator_2 comp1(a[3:2], b[3:2], GT2, EQ2, GT1, EQ1);
    comparator_2 comp0(a[1:0], b[1:0], GT1, EQ1, GT, EQ);

    ila_0 debuggers(.clk(CLK100MHZ), .probe0(a), .probe1(b), .probe2(EQ), .probe3(GT));

endmodule
