`timescale 1 ns / 100 ps
module shift_left_1_tb;
    wire [31:0] a, out;
    wire shift;

    shift_left_1 shifter(out, shift, a);

	integer i;
	assign a = i[3:0];
    assign shift = i[4];

    initial begin
		for(i = 0; i < 32; i = i + 1) begin
			#20;
			$display("shift: %b, in = %b, out = %b", shift, a, out);
		end
    end

endmodule
