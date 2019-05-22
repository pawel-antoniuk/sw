module sw_proc(
	input [8:0] SW,
	input [2:0] KEY,
	output [9:0] LEDR
);
	proc p(
		.DIN(SW), 
		.Resetn(KEY[2]), 
		.Clock(KEY[1]), 
		.Run(KEY[0]),
		.Done(LEDR[9]), 
		.BusWires(LEDR[8:0]));
endmodule
 