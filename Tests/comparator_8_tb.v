`timescale 1 ns / 100 ps
module comparator_2_tb;
    wire [7:0] a, b;
    wire GT_in, EQ_in;
    wire GT, EQ;

    comparator_8 comp(a, b, GT_in, EQ_in, GT, EQ);

	integer i;
	assign a = i[3:0];
	assign b = i[7:4];
	assign EQ_in = i[8];
	assign GT_in = i[9];

    initial begin
		for(i = 0; i < 512; i = i + 1) begin
			#1;
			$display("a = %d, b = %d, EQ_in = %b, GT_in = %b, GT = %b, EQ = %b", a, b, EQ_in, GT_in, GT, EQ);
		end
    end

endmodule
