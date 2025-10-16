module arbitrer (
    input logic clk,
    input logic rst_n,
    input logic dataAccept,
    input logic dataOnBus,
    input logic request,
    output logic dataReady,
    output logic inc_counter,
    output logic grant
);


typedef enum logic [1:0 ]{Start, Wait_for_Accept, Wait_for_NotDataOnBus} state;
state p_state, n_state;

always_ff @(posedge clk or negedge rst_n) begin : input_wrapper_state_transfer_logic
    if(!rst_n) begin
        p_state <= Start;
        //$display("Time %0t | Reset Arbiter Active -> State = Start", $time);
    end
    else begin
        p_state <= n_state;
        if (p_state !== n_state) begin
            $display("Time %0t | Arbitrer State changed: %s -> %s", 
                $time, p_state.name(), n_state.name());
        end
    end
end : input_wrapper_state_transfer_logic

always_comb begin
    n_state = p_state;
    case(p_state)
        Start : n_state = (dataOnBus) ? Wait_for_Accept : Start;
        Wait_for_Accept : n_state = (dataAccept) ? Wait_for_NotDataOnBus : Wait_for_Accept;
        Wait_for_NotDataOnBus : n_state = (dataOnBus) ? Wait_for_NotDataOnBus : Start;
    endcase
end

always_ff @(posedge clk) begin
    if(dataAccept) inc_counter <= 1;
    else inc_counter <= 0;
end

always_comb begin
    dataReady = 1'b0;
    case(p_state)
        Start : ;
        Wait_for_Accept : dataReady = 1'b1;
    endcase
end

typedef enum logic {Request, Grant} output_wrapper_state;
output_wrapper_state p_state_outWrapper, n_state_outWrapper;

always_ff @(posedge clk or negedge rst_n) begin : ouput_wrapper_state_transfer_logic
    if(!rst_n)
        p_state_outWrapper <= Request;
    else 
        p_state_outWrapper <= n_state_outWrapper;
end : ouput_wrapper_state_transfer_logic


always_comb begin : ouput_wrapper_state_logic
    grant = 1'b0;
    case(p_state_outWrapper)
        Request : n_state_outWrapper = (request) ? Grant : Request; 
        Grant   : begin
            if(dataAccept) begin
                grant = 1'b1;
                n_state_outWrapper = Request;
            end else 
                n_state_outWrapper = Grant; 
        end
        default : n_state_outWrapper = Request;
    endcase
end : ouput_wrapper_state_logic



endmodule
