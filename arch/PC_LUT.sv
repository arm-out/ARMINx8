module PC_LUT #(parameter D=12)(
	input        [  3:0] Addr,
	output logic [D-1:0] Target
	);

	always_comb begin
		Target = 'b0;
		case(Addr)
			'b0001: Target = 45;
			'b0010: Target = 69;
			'b0011: Target = 80;
			'b0100: Target = 91;
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
