module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	output [31:0] data_readRegA, data_readRegB;
    output [31:0] reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9;

    // 32bit register selection bus for each 1bit register
    wire [31:0] regOut[31:0];
    wire [31:0] triStateSelectA, triStateSelectB, selectWriteRegDecoded;

    decoder_32 decoderA(triStateSelectA, 1'b1, ctrl_readRegA);
    decoder_32 decoderB(triStateSelectB, 1'b1, ctrl_readRegB);
    decoder_32 selectWriteReg(selectWriteRegDecoded, ctrl_writeEnable, ctrl_writeReg);

    genvar i;
    for (i = 0; i < 32; i = i + 1) begin : registers
        // Don't allow reg0 to be written to
        if(i == 0) begin
            register_32 reg32(regOut[i], data_writeReg, clock, 1'b0, ctrl_reset);
        end else begin
            register_32 reg32(regOut[i], data_writeReg, clock, selectWriteRegDecoded[i], ctrl_reset);
        end
        tri_state32 triStateA(data_readRegA, triStateSelectA[i], regOut[i]);
        tri_state32 triStateB(data_readRegB, triStateSelectB[i], regOut[i]);
    end

endmodule
