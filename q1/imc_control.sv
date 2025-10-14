module imc_control (
    input logic clk,
    input logic rst_n,
    input logic start,
    input logic ready,
    output logic [1:0] sel_multiplier,
    output logic [1:0] sel_decoder,
    output logic en_decoder_2to1
    );

typedef enum logic [1:0] {IDLE, CALC_INVERSE, CALC_OUTPUTS_aOut_cOut, CALC_OUTPUTS_bOut_dOut} state;
state p_state, n_state;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        p_state <= IDLE;
        $display("Time %0t | Reset Active -> State = IDLE", $time);
    end else begin
        p_state <= n_state;

        if (p_state !== n_state) begin
            $display("Time %0t | State changed: %s -> %s", 
                $time, p_state.name(), n_state.name());
        end
    end
end

always_comb begin
    case(p_state)
        IDLE         : n_state = (start) ? CALC_INVERSE : IDLE;
        CALC_INVERSE : begin
            sel_decoder = 2'b00;
            sel_multiplier = 1'b00;
            en_decoder_2to1 = 1'b0;
            n_state = (ready) ? CALC_OUTPUTS_aOut_cOut : CALC_INVERSE;
        end
        CALC_OUTPUTS_aOut_cOut : begin
            sel_decoder = 2'b10;
            sel_multiplier = 1'b01;
            en_decoder_2to1 = 1'b1;
            n_state = CALC_OUTPUTS_bOut_dOut;
        end
        CALC_OUTPUTS_bOut_dOut : begin
            sel_decoder = 2'b01;
            sel_multiplier = 2'b10;
            en_decoder_2to1 = 1'b1;
            n_state = IDLE;
        end
    endcase
end

endmodule
