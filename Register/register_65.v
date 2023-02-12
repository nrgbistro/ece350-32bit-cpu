    module register_65(
        output [64:0] out,
        input [64:0] data,
        input clock, enable, reset);

        dffe_ref dffe_reg[64:0] (out, data, clock, enable, reset);


    endmodule
