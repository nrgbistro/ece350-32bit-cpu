`timescale 1ns / 1ps
module RAM #( parameter DATA_WIDTH = 32, ADDRESS_WIDTH = 12, DEPTH = 4096) (
    input wire                     clk,
    input wire                     wEn,
    input wire [ADDRESS_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0]    dataIn,
    output reg [DATA_WIDTH-1:0]    dataOut = 0,
    output reg [2:0] led);

    reg[DATA_WIDTH-1:0] MemoryArray[0:DEPTH-1];

    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            MemoryArray[i] <= 0;
        end
        // if(MEMFILE > 0) begin
        //     $readmemh(MEMFILE, MemoryArray);
        // end
    end

    always @(posedge clk) begin
        if(wEn) begin
            MemoryArray[addr] <= dataIn;
        end else begin
            dataOut <= MemoryArray[addr];
        end
        led[0] <= MemoryArray[DEPTH-1][0];
        led[1] <= MemoryArray[DEPTH-2][0];
        led[2] <= MemoryArray[DEPTH-3][0];
    end
endmodule
