module SegmentWrapper(
    output [7:0] AN,
    output [6:0] SEG,
    input [31:0] regData,
    input clock, reset, enable, N);

    assign AN = ~segmentClock ? {4'b1111, ANRight} : {ANLeft, 4'b1111};
    assign SEG = ~segmentClock ? segmentRight : segmentLeft;

    wire segmentClock;

    // 200 hz clock
	ClockDivider mainClockDiv(segmentClock, clock, 25000);

    counter_4 frameCounterR(countRight, segmentClock, reset);
    counter_4 frameCounterL(countLeft, ~segmentClock, reset);

    wire [6:0] segmentLeft, segmentRight;
    wire [3:0] ANLeft, ANRight;

    wire [1:0] countLeft, countRight;

    RegToSegment RegisterToSegmentRight(.SEG(segmentRight), .AN(ANRight), .regData(regData), .mainClock(clock),
                                        .enable(N == 0 && enable), .reset(reset), .count(countRight));

    RegToSegment RegisterToSegmentLeft(.SEG(segmentLeft), .AN(ANLeft), .regData(regData), .mainClock(clock),
                                        .enable(N == 1 && enable), .reset(reset), .count(countLeft));

endmodule
