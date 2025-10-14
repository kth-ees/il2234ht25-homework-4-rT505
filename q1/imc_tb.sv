module imc_tb;
parameter input_WIDTH = 16;
parameter output_WIDTH = 16;
logic clk;
logic rst_n;
logic start;
logic [input_WIDTH-1:0] aIn; 
logic [input_WIDTH-1:0] bIn;
logic [input_WIDTH-1:0] cIn;
logic [input_WIDTH-1:0] dIn;
logic ready;
logic [output_WIDTH-1:0] aOut;
logic [output_WIDTH-1:0] bOut;
logic [output_WIDTH-1:0] cOut;
logic [output_WIDTH-1:0] dOut;
logic aOut_sign;
logic bOut_sign;
logic cOut_sign;
logic dOut_sign;
logic sel_decoder;
logic sel_multiplier;

initial clk = 1;
always #5 clk = !clk;

initial begin
    rst_n = 0;
    #10;

    rst_n = 1;
    aIn = 16'h0100;
    bIn = 16'h0200;
    cIn = 16'h0300;
    dIn = 16'h0400;
    start = 1;
    #10;
    start = 0;
    #10;
    



end

imc dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .aIn(aIn),
    .bIn(bIn),
    .cIn(cIn),
    .dIn(dIn),
    .ready(ready),
    .aOut(aOut),
    .bOut(bOut),
    .cOut(cOut),
    .dOut(dOut),
    .aOut_sign(aOut_sign),
    .bOut_sign(bOut_sign),
    .cOut_sign(cOut_sign),
    .dOut_sign(dOut_sign)
    );

endmodule
