module quicktest_tb();

bit clk, reset;
wire done;
logic error[10];

top_level dut(
  .Clk (clk),
  .Reset (reset),
  .Done (done));


always begin
  #5 clk = 1;
  #5 clk = 0;
end

initial begin
  force dut.dm1.core[0] = 8'b11110000;
  force dut.dm1.core[1] = 8'b11001100;
  #0 release  dut.dm1.core[0];
  release  dut.dm1.core[1];
  #10 reset = 1;
  #10 reset = 0;
  #10 wait(done);
  #10 error[0] = (8'b11110000 + 8'b11001100) != dut.dm1.core[2];
  #10 error[1] = (8'b11110000 - 8'b11001100) != dut.dm1.core[3];
  #10 error[2] = (8'b11110000 & 8'b11001100) != dut.dm1.core[4];
  #10 error[3] = (8'b11110000 ^ 8'b11001100) != dut.dm1.core[5];
  #10 error[4] = (8'b11110000 | 8'b11001100) != dut.dm1.core[6];
  #10 error[5] = (~8'b11110000) != dut.dm1.core[7];
  #10 error[6] = (^8'b11110000) != dut.dm1.core[8];
  #10 error[9] = (8'b11110000 + 1) != dut.dm1.core[11];
  #10 $display(error[0]);
  #10 $display(error[1]);
  #10 $display(error[2]);
  #10 $display(error[3]);
  #10 $display(error[4]);
  #10 $display(error[5]);
  #10 $display(error[6]);
  #10 $display(error[7]);
  #10 $display(error[8]);
  #10 $display(error[9]);
  $stop;
end    

endmodule