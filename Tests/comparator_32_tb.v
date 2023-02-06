`timescale 1 ns / 100 ps
module comparator_32_tb;
    wire [31:0] a, b;
    wire LT, EQ;

    comparator_32 comp(LT, EQ, a, b);

	integer i;
	assign a = i[3:0];
	assign b = i[7:4];

    initial begin
		for(i = 0; i < 256; i = i + 1) begin
			#50;
			$display("a = %d, b = %d, LT = %b, EQ = %b", a, b, LT, EQ);
		end
    end

endmodule
