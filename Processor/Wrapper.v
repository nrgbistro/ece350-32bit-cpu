`timescale 1ns / 1ps
/**
 *
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor,
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 *
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the
 * provided Wrapper interface.
 *
 * Refer to Lab 5 documents for detailed instructions on how to interface
 * with the memory elements. Each imem and dmem modules will take 12-bit
 * addresses and will allow for storing of 32-bit values at each address.
 * Each memory module should receive a single clock. At which edges, is
 * purely a design choice (and thereby up to you).
 *
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (
    output [6:0] SEG,
    output [7:0] AN,
	output [2:0] LED,
	output [3:1] JAout,
	output AUD_PWM, AUD_EN,
    input [6:0] SW,
	input [2:0] BTN,
	input [9:7] JAin,
    input clock, resetIn);

	assign JAout[1] = LED[1];
	assign JAout[2] = LED[0];
	assign JAout[3] = LED[2];

	wire [2:0] inputButtons;

	assign inputButtons[0] = BTN[0] || JAin[8];
	assign inputButtons[1] = BTN[1] || JAin[7];
	assign inputButtons[2] = BTN[2] || JAin[9];


	// Clocking
	wire clk, reset;
	// 50 Mhz clock
	ClockDivider mainClockDiv(clk, clock, 2);

	// Audio
    assign AUD_EN = 1'b1;

	AudioController audioController(clock, reg1[3:0], AUD_PWM);

	assign reset = resetIn;

    wire [31:0] reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31;
    wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData,
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;

	assign LED = reg22[2:0];

	ila_0 debug(clock, reg1, reg2, reg4, reg5, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg31);

	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "pinball";

	// Debounce Buttons
	wire [2:0] debouncedBTN;
	Debouncer Debounce0(.clk(clock), .pb_in(inputButtons[0]), .pb_out(debouncedBTN[0]));
	Debouncer Debounce1(.clk(clock), .pb_in(inputButtons[1]), .pb_out(debouncedBTN[1]));
	Debouncer Debounce2(.clk(clock), .pb_in(inputButtons[2]), .pb_out(debouncedBTN[2]));

	wire [6:0] cpuSEG, debugSEG;
	wire [7:0] cpuAN, debugAN;
	assign SEG = SW == 0 ? cpuSEG : debugSEG;
	assign AN = SW == 0 ? cpuAN : debugAN;
	SwitchToSegment segmentDebug(debugAN, debugSEG, SW, clk, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31);

	// Main Processing Unit
	processor CPU(.clock(clk), .reset(reset),

		// ROM
		.address_imem(instAddr), .q_imem(instData),

		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2),
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),

		// RAM
		.wren(mwe), .address_dmem(memAddr),
		.data(memDataIn), .q_dmem(memDataOut),

		.buttons(debouncedBTN),
		.segment(cpuSEG),
		.segmentMask(cpuAN));

	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clk),
		.addr(instAddr[11:0]),
		.dataOut(instData));

	// Register File

	regfile RegisterFile(.clock(clk),
		.ctrl_writeEnable(rwe), .ctrl_reset(reset),
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2),
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB), .reg1(reg1), .reg2(reg2), .reg3(reg3), .reg4(reg4), .reg5(reg5), .reg6(reg6), .reg7(reg7), .reg8(reg8), .reg9(reg9), .reg10(reg10), .reg11(reg11), .reg12(reg12), .reg13(reg13), .reg14(reg14), .reg15(reg15), .reg16(reg16), .reg17(reg17), .reg18(reg18), .reg19(reg19), .reg20(reg20), .reg21(reg21), .reg22(reg22), .reg23(reg23), .reg24(reg24), .reg25(reg25), .reg26(reg26), .reg27(reg27), .reg28(reg28), .reg29(reg29), .reg30(reg30), .reg31(reg31));

	// Processor Memory (RAM)
	RAM ProcMem(.clk(clk),
		.wEn(mwe),
		.addr(memAddr[11:0]),
		.dataIn(memDataIn),
		.dataOut(memDataOut));

endmodule
