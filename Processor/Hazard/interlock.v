module Interlock(
    output stall,
    input [31:0] decodeIR, executeIR, memoryIR);

    wire [4:0] decodeRS1, decodeRS2, executeRD, memoryRD, decodeOpcode, executeOpcode, memoryOpcode;
    wire [1:0] decodeInsType, executeInsType, memoryInsType;

    TypeDetector decodeTypeDetector(decodeInsType, decodeIR);
    TypeDetector executeTypeDetector(executeInsType, executeIR);
    TypeDetector memoryTypeDetector(memoryInsType, memoryIR);

    assign decodeRS1 = decodeIR[21:17];
    assign decodeRS2 = decodeIR[16:12];
    assign executeRD = executeIR[26:22];
    assign memoryRD = memoryIR[26:22];
    assign decodeOpcode = decodeIR[31:27];
    assign executeOpcode = executeIR[31:27];
    assign memoryOpcode = memoryIR[31:27];

    assign stall = (executeOpcode == 5'b01000) && (decodeRS1 == executeRD || ((decodeRS2 == executeRD) && decodeOpcode != 5'b00111));

endmodule
