module ClockDivider (output clockOut, input clock, input[31:0] countLim);

    reg[32:0] count = 0;
    reg clockReg = 0;

    always @(posedge clock) begin
        if (count < countLim) begin
            count <= count + 1;
        end else begin
            count <= 0;
            clockReg <= ~clockReg;
        end
    end

    assign clockOut = clockReg;

endmodule
