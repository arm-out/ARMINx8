// program counter
// supports both relative and absolute jumps
// use either or both, as desired
module PC #(parameter D=12)(
  	input				Reset,					// synchronous reset
        				Clk,
        				BranchAbs,				// abs. jump enable
  	input       [D-1:0] Target,					// how far/where to jump
  	output logic[D-1:0] PrgCtr
);

  always_ff @(posedge Clk)
    if(Reset)
	  PrgCtr <= '0;
    else if(BranchAbs)
	  PrgCtr <= Target;
	else
	  PrgCtr <= PrgCtr + 'b1;

endmodule