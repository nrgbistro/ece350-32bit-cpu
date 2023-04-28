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
    data_readRegB,                   // I: Data from port B of RegFile

    buttons,
    segment,
    segmentMask);

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

    input [2:0] buttons;
    output [6:0] segment;
    output [7:0] segmentMask;

	/* YOUR CODE STARTS HERE */

    wire overflow1, multDivStall, stallPC, stallFD, stallDX, stallXM, stallMW;

    // Timer
    wire [31:0] timer;
    wire timeWriteEnable;
    Timer timerModule(timer, timeWriteEnable, clock, reset);

    // IO
    wire [31:0] swCode;
    wire swStall;
    ButtonHandler btnHandler(swCode, buttons);

    assign swStall = swCode != 32'd0;

    // Seven Segment
    SegmentWrapper segmentWrapper(segmentMask, segment, executeA, clock, reset, executeIR[31:27] == 5'b10001, executeImmediate[0]);

    // Stall
    wire interlockStall;
    MultDivStall multDivStallModule(multDivStall, executeIR, multDivDone);
    assign stallPC = multDivStall || interlockStall || swStall || timeWriteEnable;
    assign stallFD = multDivStall || interlockStall || swStall || timeWriteEnable;
    assign stallDX = multDivStall || swStall || timeWriteEnable;
    assign stallXM = multDivStall || swStall || timeWriteEnable;
    assign stallMW = multDivStall || swStall || timeWriteEnable;

    // Interlock
    Interlock interlock(interlockStall, decodeIR, executeIR);

    // Bypassing
    wire [1:0] ALU_A_bypass, ALU_B_bypass;
    wire dmem_bypass;
    Bypass bypass(ALU_A_bypass, ALU_B_bypass, dmem_bypass, executeIR, memoryIR, writebackIR, memoryErrorOut, writebackErrorOut);

    // Fetch
    wire [31:0] PC, nextPC, PCPlusOne;
    wire branch, PCOverflow;

    ProgramCounter programCounter(PC, nextPC, ~clock, stallPC, reset);
    PCControl programCountController(nextPC, branch, PCPlusOne, executePC, executeT, aluAInput, executeImmediate, executeOpcode, aluNEQ, aluLT);
    adder_32 PCAdder(PCPlusOne, PCOverflow, PC, 32'd1, 1'b0);

    assign address_imem = PC;

    // Decode
    wire [31:0] decodeIR, decodePC, decodeIRIn, decodeT;
    wire [1:0] decodeInsType;

    assign decodeIRIn = branch ? 32'b0 : q_imem;
    FetchDecode fetchDecodeLatch(decodeIR, decodePC, decodeIRIn, PCPlusOne, ~clock, stallFD, reset);
    DecodeControl decodeController(decodeInsType, decodeT, ctrl_readRegA, ctrl_readRegB, decodeIR);

    // Execute
    wire [31:0] executeIR, executeA, executeB, executePC, aluBInput, executeImmediate, aluOut, executeIRIn, executeT;
    wire [4:0] aluOpCode, shiftAmt, executeOpcode;
    wire [1:0] executeInsType;
    wire aluBSelector0, aluBSelector1, aluOverflow, aluNEQ, aluLT;

    assign executeT[26:0] = executeIR[26:0];
    assign executeT[31:27] = 5'b0;
    assign executeOpcode = executeIR[31:27];
    assign executeIRIn = interlockStall || branch ? 32'b0 : decodeIR;
    DecodeExecute decodeExecuteLatch(executeIR, executeA, executeB, executePC, executeIRIn, data_readRegA, data_readRegB, decodePC, ~clock, stallDX, reset);
    ExecuteControl executeController(executeInsType, aluOpCode, shiftAmt, aluBSelector0, aluBSelector1, startMult, startDiv, executeIR, clock, multDivDone);

    SignExtender_16 signExtenderExecuteImm(executeImmediate, executeIR[16:0]);

    wire [31:0] aluAInput, aluB;
    assign aluAInput = ALU_A_bypass[1] ? executeA : ALU_A_bypass[0] ? data_writeReg : memoryO;
    assign aluB = ALU_B_bypass[1] ? executeB : ALU_B_bypass[0] ? data_writeReg : memoryO;
    assign aluBInput = aluBSelector1 ? executeT : aluBSelector0 ? executeImmediate : aluB;

    alu mainALU(aluAInput, aluBInput, aluOpCode, shiftAmt, aluOut, aluNEQ, aluLT, aluOverflow);

    wire [31:0] memoryIn, multDivResult;
    wire startMult, startDiv, multDivError, multDivDone;
    multdiv mainMultDiv(aluAInput, aluB, startMult, startDiv, clock, multDivResult, multDivError, multDivDone);

    // Memory
    wire [31:0] memoryIR, memoryO, memoryB;
    wire memoryErrorIn, memoryErrorOut;
    wire [1:0] memoryInsType;
    ExecuteMemory executeMemoryLatch(memoryIR, memoryO, memoryB, memoryErrorOut, executeIR, memoryIn, executeB, memoryErrorIn, ~clock, stallXM, reset);
    MemoryControl memoryController(memoryInsType, wren, memoryIR);
    assign address_dmem = memoryO;
    assign data = dmem_bypass ? data_writeReg : memoryB;
    assign memoryErrorIn = (multDivError && multDivDone) | aluOverflow;

    // memoryIn = multdivResult, aluResult, PC + 1, or error code depending on instruction;
    assign memoryIn = memoryErrorIn ? exceptionData : (executeInsType == 2'b00 && aluOpCode[4:1] == 4'b0011) ? multDivResult : executeOpcode == 5'b00011 ? executePC : aluOut;

    wire [31:0] exceptionData;
    Exception exceptionLogic(exceptionData, executeIR, memoryErrorIn);

    // Writeback
    wire [31:0] writebackIR, writebackO, writebackD, writebackData;
    wire [4:0] rd, j1WriteReg;
    wire [1:0] writebackInsType;
    wire writebackDataSelector, writebackErrorOut;

    MemoryWriteback memoryWritebackLatch(writebackIR, writebackO, writebackD, writebackErrorOut, memoryIR, memoryO, q_dmem, memoryErrorOut, ~clock, stallMW, reset);
    WritebackControl writebackController(writebackInsType, writebackDataSelector, ctrl_writeEnable, writebackIR, swStall, timeWriteEnable);

    assign j1WriteReg = writebackIR[31:27] == 5'b00011 ? 5'd31 : 5'd30;
    mux_4_5 select_rd(rd, writebackInsType, writebackIR[26:22], writebackIR[26:22], j1WriteReg, writebackIR[26:22]);
    assign data_writeReg = swStall ? swCode : timeWriteEnable ? timer : writebackDataSelector ? writebackD : writebackO;
    assign ctrl_writeReg = swStall ? 5'd25 : timeWriteEnable ? 5'd28 : writebackErrorOut ? 5'd30 : rd;

	/* END CODE */

endmodule
