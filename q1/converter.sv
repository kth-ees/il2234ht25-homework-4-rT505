module converter #(parameter input_WIDTH = 16)(
    input logic [input_WIDTH-1:0] in,
    output logic [input_WIDTH-1:0] out
);
always_comb begin
    case(in[input_WIDTH-1])
        0 : out = in;
        1 : out = (~in + 1);
    endcase
end

endmodule
