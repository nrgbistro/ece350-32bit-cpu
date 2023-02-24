module resetDetection(
    output rst,
    input div, mult, clock);

    assign rst = ~clock & (div | mult);

endmodule
