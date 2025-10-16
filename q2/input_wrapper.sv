module input_wrapper    #(parameter data_width = 16)(
    input logic clk,
    input logic rst_n,
    input logic [data_width-1:0] data,
    input logic dataReady,
    input logic ready,
    input logic inc_counter,
    output logic [data_width-1:0] dataOuta,
    output logic [data_width-1:0] dataOutb,
    output logic [data_width-1:0] dataOutc,
    output logic [data_width-1:0] dataOutd,
    output logic start,
    output logic dataAccept
);
logic [data_width-1:0] dataIn [3:0];

logic [2:0] counter;

typedef enum logic [1:0] {Wait, Accept, SendToIMC} state;
state p_state, n_state;

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        p_state <= Wait;
        $display("Time=%0t | Reset asserted: p_state <= Wait", $time);
    end
    else begin
        p_state <= n_state;
        $display("Time=%0t | p_state <= %0s", $time, n_state.name());
    end
end

always_comb begin
    n_state = p_state;
    start = 1'b0;
    case(p_state)
        Wait      : begin
            if(counter[2]) n_state = SendToIMC;
            else if (dataReady) n_state = Accept;
            else n_state = Wait;
        end
        Accept    : n_state = Wait;  
        SendToIMC : begin
            if(ready) begin
                dataOuta = dataIn[0];
                dataOutb = dataIn[1];
                dataOutc = dataIn[2];
                dataOutd = dataIn[3];
                start = 1'b1;
                n_state = Wait; 
            end else 
                n_state = SendToIMC;
        end
    endcase
end

always_comb begin
    dataAccept = 1'b0;
    case(p_state)
        Accept : dataAccept = 1'b1;
    endcase
end


always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        counter <= '0;
        dataIn[0] <= '0;
        dataIn[1] <= '0;
        dataIn[2] <= '0;
        dataIn[3] <= '0;
    end else if (inc_counter) begin
        dataIn[counter] <= data;   
        counter <= (counter + 1) /*% 4*/;
    end else if(p_state == SendToIMC)
        counter <= '0;
end


always_ff @(posedge clk) begin
    $display("Time: %0t | counter=%0d | dataIn[0]=%h | dataIn[1]=%h | dataIn[2]=%h | dataIn[3]=%h",
        $time, counter, dataIn[0], dataIn[1], dataIn[2], dataIn[3]);

    $display("");
end

endmodule
