module HalfClock (output halfClock, input clock);

    reg[1:0] count = 0;
    reg clockReg = 0;
    wire[1:0] countLim;

    assign countLim = 2'd1;

    always @(posedge clock) begin
        if (count < countLim) begin
            count <= count + 1;
        end else begin
            count <= 0;
            clockReg <= ~clockReg;
        end
    end

    assign halfClock = clockReg;

endmodule
