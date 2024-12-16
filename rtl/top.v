`include "cpu.v"
`include "dmem.v"
`include "imem.v"

module top(input clk, reset);
  
  	wire [31:0] PC, Instr, ReadData;
  wire  [31:0] WriteData, ALUResult;
	wire  MemWrite;
  
  //integrate CPU, Instruction Memory, Data Memory 
  
  cpu cpu(clk, reset,PC, Instr, MemWrite, ALUResult, WriteData, ReadData);
  imem imem(PC, Instr);
  dmem dmem(clk, MemWrite, ALUResult, WriteData, ReadData);
  
  
  
  
endmodule 