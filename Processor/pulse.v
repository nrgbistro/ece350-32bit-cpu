module Pulse(
    output pulse,
    input clock, enable, operationDone);

    wire disabled;

    assign pulse = ~disabled & enable & ~operationDone;
    dffe_ref disabler(disabled, 1'b1, ~clock, enable, operationDone);
endmodule
