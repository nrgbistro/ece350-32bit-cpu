/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements.
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile

	);

	// Control signals
	input clock, reset;

	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

    wire [31:0] fetchPC, nextPC, PCPlusOne;
    wire overflow1;

    // Fetch
    ProgramCounter pogramCounter(fetchPC, nextPC, ~clock, reset);
    adder_32 adderPC_1(PCPlusOne, overflow1, fetchPC, 32'd1, 1'b0);


    // Decode
    wire [31:0] decodeIR, decodePC;
    wire [4:0] rd, rs, rt;
    wire [1:0] decodeInsType;

    FetchDecode fetchDecodeLatch(decodeIR, decodePC, q_imem, PCPlusOne, ~clock, reset);
    DecodeControl decodeController(decodeInsType, ctrl_writeEnable, decodeIR);

    mux_4 select_rd(rd, decodeInsType, decodeIR[26:22], decodeIR[26:22], 32'b0, decodeIR[26:22]);
    mux_4 select_rs(rs, decodeInsType, decodeIR[21:17], decodeIR[21:17], 32'b0, 32'b0);
    mux_4 select_rt(rt, decodeInsType, decodeIR[16:12], 32'b0, 32'b0, 32'b0);

    assign ctrl_readRegA = rs;

    // Execute
    wire [31:0] executeIR, executeA, executeB, executePC, aluBInput, executeImmediate, aluSum;
    wire [4:0] aluOpCode, shiftAmt;
    wire [1:0] executeInsType;
    wire aluBSelector, aluOverflow, aluNEQ, aluLT;
    DecodeExecute decodeExecuteLatch(executeIR, executeA, executeB, executePC, decodeIR, data_readRegA, data_readRegB, decodePC, ~clock, reset);
    ExecuteControl executeController(executeInsType, aluOpCode, shiftAmt, aluBSelector, executeIR);

    SignExtender_16 signExtenderExecuteImm(executeImmediate, executeIR[16:0]);
    assign aluBInput = aluBSelector ? executeImmediate : executeB;

    alu mainALU(executeA, aluBInput, aluOpCode, shiftAmt, aluSum, aluNEQ, aluLT, aluOverflow);

    // Memory
    wire [31:0] memoryIR, memoryO, memoryB;
    ExecuteMemory executeMemoryLatch(memoryIR, memoryO, memoryB, executeIR, aluSum, executeB, ~clock, reset);

    assign address_dmem = memoryO;
    assign data = memoryB;

    // TEMP
    assign wren = 1'b0;

    // Writeback

	/* END CODE */

endmodule
