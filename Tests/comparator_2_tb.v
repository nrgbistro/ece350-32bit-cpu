`timescale 1 ns / 100 ps
module comparator_2_tb;
    wire [1:0] a, b;
    wire GT_in, EQ_in;
    wire GT, EQ;

    comparator_2 comp(GT, EQ, GT_in, EQ_in, a, b);

	integer i;
	assign a = i[1:0];
	assign b = i[3:2];
	assign GT_in = 0;
	assign EQ_in = 1;

    initial begin
		for(i = 0; i < 16; i = i + 1) begin
			#20;
			$display("a = %d, b = %d, EQ_in = %b, GT_in = %b, GT = %b, EQ = %b", a, b, EQ_in, GT_in, GT, EQ);
		end
    end

endmodule
