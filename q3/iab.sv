module iab #(parameter input_width = 64,
               parameter output_width = 8)
               (input logic clk,
                input logic rst_n,
                input logic readyA,
                input logic gntIAB,
                input logic acceptedI,
                input logic [input_width-1:0] dataA,
                output logic [output_width-1:0] dataOut,
                output logic acceptedA,
                output logic reqIAB);

// Your code goes here

endmodule
