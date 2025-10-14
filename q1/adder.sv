module adder #(
    parameter input_WIDTH = 16 )(
    input logic [input_WIDTH-1:0] a_in, b_in,
    output logic [input_WIDTH-1:0] result
);

assign result = a_in - b_in;

endmodule
