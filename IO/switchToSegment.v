module SwitchToSegment(
    SEG, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, SW);

    output [6:0] SEG;
    input [31:0] reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9;
    input [3:0] SW;

    wire [6:0] SEGMENT[8:0];
    wire [31:0] currentRegData;

    assign currentRegData = SW == 4'b0001 ? reg1 :
                            SW == 4'b0010 ? reg2 :
                            SW == 4'b0011 ? reg3 :
                            SW == 4'b0100 ? reg4 :
                            SW == 4'b0101 ? reg5 :
                            SW == 4'b0110 ? reg6 :
                            SW == 4'b0111 ? reg7 :
                            SW == 4'b1000 ? reg8 :
                            SW == 4'b1001 ? reg9 :
                            32'd0;

    assign SEGMENT[0] = 7'b1111111;
    assign SEGMENT[1] = 7'b0000110;
    assign SEGMENT[2] = 7'b1011011;
    assign SEGMENT[3] = 7'b1001111;
    assign SEGMENT[4] = 7'b1100110;
    assign SEGMENT[5] = 7'b1101101;
    assign SEGMENT[6] = 7'b1111101;
    assign SEGMENT[7] = 7'b0000111;
    assign SEGMENT[8] = 7'b1111111;
    assign SEGMENT[9] = 7'b1101111;

    assign SEG = currentRegData == 32'd0 ? SEGMENT[0] :
                 currentRegData == 32'd1 ? SEGMENT[1] :
                 currentRegData == 32'd2 ? SEGMENT[2] :
                 currentRegData == 32'd3 ? SEGMENT[3] :
                 currentRegData == 32'd4 ? SEGMENT[4] :
                 currentRegData == 32'd5 ? SEGMENT[5] :
                 currentRegData == 32'd6 ? SEGMENT[6] :
                 currentRegData == 32'd7 ? SEGMENT[7] :
                 currentRegData == 32'd8 ? SEGMENT[8] :
                 currentRegData == 32'd9 ? SEGMENT[9] :
                 7'b0000000;


endmodule
