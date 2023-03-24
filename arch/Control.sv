// control decoder
module Control (
	input [8:0]  Instruction,
	input		 Eq,
				 Gt,
				 Lt,
	output logic BranchEn,
		 		 MemRead,
				 MemWrite,
				 Imm,
				 RegWrite,
				 Halt,
				 Inplace,
	output logic [3:0] RegSel,
					   Move,
					   MoveFrom,
	output logic [3:0] TargSel
	);

	always_comb begin
	// defaults
		BranchEn 	=   'b0;   // 1: branch (jump)
		MemWrite  =	'b0;   // 1: store to memory
		Imm 	=	'b0;   // 1: immediate  0: second reg file output
		RegWrite  =	'b1;   // 0: for store or no op  1: most other operations 
		MemRead  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
		RegSel 	=	Instruction[3:0];   // 4-bit register selector
		TargSel = 'b0;
		Inplace = 'b0;
		Move = 'b0;
		MoveFrom = 'b0;

		case(Instruction[8:6])    // override defaults with exceptions
			'b010:  begin				
						if (Instruction[5:4] == 'b10) begin    
							RegWrite = 'b1; // load
							MemRead = 'b1;
						end
						else if (Instruction[5:4] == 'b11) begin
							MemWrite = 'b1;    // store
							RegWrite = 'b0;
						end
						else if (Instruction[5:4] == 'b01) begin
							Inplace = 'b1;
						end 
					end
			'b011:  begin						// Set
						Imm = 'b1;
						RegSel = 4'b0000;    
					end
			'b100:  begin						// Move into register
						RegSel = Instruction[1];
						Move = 'b1;
						MoveFrom = Instruction[5:2];
					end
			'b101:  begin						// Move from register
						Move = 'b1;
						RegSel = Instruction[3:0];
						MoveFrom = Instruction[5];
					end
			'b110:  begin						// Branch
						if (!Eq && Instruction[5:4] == 'b00) begin
							BranchEn = 'b1;
							RegWrite = 'b0;
							TargSel = Instruction[5:0];
						end
						else if (Eq && Instruction[5:4] == 'b01) begin
							BranchEn = 'b1;
							RegWrite = 'b0;
							TargSel = Instruction[5:0];
						end
						else if (Gt && Instruction[5:4] == 'b10) begin
							BranchEn = 'b1;
							RegWrite = 'b0;
							TargSel = Instruction[5:0];
						end
						else if (Lt && Instruction[5:4] == 'b11) begin
							BranchEn = 'b1;
							RegWrite = 'b0;
							TargSel = Instruction[5:0];
						end
					end
		endcase

	end

	assign Halt = &Instruction;   // halt if all bits are 1
	
endmodule