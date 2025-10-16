module input_out_wrapper_tb;
  parameter data_width = 16;
  parameter input_WIDTH = 16;
  parameter output_WIDTH = 16;

  logic clk;
  logic rst_n;
  logic dataOnBus;
  logic [data_width-1:0] data;

  logic dataReady;
  logic dataAccept;
  logic inc_counter;
  logic ready;
  logic IMC_done;
  logic start;
  logic [data_width-1:0] dataOuta, dataOutb, dataOutc, dataOutd;
  logic [output_WIDTH-1:0] aOut, bOut, cOut, dOut;


  logic outAvail;
  logic request;
  logic outReady;
  logic grant;
  logic outAccepted;
  logic startTransmit;
  logic [output_WIDTH-1:0] dataOut;

  arbitrer dut_arbitrer (
      .clk(clk),
      .rst_n(rst_n),
      .dataAccept(dataAccept), 
      .dataOnBus(dataOnBus),
      .inc_counter(inc_counter),
      .dataReady(dataReady),
      .request(request)
  );

  input_wrapper #(.data_width(data_width)) dut_input_wrapper (
      .clk(clk),
      .rst_n(rst_n),
      .data(data),
      .dataReady(dataReady),     
      .dataOuta(dataOuta),
      .dataOutb(dataOutb),
      .dataOutc(dataOutc),
      .dataOutd(dataOutd),
      .start(start),
      .ready(ready),
      .inc_counter(inc_counter),
      .dataAccept(dataAccept)    
  );
  imc #(.input_WIDTH(input_WIDTH)) dut_imc (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .aIn(dataOuta), 
        .bIn(dataOutb),
        .cIn(dataOutc),
        .dIn(dataOutd),
        .aOut(aOut),
        .bOut(bOut),
        .cOut(cOut),
        .dOut(dOut)
  );





output_wrapper #(.data_width(output_WIDTH)) dut_output_wrapper (
      .clk(clk),
      .rst_n(rst_n),
      .ready(IMC_done),        
      .startTransmit(startTransmit),
      .grant(grant),
      .outAccepted(outAccepted),
      .dataIna(aOut),
      .dataInb(bOut),
      .dataInc(cOut),
      .dataInd(dOut),
      .dataOut(dataOut),
      .outAvail(outAvail),
      .outReady(outReady)
  );






  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    rst_n = 0;
    dataOnBus = 0;
    data = '0;
    //ready = 0;

    #10;
    rst_n = 1;
    dataOnBus = 1;
    #10; 
    data = 16'h0100;
    #20;
    dataOnBus = 0; 
    #10; 
    dataOnBus = 1;
    #10;
    data = 16'h0200; 
    #20; 
    dataOnBus = 0;
    #10; 
    dataOnBus = 1;
    #10; 
    data = 16'h0200;
    #20; 
    dataOnBus = 0;
    #10; 
    dataOnBus = 1;
    #10;
    data = 16'h0300; 
    #20; 
    #10; dataOnBus = 0;

    #100; ready = 1;
    #40;  ready = 0;

    #50 IMC_done = 1;
    #20 IMC_done = 0;

    // trigger transmit
    #50 startTransmit = 1;
    #10 startTransmit = 0;

    // simulate arbiter grant
    #50 grant = 1;
    #10 grant = 0;

    // simulate output acceptance
    #50 outAccepted = 1;
    #10 outAccepted = 0;
    #100
    $stop;
  end
endmodule
