module PCControl(
    output [31:0] nextPC,
    output branch,
    input [31:0] PCPlusOne, executePC, executeT, executeA, executeImmediate,
    input [4:0] executeOpcode,
    input neq, lt);

    wire [31:0] branchAddr, executePCPlusImmediate;
    wire adderOverflow;

    adder_32 adder(executePCPlusImmediate, adderOverflow, executePC, executeImmediate, 1'b0);

    assign nextPC = branch ? branchAddr : PCPlusOne;
    assign branchAddr = (executeOpcode == 5'b00001) || (executeOpcode == 5'b00011) ? executeT :
                        (executeOpcode == 5'b00010 && neq) || (executeOpcode == 5'b00110 && lt) ? executePCPlusImmediate :
                        (executeOpcode == 5'b00100) ? executeA :
                        {32{1'bz}};

    assign branch = (executeOpcode == 5'b00001) ||
                    (executeOpcode == 5'b00011) ||
                    (executeOpcode == 5'b00100) ||
                    (executeOpcode == 5'b10110 && neq) ||
                    (executeOpcode == 5'b00010 && neq) ||
                    (executeOpcode == 5'b00110 && lt);
endmodule
