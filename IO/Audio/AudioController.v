module AudioController(
    input        clk, 		// System Clock Input 100 Mhz
    input        micData,	// Microphone Output
    input[3:0]   switches,	// Tone control switches
    output       micClk, 	// Mic clock
    output       chSel,		// Channel select; 0 for rising edge, 1 for falling edge
    output       audioOut);	// PWM signal to the audio jack

	localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

	assign chSel   = 1'b0;  // Collect Mic Data on the rising edge

	// Initialize the frequency array. FREQs[0] = 261
	reg[10:0] FREQs[0:15];
	initial begin
		$readmemh("FREQs.mem", FREQs);
	end

	////////////////////
	// Your Code Here //
	////////////////////
	wire[17:0] counterLimit;
	assign counterLimit = (SYSTEM_FREQ / (2 * FREQs[switches])) - 1;

	// Counter
	reg desiredClk = 0;
	reg[17:0] counter = 0;
	always @(posedge clk) begin
		if (counter < counterLimit) begin
			counter <= counter + 1;
		end
		else begin
			counter <= 0;
			desiredClk <= ~desiredClk;
		end
	end

	wire[17:0] micLimit;
	assign micLimit = (SYSTEM_FREQ / (2 * 32'd1000000)) - 1;

	// Counter
	reg[17:0] micCounter = 0;
	reg micClkReg = 0;
	always @(posedge clk) begin
		if (micCounter < micLimit) begin
			micCounter <= micCounter + 1;
		end
		else begin
			micCounter <= 0;
			micClkReg <= ~micClkReg;
		end
	end
	assign micClk = micClkReg;

	PWMDeserializer mic(clk, 1'b0, micData, micDutyCycle);

	wire[6:0] micDutyCycle, audioDutyCycle, outputDutyCycle;

	assign audioDutyCycle = ~switches[0] && ~switches[1] && ~switches[2] && ~switches[3] ? 7'd0 : (desiredClk ? 7'd100 : 7'd0);

	assign outputDutyCycle = micDutyCycle / 2 + audioDutyCycle / 2;

	PWMSerializer audio(clk, 1'b0, outputDutyCycle, audioOut);


endmodule
