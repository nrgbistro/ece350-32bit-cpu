module ButtonHandler(
    output reg [31:0] swCode,
    input [3:0] buttons);

    always @(*) begin
        case (buttons)
            4'b0001: swCode = 32'd1;
            4'b0010: swCode = 32'd2;
            4'b0100: swCode = 32'd3;
            4'b1000: swCode = 32'd4;
            default: swCode = 32'd0;
        endcase
    end

endmodule
