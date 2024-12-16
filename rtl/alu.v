module alu (
  input [31:0] SrcA,	//32bit input A
  input [31:0] SrcB,	//'' '' input B
  input [1:0] ALUControl, //ctrl signal 
  output reg [31:0] ALUResult, 
  /*output reg Negative,
  output reg Zero,
  output reg Carry,
  output reg Overflow*/
  
  output reg [3:0] ALUFlag
  
  
);
  
  reg Negative,Zero,Carry,Overflow;
  
  always @(*) begin
    case (ALUControl)
      2'b00: begin				// ADD Operation with carry
        {Carry,ALUResult} = SrcA + SrcB;
        Carry = 1'b0;
        Overflow = ((SrcA[31] == SrcB[31]) && (ALUResult[31] != SrcA[31]));//If MSB of inputs is 1 and in result MSB is not 1  
      end
      2'b01: begin 				// SUB Operation with Borrow(carry)
        {Carry, ALUResult} = SrcA - SrcB;
        Overflow = ((SrcA[31] != SrcB[31]) && (ALUResult[31] != SrcA[31]));
        Carry = 1'b0;
      end
      2'b10: begin				//AND Operation
      	ALUResult = SrcA & SrcB;
        Carry = 1'b0;
        Overflow = Carry;
      end
      2'b11: begin 				//OR Operation
        ALUResult = SrcA | SrcB;
        Carry = 1'b0;
        Overflow=Carry;
      end
      default: begin
        ALUResult = 32'b0;
        Carry = 1'b0;
        Overflow = 1'b0;
      end
    endcase
  end
  
  assign Negative = ALUResult[31];
  assign Zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;
  assign ALUFlag = {Negative,Zero,Carry,Overflow};
 
  
endmodule 