module counter_tb;
    reg clk, reset, start;
    wire [2:0] out;

    counter c(out, clk, reset, start);

    initial begin
        start = 1;
        reset = 0;
        clk = 0;
    end

    always
        #50 clk = ~clk;

    always @(out) begin
        #5;
        $display("out = %d", out);
        if (out == 7) begin
            $display("Test passed");
            $finish;
        end
    end

    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, counter_tb);
    end

endmodule
