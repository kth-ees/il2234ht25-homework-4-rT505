module imc      #(parameter input_WIDTH = 16,
                  parameter output_WIDTH = 16)
                (input logic clk,
                input logic rst_n,
                input logic start,
                input logic [input_WIDTH-1:0] aIn, 
                input logic [input_WIDTH-1:0] bIn,
                input logic [input_WIDTH-1:0] cIn,
                input logic [input_WIDTH-1:0] dIn,
                output logic ready,
                output logic [output_WIDTH-1:0] aOut,
                output logic [output_WIDTH-1:0] bOut,
                output logic [output_WIDTH-1:0] cOut,
                output logic [output_WIDTH-1:0] dOut,
                output logic aOut_sign,
                output logic bOut_sign,
                output logic cOut_sign,
                output logic dOut_sign
               );
// Your code goes here
endmodule