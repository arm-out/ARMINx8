// combinational -- no clock
// sample -- change as desired
import Definitions::*;

module alu(
  
    input[7:0] InA, InB,	 // 8-bit wide data path
    input[4:0] OP,    // ALU instructions
    output logic[7:0] Out

);

op_code op;

	always_comb begin 
		Out = InA;

		case(op)
			ADD: Out = InA + InB;
			SUB: Out = InA - InB;
			AND: Out = InA & InB;
			XOR: Out = InA ^ InB;
			OR: Out = InA | InB;
			NOT: Out = ~InA;
			RXOR: Out = ^InA;
			LSL: Out = InA << 1;
			LSR: Out = InA >> 1;
			INC: Out = InA + 1;
		endcase
	end

	always_comb op = op_code'(OP);

	// assign Zero   = ~|Out;                  
	// assign Parity = ^Out;                  
	// assign Odd    = Out[0];   
   
endmodule