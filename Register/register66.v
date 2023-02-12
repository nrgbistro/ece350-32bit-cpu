    module register66(
        output [65:0] out,
        input [65:0] data,
        input clock, enable, reset);

        dffe_ref dffe_reg[65:0] (out, data, clock, enable, reset);


    endmodule
