`timescale 1 ns / 100 ps
module comparator_2_tb;
    wire [7:0] a, b;
    wire GT_in, EQ_in;
    wire GT, EQ;

    comparator_8 comp(GT, EQ, GT_in, EQ_in, a, b);

	integer i;
	assign a = i[3:0];
	assign b = i[7:4];
	assign EQ_in = 1;
	assign GT_in = 0;

    initial begin
		for(i = 0; i < 256; i = i + 1) begin
			#50;
			$display("a = %d, b = %d LT = %b, EQ = %b", a, b, (~GT & ~EQ), EQ);
		end
    end

endmodule
