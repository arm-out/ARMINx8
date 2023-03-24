module PC_LUT #(parameter D=12)(
	input        [  5:0] Addr,
	output logic [D-1:0] Target
	);

	always_comb begin
		Target = 'b0;
		case(Addr)
			'b000001: Target = 39;
			'b000010: Target = 4;
  		endcase
	end
endmodule

/*

	   pc = 4    0000_0000_0100	  4
				 1111_1111_1111	 -1

				 0000_0000_0011   3

				 (a+b)%(2**12)


   	  1111_1111_1011      -5
	  0000_0001_0100     +20
	  1111_1111_1111      -1
	  0000_0000_0000     + 0


  */
