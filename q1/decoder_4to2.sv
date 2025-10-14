module decoder_4to2 #(
    parameter input_WIDTH = 16)(
    input logic [input_WIDTH-1:0] a_in, b_in,
    input logic [8:0] inverse,
    input logic [1:0] sel,
    output logic [input_WIDTH-1:0] out1, out2
    );
always_comb begin
    out1 = '0;
    out2 = '0;
    case(sel)
        2'b00 : begin
            out1 = a_in;
            out2 = b_in;
        end
        2'b01 : begin
            out1 = a_in;
            out2 = {{input_WIDTH-9{1'b0}}, inverse};
        end
        2'b10 : begin
            out1 = b_in;
            out2 = {{input_WIDTH-9{1'b0}}, inverse};
        end
        default : ;
    endcase
end

endmodule
