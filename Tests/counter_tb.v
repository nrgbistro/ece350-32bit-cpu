module counter_tb;
    reg clk, reset;
    wire [4:0] out;

    counter c(out, clk, reset);

    initial begin
        reset = 0;
        clk = 0;
    end

    always
        #50 clk = ~clk;

    always @(out) begin
        #5;
        $display("out = %d", out);
        if (out == 31) begin
            $display("Test passed");
            $finish;
        end
    end

    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, counter_tb);
    end

endmodule
