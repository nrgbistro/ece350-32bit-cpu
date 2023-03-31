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
	output reg LED,
    input [3:0] SW,
    input clock, reset);

	wire clk;
	HalfClock clockDiv(clk, clock);

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData,
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;

	assign AN = 8'b11111110;

	reg[1:0] count = 0;
    reg clockReg = 0;
    wire[31:0] countLim;

    assign countLim = (100000000/500) >> 1;

    always @(posedge clock) begin
		if (reg2 == 2) begin
			LED <= 1'b1;
		end
        if (count < countLim) begin
            count <= count + 1;
        end else begin
            count <= 0;
            clockReg <= ~clockReg;
        end
    end


	SwitchToSegment SwitchToSegment(.SEG(SEG), .reg1(reg1), .reg2(reg2), .reg3(reg3), .reg4(reg4), .reg5(reg5), .reg6(reg6), .reg7(reg7), .reg8(reg8), .reg9(reg9), .SW(switch), .clock(clockReg));

	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "addi_basic";

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
		.data(memDataIn), .q_dmem(memDataOut));

	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clk),
		.addr(instAddr[11:0]),
		.dataOut(instData));

	// Register File
	wire [31:0] reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9;
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
