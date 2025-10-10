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
