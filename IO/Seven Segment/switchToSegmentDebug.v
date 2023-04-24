module SwitchToSegment(
    AN, SEG, SW, clock, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31);

    output reg [6:0] SEG;
    output reg [7:0] AN;
    input [31:0] reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31;
    input [6:0] SW;
    input clock;

    wire segClock;

    reg [31:0] currentData;
    reg [3:0] currentFrame;
    reg [3:0] halfAN;
    wire [1:0] count;

    // ila_0 debug(clock, reg24, reg25, reg26, reg4);

    ClockDivider clockDivider(segClock, clock, 50000);
    counter_4 frameCounter(count, segClock, 1'b0);

    parameter SEGMENT0 = 7'b1000000;
    parameter SEGMENT1 = 7'b1001111;
    parameter SEGMENT2 = 7'b0100100;
    parameter SEGMENT3 = 7'b0000110;
    parameter SEGMENT4 = 7'b0001011;
    parameter SEGMENT5 = 7'b0010010;
    parameter SEGMENT6 = 7'b0010000;
    parameter SEGMENT7 = 7'b1000111;
    parameter SEGMENT8 = 7'b0000000;
    parameter SEGMENT9 = 7'b0000010;
    parameter SEGMENTBROKEN = 7'b1110111;

    wire [15:0] BCDOut;
    wire [3:0] d0, d1, d2, d3;

    BCD BCD(currentData[15:0], BCDOut);

    assign d0 = BCDOut[3:0];
    assign d1 = BCDOut[7:4];
    assign d2 = BCDOut[11:8];
    assign d3 = BCDOut[15:12];

    always @(*) begin
        currentData <= SW == 6'd1 ? reg1 :
                        SW == 6'd2 ? reg2 :
                        SW == 6'd3 ? reg3 :
                        SW == 6'd4 ? reg4 :
                        SW == 6'd5 ? reg5 :
                        SW == 6'd6 ? reg6 :
                        SW == 6'd7 ? reg7 :
                        SW == 6'd8 ? reg8 :
                        SW == 6'd9 ? reg9 :
                        SW == 6'd10 ? reg10 :
                        SW == 6'd11 ? reg11 :
                        SW == 6'd12 ? reg12 :
                        SW == 6'd13 ? reg13 :
                        SW == 6'd14 ? reg14 :
                        SW == 6'd15 ? reg15 :
                        SW == 6'd16 ? reg16 :
                        SW == 6'd17 ? reg17 :
                        SW == 6'd18 ? reg18 :
                        SW == 6'd19 ? reg19 :
                        SW == 6'd20 ? reg20 :
                        SW == 6'd21 ? reg21 :
                        SW == 6'd22 ? reg22 :
                        SW == 6'd23 ? reg23 :
                        SW == 6'd24 ? reg24 :
                        SW == 6'd25 ? reg25 :
                        SW == 6'd26 ? reg26 :
                        SW == 6'd27 ? reg27 :
                        SW == 6'd28 ? reg28 :
                        SW == 6'd29 ? reg29 :
                        SW == 6'd30 ? reg30 :
                        SW == 6'd31 ? reg31 :
                        32'd0;
        case (count)
            2'd0: begin
                    currentFrame = d0;
                    halfAN = 4'b0111;
                  end
            2'd1: begin
                      currentFrame = d1;
                      halfAN = 4'b1011;
                  end
            2'd2: begin
                    currentFrame = d2;
                    halfAN = 4'b1101;
                  end
            2'd3: begin
                    currentFrame = d3;
                    halfAN = 4'b1110;
                  end
            default: begin
                        currentFrame = 4'd0;
                        halfAN = 4'b1111;
                     end
        endcase

        AN[7:4] <= 4'b1111;
        AN[3:0] <= halfAN;

        case (currentFrame)
            4'd0: SEG = SEGMENT0;
            4'd1: SEG = SEGMENT1;
            4'd2: SEG = SEGMENT2;
            4'd3: SEG = SEGMENT3;
            4'd4: SEG = SEGMENT4;
            4'd5: SEG = SEGMENT5;
            4'd6: SEG = SEGMENT6;
            4'd7: SEG = SEGMENT7;
            4'd8: SEG = SEGMENT8;
            4'd9: SEG = SEGMENT9;
            default: SEG = SEGMENTBROKEN;
        endcase
    end

endmodule
