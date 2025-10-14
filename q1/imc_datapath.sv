module imc_datapath #(
    parameter input_WIDTH = 16,
    parameter output_WIDTH = 16)(
    input logic clk,
    input logic rst_n,
    input logic [input_WIDTH-1:0] aIn, 
    input logic [input_WIDTH-1:0] bIn,
    input logic [input_WIDTH-1:0] cIn,
    input logic [input_WIDTH-1:0] dIn,
    input logic [1:0] sel_multiplier,
    input logic [1:0] sel_decoder,
    input logic start,
    input logic en_decoder_2to1,
    output logic [output_WIDTH-1:0] aOut,
    output logic [output_WIDTH-1:0] bOut,
    output logic [output_WIDTH-1:0] cOut,
    output logic [output_WIDTH-1:0] dOut,
    output logic aOut_sign,
    output logic bOut_sign,
    output logic cOut_sign,
    output logic dOut_sign,
    output logic ready
    );


logic signed [input_WIDTH-1:0] ad_product, bc_product;
logic signed [input_WIDTH-1:0] negative_b, negative_c;
logic signed [input_WIDTH-1:0] denominator;
logic [input_WIDTH-1:0] denominator_for_lut;
logic [8:0] inverse;
logic signed [input_WIDTH-1:0] decoder_1_out1, decoder_1_out2;
logic signed [input_WIDTH-1:0] decoder_2_out1, decoder_2_out2;
logic [output_WIDTH-1:0] reg_aOut, reg_bOut, reg_cOut, reg_dOut;
logic counter;
logic [input_WIDTH-1:0] decoded_bIn, decoded_cIn;


multiplier multiplies_ad (.a_in(decoder_1_out1), .b_in(decoder_1_out2), .sel(sel_multiplier), .out1(ad_product), .out2(aOut), .out3(bOut));
multiplier multiplies_cd (.a_in(decoder_2_out1), .b_in(decoder_2_out2), .sel(sel_multiplier), .out1(bc_product), .out2(cOut), .out3(dOut));

adder add_denominator (.a_in(ad_product), .b_in(bc_product), .result(denominator));

converter converter (.in(denominator), .out(denominator_for_lut));

reciprocal reciprocal (.x(denominator_for_lut), .y(inverse));

decoder_4to2 decoder_1 (.a_in(aIn), .b_in(dIn), .inverse(inverse), .sel(sel_decoder), .out1(decoder_1_out1), .out2(decoder_1_out2));
decoder_4to2 decoder_2 (.a_in(decoded_bIn), .b_in(decoded_cIn), .inverse(inverse), .sel(sel_decoder), .out1(decoder_2_out1), .out2(decoder_2_out2));

decoder_2to1 decode_bIn (.in(bIn), .en(en_decoder_2to1), .out(decoded_bIn));
decoder_2to1 decode_cIn (.in(cIn), .en(en_decoder_2to1), .out(decoded_cIn));


always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        counter <= 1'b0;
    else if(start)
        counter <= 1'b0;
    else 
        counter <= 1'b1; 
    
end
assign ready = counter;

assign aOut_sign = aOut[output_WIDTH-1];
assign bOut_sign = bOut[output_WIDTH-1];
assign cOut_sign = cOut[output_WIDTH-1];
assign dOut_sign = dOut[output_WIDTH-1];


always_ff @(posedge clk) begin
    $display("Time: %0t | ad_product=%0d | bc_product=%0d | denominator=%0d | denominator_for_lut=%0d | inverse=%h | sel_decoder=%0d | 
    sel_multiplier=%0d | decoder_1_out1=%0d | decoder_1_out2=%0d | decoder_2_out1=%0d | decoder_2_out2=%0d | aOut=%h | cOut= %h | bOut= %h | dOut= %h",
        $time, ad_product, bc_product, denominator, denominator_for_lut, inverse, sel_decoder, sel_multiplier, 
        decoder_1_out1, decoder_1_out2, decoder_2_out1, decoder_2_out2, aOut, cOut, bOut, dOut);

    $display("");
end
endmodule
