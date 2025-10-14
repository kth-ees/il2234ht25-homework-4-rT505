module multiplier #(
    parameter input_WIDTH = 16)(
    input logic [input_WIDTH-1:0] a_in, b_in,
    input logic [1:0] sel,
    output logic [input_WIDTH-1:0] out1, out2, out3
);
logic signed [input_WIDTH-1:0] a, b;
logic signed [(input_WIDTH << 1)-1:0] temp_result;

assign a = {{3{a_in[12]}}, a_in[12:0]};
assign b = {{3{b_in[12]}}, b_in[12:0]};
assign temp_result = a * b;

always_comb begin
    case(sel)
        2'b00 : out1 = temp_result[31:16];
        2'b01 : out2 = temp_result[23:8];
        2'b10 : out3 = temp_result[23:8];
        default : begin
            out1 = '0;
            out2 = '0;
            out3 = '0;
        end
    endcase
end
endmodule
