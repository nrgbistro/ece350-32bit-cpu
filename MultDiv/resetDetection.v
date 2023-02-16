module resetDetection(
    output rst,
    input div, mult, clock);

    assign rst = div | mult;

endmodule
