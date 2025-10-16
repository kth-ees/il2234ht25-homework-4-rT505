module output_wrapper #(parameter data_width = 16)(
    input logic clk,
    input logic rst_n,
    input logic ready,
    input logic startTransmit,
    input logic grant,
    input logic outAccepted,
    input logic [data_width-1:0] dataIna,
    input logic [data_width-1:0] dataInb,
    input logic [data_width-1:0] dataInc,
    input logic [data_width-1:0] dataInd,
    output logic [data_width-1:0] dataOut,
    output logic outAvail,
    output logic request,
    output logic outReady
);
logic [1:0] counter;
logic [data_width-1:0] dataIn [3:0];

typedef enum logic [2:0] {WaitForIMC, DataFromIMC, OutAvail, Request, Transmit} state;
state p_state, n_state;

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        p_state <= WaitForIMC;
    else 
        p_state <= n_state;
end

always_comb begin
    case(p_state)
      WaitForIMC  : n_state = (ready) ? DataFromIMC : WaitForIMC;
      DataFromIMC : n_state = (&counter) ? OutAvail : DataFromIMC;
      OutAvail    : begin
                    outAvail = 1'b1;
                    n_state = (startTransmit) ? Request : OutAvail;
      end
      Request     : begin
                    request = 1'b1;
                    n_state = (grant) ? Transmit : Request;
      end
      Transmit    : begin
                    outReady = 1;
                    n_state = (&counter) ? WaitForIMC : Transmit;
      end  
      default : n_state = WaitForIMC; 
    endcase
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        counter <= '0;
    else if (p_state == DataFromIMC || p_state == Transmit)
        counter <= counter + 1'b1;
end

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
     for (int i=0; i<4; i++) dataIn[i] <= '0;
    end
    else if (p_state == DataFromIMC)
        case(counter)
            2'b00 : dataIn[counter] <= dataIna; 
            2'b01 : dataIn[counter] <= dataInb;
            2'b10 : dataIn[counter] <= dataInc;
            2'b11 : dataIn[counter] <= dataInd;
        endcase
end

endmodule
