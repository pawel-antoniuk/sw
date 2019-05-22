module counter_N_bits #(parameter N) (
	input clk, enable, areset,
	output reg[N-1:0] Q
);

	always @(posedge clk, negedge areset)
	begin
		if (!areset)		Q <= { N{1'b0} };
		else if (enable)	Q <= Q + 1;
		else					Q <= Q;
	end

endmodule
