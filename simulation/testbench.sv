`include "top.v"

module testbench();
	reg clk;
	reg reset;

top dut(clk, reset);
  
initial begin
	reset <= 1; 
  	#10 reset <= 0;
  	clk <= 1;
   
end
  
always #5 clk=~clk;
  
  
initial begin 
  #1000
  if (dut.dmem.RAM[21] ===32'd8) begin
    $display("Test Passed: Memory[84] contains 8");
        end else begin
          $display("Test Failed: Memory[84] = %d, expected 8",dut.dmem.RAM[21]);          
        end
$finish;
end
  
  
/*
initial begin 
  #10000
    if (dut.cpu.dp.rf.rf[5] === 32'd11) begin
      $display("Test Passed: R5 contains 11");
        end 
    else begin
          $display("Test Failed: R5 = %d, expected 7",dut.cpu.dp.rf.rf[5]);      
        end
$finish;
end
 */
endmodule
