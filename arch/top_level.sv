// sample top level design
module top_level(
	input		 Clk,
				 Reset,
	output logic Done				// done flag
	);

	parameter P = 12;            // program counter width
	parameter D = 8;             	// data memory address width

	logic ZeroQ, ParityQ, TapSel, Imm, Move, Eq;

	wire[P-1:0] PrgCtr, 			// program counter
				PCTarg;
	wire [ 8:0] Instruction;   		// 9 bit instruction
    wire [ 7:0] ReadA, ReadB, Rd;  		// reg_file output
    wire [ 7:0] InA, InB, 	   		// ALU operand inputs
                ALUout;       		// ALU result
    wire [ 7:0] RegWriteValue, 		// data in to reg file
                MemWriteValue, 		// data in to data_memory
                MemReadValue;  		// data out from data_memory
    wire [ 5:0] TargSel;			// BLUT target select
    wire        MemWrite,	   		// data_memory write enable
                RegWrite,	   		// reg_file write enable
				MemRead,	   		// data_memory read enable
				InplaceOp,	   		// ALU operation is inplace
                Zero,		   		// ALU output = 0 flag
                Jump,	       		// to program counter: jump
				Parity,		   		// ALU output parity flag
                SC_out,
                BranchEn;	   		// to program counter: branch enable
	wire [3:0]  RegSel,				// reg_file output select
				MoveFrom;
    wire [7:0]  Reg0Value,			// accumulator value,
                Reg1Value,
                Reg2Value,
                Reg3Value,
                Reg4Value,
                Reg5Value,
                Reg6Value,
                Reg7Value,
				Reg8Value,
				Reg9Value,
				Reg10Value,
				Reg11Value,
				Reg12Value,
				Reg13Value,
				Reg14Value,
				Reg15Value;

	logic[15:0] CycleCt; 			// cycle counter

	always @(posedge Clk) begin
		if (Reset) begin
			ZeroQ <= 0;
			ParityQ <= 0;
		end
		else begin
			ZeroQ <= Zero;
			ParityQ <= Parity;
		end
	end

	// Instruction Fetch Stage
	
	PC PC1 (
		.Reset 		(Reset   ),
		.Clk        (Clk	 ),
		.BranchAbs  (BranchEn),
		.Target     (PCTarg  ),
		.PrgCtr		(PrgCtr  )
	);

	PC_LUT BLUT (
		.Addr  	 (TargSel),
		.Target  (PCTarg )
	);   

	instr_ROM IF (
		.PrgCtr   (PrgCtr     ),
		.InstOut  (Instruction)
	);

	// Instruction Decode Stage

	// control decoder
	Control Ctrl (
		.Instruction (Instruction),
		.Eq (Eq),
		.BranchEn	 (BranchEn   ),
		.MemRead     (MemRead    ),
		.MemWrite 	 (MemWrite   ),
		.Imm         (Imm        ),
		.RegWrite    (RegWrite   ),
		.Halt        (Done       ),
		.Inplace    (InplaceOp  ),
		.RegSel      (RegSel     ),
		.Move      (Move       ),
		.MoveFrom  (MoveFrom   ),
		.TargSel     (TargSel    )
	);


	reg_file RF (
		.Clk,
		.Reset,
		.WriteEn      (RegWrite        ),
		.Imm          (Imm             ),
		.Move 	   (Move            ),
		.DataIn       (RegWriteValue   ),
		.ImmediateVal (Instruction[5:0]),
		.Waddr        (RegSel          ),
		.MoveFrom	 (MoveFrom        ),
		.Eq (Eq),
		.DataOutA     (ReadA           ),
		.DataOutB     (ReadB           ),
		.DataOutC	  (Rd              ),
		.Reg0Value,
		.Reg1Value,
		.Reg2Value,
		.Reg3Value,
		.Reg4Value,
		.Reg5Value,
		.Reg6Value,
		.Reg7Value,
		.Reg8Value,
		.Reg9Value,
		.Reg10Value,
		.Reg11Value,
		.Reg12Value,
		.Reg13Value,
		.Reg14Value,
		.Reg15Value
	);

	assign InA = InplaceOp? Rd : ReadA;
	assign InB = ReadB;

	assign RegWriteValue = MemRead? MemReadValue : ALUout;

	alu ALU(
		.InA    (InA),
		.InB    (InB),
		.OP     (Instruction[8:4]),
		.Out    (ALUout)
	);  

	assign MemWriteValue = Rd;

	dat_mem dm1(
		.Addr     (ReadA        ),
		.WriteEn  (MemWrite     ),
		.DataIn   (MemWriteValue),
		.DataOut  (MemReadValue ),
		.Clk      (Clk          ),
		.Reset    (Reset        )
	);

 
endmodule