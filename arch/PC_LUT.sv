module PC_LUT #(parameter prog=3)(
	input        [  3:0] Addr,
	output logic [11:0] Target
	);

	always_comb begin
		Target = 'b0;
		if (prog == 3)	begin
			case(Addr)
				'b0000: Target = 7;
				'b0001: Target = 17;
				'b0010: Target = 31;
				'b0011: Target = 45;
				'b0100: Target = 59;
				'b0101: Target = 68;
				'b0110: Target = 116;
				'b0111: Target = 117;
				'b1000: Target = 127;
				'b1001: Target = 147;
				'b1010: Target = 166;
				'b1011: Target = 178;
				'b1100: Target = 190;
				'b1101: Target = 202;
			endcase
		end
		else if (prog == 2 | prog == 1) begin
			case(Addr)
				'b0000: Target = 2;
				'b0001: Target = 159;
				'b0010: Target = 177;
				'b0011: Target = 181;
				'b0100: Target = 185;
				'b0101: Target = 191;
			endcase
		end
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
