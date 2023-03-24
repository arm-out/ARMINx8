// cache memory/register file
// default address pointer width = 4, for 16 registers
module reg_file #(parameter pw=4)(
	input             Clk,
	                  Reset,
					  WriteEn,           // write enable
					  Imm,
					  Move,
	input[7:0] 		  DataIn,
	input[5:0]		  ImmediateVal,
	input[pw-1:0] 	  Waddr,		  // write address pointer
					  MoveFrom,
	output logic      Eq,
					  Gt,
					  Lt,
	output logic[7:0] DataOutA, // read data
					  DataOutB,
					  DataOutC,
	output logic[7:0] Reg0Value,
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
					  Reg15Value
	);

  logic[7:0] Registers[2**pw];    // 2-dim array  8 wide  16 deep

// reads are combinational
  assign DataOutA = Registers[0];
  assign DataOutB = Registers[1];
  assign DataOutC = Registers[Waddr];

  assign Reg0Value = Registers[0];
  assign Reg1Value = Registers[1];
  assign Reg2Value = Registers[2];
  assign Reg3Value = Registers[3];
  assign Reg4Value = Registers[4];
  assign Reg5Value = Registers[5];
  assign Reg6Value = Registers[6];
  assign Reg7Value = Registers[7];
  assign Reg8Value = Registers[8];
  assign Reg9Value = Registers[9];
  assign Reg10Value = Registers[10];
  assign Reg11Value = Registers[11];
  assign Reg12Value = Registers[12];
  assign Reg13Value = Registers[13];
  assign Reg14Value = Registers[14];
  assign Reg15Value = Registers[15];

// writes are sequential (clocked)
  	always_ff @(posedge Clk)
		if (Reset) begin
			for(int i=0; i<2**pw; i++)
				Registers[i] <= 8'b00000000;
		end
		else if(WriteEn)	begin
			if (Imm) begin
				Registers[Waddr] = ImmediateVal;
			end
			else if (Move) begin
				Registers[Waddr] = Registers[MoveFrom];
			end
			else begin
				Registers[Waddr] <= DataIn;
			end
		end

	always_comb begin
		Eq = (Registers[0] == Registers[1]);
		Gt = (Registers[0] > Registers[1]);
		Lt = (Registers[0] < Registers[1]);
	end

endmodule
/*
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
	  xxxx_xxxx
*/