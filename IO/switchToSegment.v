module SwitchToSegment(
    SEG, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, SW, clock);

    output reg [6:0] SEG;
    input [31:0] reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9;
    input [3:0] SW;
    input clock;

    parameter SEGMENT0 = 7'b1000000;
    parameter SEGMENT1 = 7'b1111001;
    parameter SEGMENT2 = 7'b0100100;
    parameter SEGMENT3 = 7'b0110000;
    parameter SEGMENT4 = 7'b0011001;
    parameter SEGMENT5 = 7'b0010010;
    parameter SEGMENT6 = 7'b0000010;
    parameter SEGMENT7 = 7'b1111000;
    parameter SEGMENT8 = 7'b0000000;
    parameter SEGMENT9 = 7'b0010000;
    parameter SEGMENTBROKEN = 7'b1110111;

    always @(*) begin
        case (reg2)
            32'd0: SEG = SEGMENT0;
            32'd1: SEG = SEGMENT1;
            32'd2: SEG = SEGMENT2;
            32'd3: SEG = SEGMENT3;
            32'd4: SEG = SEGMENT4;
            32'd5: SEG = SEGMENT5;
            32'd6: SEG = SEGMENT6;
            32'd7: SEG = SEGMENT7;
            32'd8: SEG = SEGMENT8;
            32'd9: SEG = SEGMENT9;
            default: SEG = SEGMENTBROKEN;
        endcase
    end

endmodule
