`timescale 1 ns / 100 ps
module shift_tb;
    wire [31:0] a, out;
    wire shift;

    shift_right_16 shifter(out, shift, a);

    integer i;
    assign a[31] = i[4];
    assign a[31:0] = 32'b1;
    assign shift = 1'b1;

    initial begin
      for(i = 0; i < 32; i = i + 1) begin
        #20;
        $display("in = %b, out = %b", a, out);
      end
    end

    initial begin
        $dumpfile("shift_tb.vcd");
        $dumpvars(0, shift_tb);
    end

endmodule
