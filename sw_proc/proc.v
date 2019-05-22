module proc (
	input [8:0] DIN,
	input Resetn, Clock, Run,
	output Done, W,
	output [8:0] BusWires,
	output [8:0] ADDR, DOUT);


	// register outputs
	(* keep *) wire [8:0] R0, R1, R2, R3, R4, R5, R6, R7;
	(* keep *) wire [8:0] G;
	wire [8:0] IR;
	(* keep *) wire [8:0] A;

	// register control
	(* keep *)  wire [7:0] Rin;
	wire [0:0] Gin;
	wire [0:0] Ain;
	wire [0:0] IRin;
	wire [0:0] ADDRin;
	wire [0:0] DOUTin;
	wire [0:0] W_D;
	wire [0:0] incr_pc;

	// multiplexer control
	wire [0:0] Gout;
	wire [0:0] DINout;
	wire [7:0] Rout;

	// alu
	wire [0:0] AddSub;
	wire [8:0] AddSubS;
	add_sub_unit #(9) addsub(
		.add_sub(AddSub),
		.A(A),
		.B(BusWires),
		.S(AddSubS),
		.overflow(),
		.carry());

	regn reg_0 (BusWires, Rin[7], Clock, R0);
	regn reg_1 (BusWires, Rin[6], Clock, R1);
	regn reg_2 (BusWires, Rin[5], Clock, R2);
	regn reg_3 (BusWires, Rin[3], Clock, R3);
	regn reg_4 (BusWires, Rin[4], Clock, R4);
	regn reg_5 (BusWires, Rin[2], Clock, R5);
	regn reg_6 (BusWires, Rin[1], Clock, R6);
	regn reg_G (AddSubS, Gin, Clock, G);
	regn reg_IR (DIN, IRin, Clock, IR);
	regn reg_A (BusWires, Ain, Clock, A);
	regn reg_ADDR (BusWires, ADDRin, Clock, ADDR);
	regn reg_DOUT (BusWires, DOUTin, Clock, DOUT);
	regn reg_W (W_D, 1, Clock, W);

	counter_9_bits_on_sload pc(BusWires, Rin[0], incr_pc, Clock, R7);

	// control unit
	cu_FSM cu(
		//inputs
		.Clock(Clock),
		.Run(Run),
		.Resetn(Resetn),
		.IR(IR),
		//outputs
		.Done(Done),
		.Rin(Rin),
		.Rout(Rout),
		.IRin(IRin),
		.Gin(Gin),
		.Gout(Gout),
		.Ain(Ain),
		.DINout(DINout),
		.AddSub(AddSub),
		.incr_pc(incr_pc));

	proc_multiplexers multiplexers(
		// controls
		.Gout(Gout),
		.DINout(DINout),
		.Rout(Rout),

		// inputs
		.G(G),
		.DIN(DIN),
		.R0(R0), .R1(R1), .R2(R2), .R3(R3), .R4(R4), .R5(R5), .R6(R6), .R7(R7),

		// output
		.Bus(BusWires)
	);
endmodule
