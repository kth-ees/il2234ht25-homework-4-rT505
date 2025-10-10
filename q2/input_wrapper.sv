module input_wrapper    #(parameter data_width = 16)
                        (input logic clk,
                         input logic rst_n,
                         input logic [data_width-1:0] data,
                         input logic dataReady,
                         input logic ready,
                         output logic [data_width-1:0] dataOuta,
                         output logic [data_width-1:0] dataOutb,
                         output logic [data_width-1:0] dataOutc,
                         output logic [data_width-1:0] dataOutd,
                         output logic start,
                         output logic dataAccept
                         );

// Your code goes here
endmodule