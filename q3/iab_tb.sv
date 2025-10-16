module iab_tb;
parameter input_width = 64;
parameter output_width = 8;
logic clk;
logic rst_n;
logic readyA;
logic gntIAB;
logic acceptedI;
logic [input_width-1:0] dataA;
logic [output_width-1:0] dataOut;
logic acceptedA;
logic reqIAB;

initial clk = 1;
always #5 clk = !clk;


initial begin
    rst_n = 0; 
    readyA     = 0;
    gntIAB     = 0;
    acceptedI  = 0;
    dataA      = '0;
    #10;
    rst_n = 1; #10;

    readyA = 1; #10;
    readyA = 0;
    dataA  = 64'h0807060504030201; #50;

    gntIAB = 1; #10;
    gntIAB = 0; #10;

    acceptedI = 1; #10;
    acceptedI = 0; #10;

    acceptedI = 1; #10;
    acceptedI = 0; #10;

    acceptedI = 1; #10;
    acceptedI = 0; #10;

    acceptedI = 1; #10;
    acceptedI = 0; #10;

    acceptedI = 1; #10;
    acceptedI = 0; #10;

    acceptedI = 1; #10;
    acceptedI = 0; #10;

    acceptedI = 1; #10;
    acceptedI = 0; #10;

    acceptedI = 1; #10;
    acceptedI = 0; #10;


    $stop;
end

iab #(
    .input_width (input_width),
    .output_width (output_width)
) dut (
    .clk        (clk),
    .rst_n      (rst_n),
    .readyA     (readyA),
    .gntIAB     (gntIAB),
    .acceptedI  (acceptedI),
    .dataA      (dataA),
    .dataOut    (dataOut),
    .acceptedA  (acceptedA),
    .reqIAB     (reqIAB)
);  

endmodule
