module add_sub_unit #(parameter N)
(
	input add_sub,
	input [N-1:0] A, B,
	output reg [N-1:0] S,
	output reg overflow, carry
);

	always @(*)
	begin
		if	(add_sub)
		begin
			{overflow, S} <= A - B;
			carry <= carry;
		end
		else 
		begin
			{carry, S} <= A + B;
			overflow <= overflow;
		end
	end

endmodule
