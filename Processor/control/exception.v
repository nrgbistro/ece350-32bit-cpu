module Exception(
    output exception,
    output [31:0] exceptionData,
    input [31:0] ins,
    input error);

    wire [4:0] op, aluOp;
    wire [1:0] insType;

    TypeDetector typeDetector(insType, ins);
    assign aluOp = ins[6:2];
    assign op = ins[31:27];

    assign exceptionData = error && insType == 2'd0 ?
                                   aluOp == 5'b00000 ? 32'd1 :
                                   aluOp == 5'b00001 ? 32'd3 :
                                   aluOp == 5'b00110 ? 32'd4 :
                                   aluOp == 5'b00111 ? 32'd5 :
                                   error && op == 5'b00101 ? 32'd2 :
                                   {32{1'bz}} : {32{1'bz}};


endmodule
