module iab #(parameter input_width = 64, parameter output_width = 8)(
    input logic clk,
    input logic rst_n,
    input logic readyA,
    input logic gntIAB,
    input logic acceptedI,
    input logic [input_width-1:0] dataA,
    output logic [output_width-1:0] dataOut,
    output logic acceptedA,
    output logic reqIAB,
    output logic readyI
    );
logic [input_width-1:0] input_register;
logic en_64bitRegister;
logic [2:0] counter;
logic [output_width-1:0] mux_output;

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        input_register <= '0;
    else if (en_64bitRegister)
        input_register <= dataA;
end

typedef enum logic [2:0] {WAIT_FOR_A, READ_DATA_FROM_A, WAIT_FOR_BUS, TRANSFER_TO_B, B_RECEIVED} state;
state p_state, n_state;

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        p_state <= WAIT_FOR_A;
        $display("Time=%0t | Reset asserted: p_state <= WAIT_FOR_A", $time);
    end
    else begin
        p_state <= n_state;
        $display("Time=%0t | p_state <= %0s", $time, n_state.name());
    end
end

always_comb begin
    n_state = p_state;
    case(p_state)
        WAIT_FOR_A          : n_state = (readyA) ? READ_DATA_FROM_A : WAIT_FOR_A;
        READ_DATA_FROM_A    : n_state = WAIT_FOR_BUS;
        WAIT_FOR_BUS        : n_state = (gntIAB) ? TRANSFER_TO_B : WAIT_FOR_BUS;
        TRANSFER_TO_B       : n_state = (acceptedI)  ? B_RECEIVED   : 
                                        (&counter)   ? WAIT_FOR_A   : 
                                                       TRANSFER_TO_B;
        B_RECEIVED          : n_state = TRANSFER_TO_B;
    endcase
end

always_comb begin
    en_64bitRegister = 0;
    reqIAB = 0;
    readyI = 0;
    case(p_state)
        READ_DATA_FROM_A : en_64bitRegister = 1;
        WAIT_FOR_BUS  : begin
            acceptedA = 1;
            reqIAB = 1;
        end
        TRANSFER_TO_B : readyI = 1;  
    endcase
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        counter <= '0;
    else begin
        if(p_state == WAIT_FOR_A)
            counter <= '0;
        else if(acceptedI) begin
            dataOut <= mux_output;
            counter <= counter + 1;
        end
    end
end
always_ff @(posedge clk) begin
    $display("Time: %0t | input_register=%h | enable=%0d | counter=%0d",
        $time, input_register, en_64bitRegister, counter);

    $display("");
end

mux8to1 init_mux8to1 ( 
    .dataIn(input_register),
    .sel_mux_output(counter),
    .dataOut(mux_output)
);

endmodule

module mux8to1 #(parameter input_width = 64, parameter output_width = 8)(
    input logic [input_width-1:0] dataIn,
    input logic [2:0] sel_mux_output,
    output logic [output_width-1:0] dataOut
);

always_comb begin
        case (sel_mux_output)
            3'd0: dataOut = dataIn[7:0];
            3'd1: dataOut = dataIn[15:8];
            3'd2: dataOut = dataIn[23:16];
            3'd3: dataOut = dataIn[31:24];
            3'd4: dataOut = dataIn[39:32];
            3'd5: dataOut = dataIn[47:40];
            3'd6: dataOut = dataIn[55:48];
            3'd7: dataOut = dataIn[63:56];
            default: dataOut = '0;
        endcase
    end
endmodule
