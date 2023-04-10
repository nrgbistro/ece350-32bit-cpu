module SwitchHandler(
    output reg [31:0] swCode,
    input [3:0] switches);

    always @(*) begin
        case (switches)
            4'b0001: swCode = 4'd1;
            4'b0010: swCode = 4'd2;
            4'b0100: swCode = 4'd3;
            4'b1000: swCode = 4'd4;
            default: swCode = 4'd0;
        endcase
    end

endmodule
