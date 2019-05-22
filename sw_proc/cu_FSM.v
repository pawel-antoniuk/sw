 module cu_FSM(
	input wire Clock,
	input wire Run,
	input wire Resetn,
	input wire [8:0] IR,
	output reg Done,
	output reg [7:0] Rin,
	output reg [7:0] Rout,
	output reg IRin,
	output reg Gin,
	output reg Gout,
	output reg Ain,
	output reg DINout,
	output reg AddSub
 ); 
 	parameter T0 = 2'b00, T1 = 2'b01, T2 = 2'b10, T3 = 2'b11;
 
 	(* keep *) reg [1:0] Tstep_D;
	(* keep *) reg [1:0] Tstep_Q;
	(* keep *) wire [7:0] Xreg, Yreg;
	(* keep *) wire [2:0] I;
	
	assign I[2:0] = IR[8:6];
	
	dec3to8 decX (IR[5:3], 1'b1, Xreg);
	dec3to8 decY (IR[2:0], 1'b1, Yreg);	
 
	// Zarządzaj tabelą stanów FSM
	always @(Tstep_Q, Run, Done)
	begin
		case (Tstep_Q)
			T0: begin // W tej chwili dane są ładowane do IR
				if (!Run) 
					Tstep_D = T0;
				else 
					Tstep_D = T1;
			end
			T1:
				if(!Done)
					Tstep_D = T2;
				else
					Tstep_D = T0;
			T2:
				if(!Done)
					Tstep_D = T3;
				else
					Tstep_D = T0;
			T3: begin
				Tstep_D = T0;
			end
		endcase
	end
	
	/*
	000 - mv
	001 - mvi
	010 - add
	011 - sub
	*/
	
	// Sterowanie wejściami FSM
	always @(Tstep_Q, I, Xreg, Yreg)
	begin
		IRin   = 1'b0;
		Gin	 = 1'b0;		
		Rin  	 = 8'b00000000;
		Rout   = 8'b00000000;
		Gout	 = 1'b0;
		DINout = 1'b0;
		AddSub = 1'b0;
		Done   = 1'b0;
		Ain 	= 1'b0;
		case (Tstep_Q)
			T0: // zapamiętaj DIN w IR w takcie 0
			begin
				IRin = 1'b1;
				Done = 1'b0;
			end
			T1: // określ sygnały w takcie 1
				case (I)
					3'b000: begin
						Rout = Yreg;
						Rin  = Xreg;
						Done = 1'b1;
					end
					3'b001: begin
						DINout   = 1'b1;
						Rin      = Xreg;
						Done 	   = 1'b1;
					end
					3'b010: begin
						Rout = Xreg;
						Ain = 1'b1;
					end
					3'b011: begin
						Rout = Xreg;
						Ain = 1'b1;
					end
					default: begin
					end
				endcase
			T2: // określ sygnały w takcie 2
				case (I)
					3'b000: begin
					end
					3'b001: begin
					end
					3'b010: begin
						Rout = Yreg;
						Gin = 1'b1;
					end
					3'b011: begin
						Rout 	 = Yreg;
						Gin 	 = 1'b1;
						AddSub = 1'b1;
					end
					default: begin
					end
				endcase
			T3: // określ sygnały w takcie 3
				case (I)
					3'b000: begin
					end
					3'b001: begin
					end
					3'b010: begin
						Gout = 1'b1;
						Rin  = Xreg;
						Done = 1'b1;
					end
					3'b011: begin
						Gout = 1'b1;
						Rin  = Xreg;
						Done = 1'b1;
					end
					default: begin
					end
				endcase
		endcase
	end
	
	// sterowanie przerzutnikami FSM
	always @(posedge Clock, negedge Resetn)
		if (!Resetn)
			Tstep_Q[1:0] = T0;
		else 
			Tstep_Q[1:0] = Tstep_D[1:0];
 
 endmodule
 