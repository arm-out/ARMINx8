// lookup table
// deep 
// 9 bits wide; as deep as you wish
module instr_ROM #(parameter D=12)(
	input        [D-1:0] PrgCtr,    // prog_ctr	  address pointer
	output logic [  8:0] InstOut	// mach_code	  instruction
	);

	logic[8:0] core[2**D];

	initial	begin					// load the program
		$readmemb("../bin/test.txt",core);
	end						    

	always_comb  InstOut = core[PrgCtr];
endmodule


/*
sample mach_code.txt:

001111110		 // ADD r0 r1 r0
001100110
001111010
111011110
101111110
001101110
001000010
111011110
*/