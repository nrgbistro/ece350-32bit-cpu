module RegToSegment(
    AN, SEG, regData, clock, N, mainClock, enable);

    output reg [6:0] SEG;
    output reg [7:0] AN;
    input [31:0] regData;
    input clock, mainClock, N, enable;

    reg [3:0] currentFrame;
    reg [3:0] halfAN;
    wire [1:0] count;

    counter_4 frameCounter(count, clock, 1'b0);

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

    wire [31:0] tempLatchedRegData, latchedRegData;
    wire [20:0] BCDOut;
    wire [3:0] d0, d1, d2, d3;

    register_32 regDataLatch0(tempLatchedRegData, regData, ~mainClock, enable, 1'b0);
    register_32 regDataLatch1(latchedRegData, tempLatchedRegData, mainClock, enable, 1'b0);

    BCD BCD(latchedRegData[15:0], BCDOut);

    assign d0 = BCDOut[3:0];
    assign d1 = BCDOut[7:4];
    assign d2 = BCDOut[11:8];
    assign d3 = BCDOut[15:12];

    ila_0 debugger(mainClock, latchedRegData, d0, d1, d2, d3, enable);

    always @(*) begin
        case (count)
            2'd0: begin
                    currentFrame = d0;
                    halfAN = 4'b1110;
                  end
            2'd1: begin
                      currentFrame = d1;
                      halfAN = 4'b1101;
                  end
            2'd2: begin
                    currentFrame = d2;
                    halfAN = 4'b1011;
                  end
            2'd3: begin
                    currentFrame = d3;
                    halfAN = 4'b0111;
                  end
            default: begin
                        currentFrame = 4'd0;
                        halfAN = 4'b1111;
                     end
        endcase

        AN[7:4] = 4'b1111;
        AN[3:0] = halfAN;

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
