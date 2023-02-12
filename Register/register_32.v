    module register_32(
        output [31:0] out,
        input [31:0] data,
        input clock, enable, reset);

        dffe_ref dffe_reg[31:0] (out, data, clock, enable, reset);


    endmodule
