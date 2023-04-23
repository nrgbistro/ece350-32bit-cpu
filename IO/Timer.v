module Timer(
    output reg [31:0] t,
    output reg pulse,
    input clock, reset);

    reg [31:0] count;

    always @(posedge clock) begin
        pulse <= 0;
        if (reset) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
        if (count >= 25000000) begin
            t <= t + 1;
            count <= 0;
            pulse <= 1;
        end
    end

endmodule
