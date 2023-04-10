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
	output [6:0] LED,
    input [6:0] SW,
	input [3:0] BTN,
    input clock, resetIn);

	// Clocking
	wire clk, segmentClock, reset;
	// 50 Mhz clock
	ClockDivider mainClockDiv(clk, clock, 5);
	// 200 Hz clock
	ClockDivider segmentClockDiv(segmentClock, clock, 20000);

	assign reset = ~resetIn;

    wire [31:0] reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9;
    wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData,
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;

	assign LED = SW;


	// ila_0 debugger(clock, currentData, d0, d1, d2, d3);
	SwitchToSegment SwitchToSegment(.SEG(SEG), .AN(AN), .reg1(reg1), .reg2(reg2), .reg3(reg3), .reg4(reg4), .reg5(reg5), .reg6(reg6), .reg7(reg7), .reg8(reg8), .reg9(reg9), .SW(SW[3:0]), .clock(segmentClock));

	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "pinball";

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

		.switches(BTN));

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
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB), .reg1(reg1), .reg2(reg2), .reg3(reg3), .reg4(reg4), .reg5(reg5), .reg6(reg6), .reg7(reg7), .reg8(reg8), .reg9(reg9));

	// Processor Memory (RAM)
	RAM ProcMem(.clk(clk),
		.wEn(mwe),
		.addr(memAddr[11:0]),
		.dataIn(memDataIn),
		.dataOut(memDataOut));

endmodule
