module imc      #(
    parameter input_WIDTH = 16,
    parameter output_WIDTH = 16)(
    input logic clk,
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
logic [1:0] sel_decoder;
logic [1:0] sel_multiplier;
logic en_decoder_2to1;
logic datapath_ready;
logic [output_WIDTH-1:0] datapath_aOut;
logic [output_WIDTH-1:0] datapath_bOut;
logic [output_WIDTH-1:0] datapath_cOut;
logic [output_WIDTH-1:0] datapath_dOut;

imc_datapath datapath (
    .clk(clk),
    .rst_n(rst_n),
    .aIn(aIn),
    .bIn(bIn),
    .cIn(cIn),
    .dIn(dIn),
    .start(start),
    .sel_decoder(sel_decoder),
    .sel_multiplier(sel_multiplier),
    .en_decoder_2to1(en_decoder_2to1),
    .ready(datapath_ready),
    .aOut(datapath_aOut),
    .bOut(datapath_bOut),
    .cOut(datapath_cOut),
    .dOut(datapath_dOut),
    .aOut_sign(aOut_sign),
    .bOut_sign(bOut_sign),
    .cOut_sign(cOut_sign),
    .dOut_sign(dOut_sign)
    );

imc_control controler (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .sel_decoder(sel_decoder),
    .sel_multiplier(sel_multiplier),
    .en_decoder_2to1(en_decoder_2to1),
    .ready(datapath_ready)
);

assign ready = datapath_ready;
assign aOut = datapath_aOut;
assign bOut = datapath_bOut;
assign cOut = datapath_cOut;
assign dOut = datapath_dOut;


endmodule
