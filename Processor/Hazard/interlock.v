module Interlock(
    output stall,
    input [31:0] decodeIR, executeIR, memoryIR);

    wire [4:0] decodeRS1, decodeRS2, executeRD, memoryRD;
    wire [1:0] decodeInsType, executeInsType, memoryInsType;

    TypeDetector decodeTypeDetector(decodeInsType, decodeIR);
    TypeDetector executeTypeDetector(executeInsType, executeIR);
    TypeDetector memoryTypeDetector(memoryInsType, memoryIR);

    assign decodeRS1 = decodeIR[21:17];
    assign decodeRS2 = decodeIR[16:12];
    assign executeRD = executeIR[26:22];
    assign memoryRD = memoryIR[26:22];

    assign stall = (decodeRS1 != 5'b0 && (decodeRS1 == executeRD || decodeRS1 == memoryRD)) ||
                   (decodeRS2 != 5'b0 && (decodeRS2 == executeRD || decodeRS2 == memoryRD));


endmodule
