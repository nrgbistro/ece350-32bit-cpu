module SwitchToSegment(
    SEG, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, SW, clock);

    output reg [6:0] SEG;
    input [31:0] reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9;
    input [3:0] SW;
    input clock;

    wire [6:0] SEGMENT[9:0];
    wire [31:0] currentRegData;

    // assign currentRegData = SW == 4'b0001 ? reg1 :
    //                         SW == 4'b0010 ? reg2 :
    //                         SW == 4'b0011 ? reg3 :
    //                         SW == 4'b0100 ? reg4 :
    //                         SW == 4'b0101 ? reg5 :
    //                         SW == 4'b0110 ? reg6 :
    //                         SW == 4'b0111 ? reg7 :
    //                         SW == 4'b1000 ? reg8 :
    //                         SW == 4'b1001 ? reg9 :
    //                         32'd0;

    assign currentRegData = reg2;

    assign SEGMENT[0] = 7'b1000000;
    assign SEGMENT[1] = 7'b1111001;
    assign SEGMENT[2] = 7'b0100100;
    assign SEGMENT[3] = 7'b0110000;
    assign SEGMENT[4] = 7'b0011001;
    assign SEGMENT[5] = 7'b0010010;
    assign SEGMENT[6] = 7'b0000010;
    assign SEGMENT[7] = 7'b1111000;
    assign SEGMENT[8] = 7'b0000000;
    assign SEGMENT[9] = 7'b0010000;

    always @(posedge clock) begin
        if(currentRegData == 32'd0) begin
            SEG <= SEGMENT[0];
        end else if(currentRegData == 32'd1) begin
            SEG <= SEGMENT[1];
        end else if(currentRegData == 32'd2) begin
            SEG <= SEGMENT[2];
        end else if(currentRegData == 32'd3) begin
            SEG <= SEGMENT[3];
        end else if(currentRegData == 32'd4) begin
            SEG <= SEGMENT[4];
        end else if(currentRegData == 32'd5) begin
            SEG <= SEGMENT[5];
        end else if(currentRegData == 32'd6) begin
            SEG <= SEGMENT[6];
        end else if(currentRegData == 32'd7) begin
            SEG <= SEGMENT[7];
        end else if(currentRegData == 32'd8) begin
            SEG <= SEGMENT[8];
        end else if(currentRegData == 32'd9) begin
            SEG <= SEGMENT[9];
        end
    end

    // assign SEG = currentRegData == 32'd0 ? SEGMENT[0] :
    //              currentRegData == 32'd1 ? SEGMENT[1] :
    //              currentRegData == 32'd2 ? SEGMENT[2] :
    //              currentRegData == 32'd3 ? SEGMENT[3] :
    //              currentRegData == 32'd4 ? SEGMENT[4] :
    //              currentRegData == 32'd5 ? SEGMENT[5] :
    //              currentRegData == 32'd6 ? SEGMENT[6] :
    //              currentRegData == 32'd7 ? SEGMENT[7] :
    //              currentRegData == 32'd8 ? SEGMENT[8] :
    //              currentRegData == 32'd9 ? SEGMENT[9] :
    //              7'b0000000;

    // assign SEG = SW == 4'b0001 ? SEGMENT[1] :
    //              SW == 4'b0010 ? SEGMENT[2] :
    //                 SW == 4'b0011 ? SEGMENT[3] :
    //                 SW == 4'b0100 ? SEGMENT[4] :
    //                 SW == 4'b0101 ? SEGMENT[5] :
    //                 SW == 4'b0110 ? SEGMENT[6] :
    //                 SW == 4'b0111 ? SEGMENT[7] :
    //                 SW == 4'b1000 ? SEGMENT[8] :
    //                 SW == 4'b1001 ? SEGMENT[9] :
    //                 SEGMENT[0];

endmodule
