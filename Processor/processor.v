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

    wire overflow1, multDivStall, stallPC, stallFD, stallDX, stallXM, stallMW;

    // Stall
    MultDivStall multDivStallModule(multDivStall, executeIR, multDivDone);
    assign stallPC = multDivStall || interlockStall;
    assign stallFD = multDivStall || interlockStall;
    assign stallDX = multDivStall;
    assign stallXM = multDivStall;
    assign stallMW = 1'b0;

    // Interlock
    wire interlockStall;
    Interlock interlock(interlockStall, decodeIR, executeIR, memoryIR);

    // Bypassing
    wire [1:0] ALU_A_bypass, ALU_B_bypass;
    wire dmem_bypass;
    Bypass bypass(ALU_A_bypass, ALU_B_bypass, dmem_bypass, executeIR, memoryIR, writebackIR);

    // Fetch
    wire [31:0] PC, nextPC, PCPlusOne;
    wire branch, PCOverflow;


    ProgramCounter programCounter(PC, nextPC, ~clock, stallPC, reset);
    PCControl programCountController(nextPC, branch, PCPlusOne, executePC, executeT, executeA, executeImmediate, executeOpcode, aluNEQ, aluLT);
    adder_32 PCAdder(PCPlusOne, PCOverflow, PC, 32'd1, 1'b0);

    assign address_imem = PC;

    // Decode
    wire [31:0] decodeIR, decodePC, decodeIRIn;
    wire [4:0] rs1, rs2;
    wire [1:0] decodeInsType;

    assign decodeIRIn = branch ? 32'b0 : q_imem;
    FetchDecode fetchDecodeLatch(decodeIR, decodePC, decodeIRIn, PCPlusOne, ~clock, stallFD, reset);
    DecodeControl decodeController(decodeInsType, decodeIR);

    mux_4_5 select_rs1(rs1, decodeInsType, decodeIR[21:17], decodeIR[21:17], 5'b0, decodeIR[26:22]);
    mux_4_5 select_rs2(rs2, decodeInsType, decodeIR[16:12], decodeIR[26:22], 5'b0, 5'b0);

    assign ctrl_readRegA = rs1;
    assign ctrl_readRegB = rs2;

    // Execute
    wire [31:0] executeIR, executeA, executeB, executePC, aluBInput, executeImmediate, aluOut, executeIRIn, executeT;
    wire [4:0] aluOpCode, shiftAmt, executeOpcode;
    wire [1:0] executeInsType;
    wire aluBSelector, aluOverflow, aluNEQ, aluLT;

    assign executeT[26:0] = executeIR[26:0];
    assign executeT[31:27] = 5'b0;
    assign executeOpcode = executeIR[31:27];
    assign executeIRIn = interlockStall || branch ? 32'b0 : decodeIR;
    DecodeExecute decodeExecuteLatch(executeIR, executeA, executeB, executePC, executeIRIn, data_readRegA, data_readRegB, decodePC, ~clock, stallDX, reset);
    ExecuteControl executeController(executeInsType, aluOpCode, shiftAmt, aluBSelector, startMult, startDiv, executeIR, clock, multDivDone);

    SignExtender_16 signExtenderExecuteImm(executeImmediate, executeIR[16:0]);

    wire [31:0] aluAInput, aluB;
    assign aluAInput = ALU_A_bypass[1] ? executeA : ALU_A_bypass[0] ? data_writeReg : memoryO;
    assign aluB = ALU_B_bypass[1] ? executeB : ALU_B_bypass[0] ? data_writeReg : memoryO;
    assign aluBInput = aluBSelector ? executeImmediate : aluB;

    alu mainALU(aluAInput, aluBInput, aluOpCode, shiftAmt, aluOut, aluNEQ, aluLT, aluOverflow);

    wire [31:0] memoryIn, multDivResult;
    wire startMult, startDiv, multDivError, multDivDone;
    multdiv mainMultDiv(aluAInput, aluB, startMult, startDiv, clock, multDivResult, multDivError, multDivDone);

    // assign memoryIn = multdivResult, aluResult, or PC + 1 depending on instruction;
    assign memoryIn = (executeInsType == 2'b00 && aluOpCode[4:1] == 4'b0011) ? multDivResult : executeOpcode == 5'b00011 ? executePC : aluOut;

    // Memory
    wire [31:0] memoryIR, memoryO, memoryB;
    wire [1:0] memoryInsType;
    ExecuteMemory executeMemoryLatch(memoryIR, memoryO, memoryB, executeIR, memoryIn, executeB, ~clock, stallXM, reset);
    MemoryControl memoryController(memoryInsType, wren, memoryIR);
    assign address_dmem = memoryO;
    assign data = dmem_bypass ? data_writeReg : memoryB;

    // Writeback
    wire [31:0] writebackIR, writebackO, writebackD, writebackData;
    wire [4:0] rd, j1WriteReg;
    wire [1:0] writebackInsType;
    wire writebackDataSelector;

    MemoryWriteback memoryWritebackLatch(writebackIR, writebackO, writebackD, memoryIR, memoryO, q_dmem, ~clock, stallMW, reset);
    WritebackControl writebackController(writebackInsType, writebackDataSelector, ctrl_writeEnable, writebackIR);

    assign j1WriteReg = writebackIR[31:27] == 5'b00011 ? 5'd31 : 5'd30;
    mux_4_5 select_rd(rd, writebackInsType, writebackIR[26:22], writebackIR[26:22], j1WriteReg, writebackIR[26:22]);
    assign data_writeReg = writebackDataSelector ? writebackD : writebackO;
    assign ctrl_writeReg = rd;

	/* END CODE */

endmodule
