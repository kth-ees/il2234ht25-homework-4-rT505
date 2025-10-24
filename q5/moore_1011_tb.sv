module moore_1011_tb ();

	logic clk;
	logic rst_n;
	logic j;
	logic w;

	moore_1011 dut (
		.clk(clk),
		.rst_n(rst_n),
		.j(j),
		.w(w)
	);

    property seq_1011;
        @(posedge clk)
        disable iff (!rst_n)
        w |-> ($past(j,4) && $past(!j,3) && $past(j,2) && $past(j,1));
    endproperty

    property duration_of_w;
        @(posedge clk)
        disable iff (!rst_n)
		$rose(w) |-> ##1 !w;
    endproperty

    assert property (seq_1011)
        else $error("Sequence 1011 did not occure!");

    assert property (duration_of_w)
        else $error("Duration of w exceeded 1 clk!");

	always #5 clk = ~clk;

	initial begin
		rst_n = 1'b0;
		clk = 1'b0;
		j = 1'b0;

		#12;
		rst_n = 1'b1;

		#10; j = 1'b1;
		#10; j = 1'b0;
		#10; j = 1'b1;
		#10; j = 1'b0;
		#10; j = 1'b1;
		#10; j = 1'b1;
		#10; j = 1'b0;
		#10; j = 1'b1;
		#10; j = 1'b1;
        

		#20 $stop;
	end

endmodule

