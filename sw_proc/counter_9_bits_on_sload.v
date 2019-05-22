module counter_9_bits_on_sload
(
	input [8:0] data,
	input load, enable, clk,
	output reg[8:0] count
);

	always @(posedge clk)
	begin
		if (load)
      count <= data;
		else if (enable)
      count <= count + 1;
		else
      count <= count;
	end

endmodule
