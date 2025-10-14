module decoder_2to1 #(parameter input_WIDTH = 16)(
    input logic [input_WIDTH-1:0] in,
    logic en,
    output logic [input_WIDTH-1:0] out
);

always_comb begin
    case(en)
        1'b0 : out = in;
        1'b1 : out = ~in + 1;
    endcase
end

endmodule
