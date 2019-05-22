 module processor_with_ROM (
	input Resetn, PClock, MClock, Run,
	output Done,
	output [8:0] BusWires);
	
	wire [4:0] counter_addr;
	wire [8:0] mem_q;
	
	
	counter_N_bits #(5) counter(
		.clk(MClock),
		.enable(1'b1),
		.areset(Resetn),
		.Q(counter_addr)
	);
	
	inst_mem mem(
		.address(counter_addr),
		.clock(MClock),
		.q(mem_q));
	
	proc cpu(
		.DIN(mem_q),
		.Resetn(Resetn),
		.Clock(PClock),
		.Run(Run),
		.Done(Done),
		.BusWires(BusWires));
	
endmodule
