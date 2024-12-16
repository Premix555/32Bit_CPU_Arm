`include "extender.v"
`include "alu.v"
`include "regfile.v"
`include "mux2.v"
`include "adder.v"
//`include "flop.v"

module datapath(
	input  clk, reset,
  input  [1:0] RegSrc,	//To seelect Adress mux 
  input  RegWrite,		
  input  [1:0] ImmSrc,  
  input  ALUSrc,		//ALU Input mux
  input  [1:0] ALUControl,
  input  MemtoReg,
  input  PCSrc,
  output reg [3:0] ALUFlags,
  output reg [31:0] PC,
  input  [31:0] Instr,   //Instruction
  output reg [31:0] ALUResult, WriteData,
  input  [31:0] ReadData
	
);

  wire [31:0] PCNext,PCPlus4,PCPlus8,Result;
  wire [31:0] ExtImm,SrcA,SrcB;
  wire [3:0] RA1, RA2;

  //PC Logic
  mux2 #(32) pcmux(.y(PCNext),.d0(PCPlus4),.d1(Result),.s(PCSrc));
  flopenr #(.WIDTH(32)) pcflop(clk,reset,1'b1,PCNext,PC);
  //PC adder + 4, + 8 
  adder pcadder1(PC,32'b100,PCPlus4);  // PC Output to Instruction Memory
  adder pcadder2(PCPlus4,32'b100,PCPlus8);
  
//Register file
  //Reading from Instrction memory  
  mux2 #(4) ra1mux(Instr[19:16],4'b1111,RegSrc[0],RA1);
  mux2 #(4) ra2mux(Instr[3:0],Instr[15:12],RegSrc[1],RA2);
  regfile rf(clk, RegWrite, RA1, RA2, Instr[15:12],Result, PCPlus8, SrcA, WriteData);
  
  mux2 #(32) resmux(ALUResult,ReadData,MemtoReg,Result);
//Extender 
  extend ext(Instr[23:0],ImmSrc,ExtImm);
  
//ALU
  mux2 #(32) alumux(WriteData,ExtImm,ALUSrc,SrcB);
  alu alu(SrcA,SrcB,ALUControl,ALUResult,ALUFlags); //N Z C V 
  
endmodule 
  
  