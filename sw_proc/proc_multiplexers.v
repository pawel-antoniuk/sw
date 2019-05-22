module proc_multiplexers(
	// control
	input wire [0:0] Gout,
	input wire [0:0] DINout,
	input wire [7:0] Rout,
	
	// input
	input wire [8:0] G,
	input wire [8:0] DIN,	
	input wire [8:0] R0, R1, R2, R3, R4, R5, R6, R7,
	
	output reg [8:0] Bus
);

	always @(Gout, DINout, Rout)
		casez({Gout, DINout, Rout})
			10'b1_0_00000000: Bus = G;
			10'b0_1_00000000: Bus = DIN;
			10'b0_0_00000001: Bus = R7;
			10'b0_0_00000010: Bus = R6;
			10'b0_0_00000100: Bus = R5;
			10'b0_0_00001000: Bus = R4;
			10'b0_0_00010000: Bus = R3;
			10'b0_0_00100000: Bus = R2;
			10'b0_0_01000000: Bus = R1;
			10'b0_0_10000000: Bus = R0;
			default:				Bus = 9'b000000000;
		endcase

endmodule
