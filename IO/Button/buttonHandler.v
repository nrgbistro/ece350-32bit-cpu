module ButtonHandler(
    output reg [31:0] swCode,
    input [2:0] buttons);

    always @(*) begin
        case (buttons)
            3'b001: swCode = 32'd1;
            3'b010: swCode = 32'd2;
            3'b100: swCode = 32'd3;
            default: swCode = 32'd0;
        endcase
    end

endmodule
