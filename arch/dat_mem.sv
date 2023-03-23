// 8-bit wide, 256-word (byte) deep memory array
module dat_mem (
	input               Clk,
						Reset,
						WriteEn,
	input       [7:0] Addr, 
	input       [7:0] DataIn,      
	output logic[7:0] DataOut
);

  	logic[7:0] core[256];       // 2-dim array  8 wide  256 deep

// reads are combinational; no enable or clock required
  	assign DataOut = core[Addr];

// writes are sequential (clocked) -- occur on stores or pushes 
  	always_ff @(posedge Clk)
		if(WriteEn)				  // wr_en usually = 0; = 1 		
		core[Addr] <= DataIn; 

endmodule