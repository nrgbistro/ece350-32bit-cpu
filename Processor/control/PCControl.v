module PCControl(
    output [31:0] nextPC,
    input [31:0] PC, branchAddr,
    input branch);

    wire [31:0] PCPlusOne;
    wire adderOverflow;

    adder_32 PCAdder(PCPlusOne, adderOverflow, PC, 32'd1, 1'b0);
    assign nextPC = branch ? branchAddr : PCPlusOne;

endmodule
