module PC_LUT #(parameter D=12)(
	input        [  3:0] Addr,
	output logic [D-1:0] Target
	);

	always_comb begin
		Target = 'b0;
		case(Addr)
			'b0000: Target = 2;
			'b0001: Target = 159;
			'b0010: Target = 177;
			'b0011: Target = 181;
			'b0100: Target = 185;
			'b0101: Target = 191;
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
