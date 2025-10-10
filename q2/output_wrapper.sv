module output_wrapper #(parameter data_width = 16)
                                (input logic clk,
                                 input logic rst_n,
                                 input logic ready,
                                 input logic startTransmit,
                                 input logic grant,
                                 input logic outAccepted,
                                 input logic [data_width-1:0] dataIna,
                                 input logic [data_width-1:0] dataInb,
                                 input logic [data_width-1:0] dataInc,
                                 input logic [data_width-1:0] dataInd,
                                 output logic [data_width-1:0] dataOut,
                                 output logic outAvail,
                                 output logic request,
                                 output logic outReady);
// Your code goes here
endmodule