`include "flop.v"

module condlogic (
  input clk, reset,
  input [3:0] Cond,
  input [3:0] ALUFlags,
  input [1:0] FlagW,
  input PCS,RegW,MemW,
  output reg PCSrc,RegWrite,MemWrite);
  
  wire [3:0] Flags; // NZCV
  wire [1:0] FlagWrite;
  reg CondEx;
  
  flopenr #(.WIDTH(2)) flagreg1(clk,reset, FlagWrite[1], ALUFlags[3:2], Flags[3:2]); // N Z
    
  flopenr #(.WIDTH(2)) flagreg2(clk,reset, FlagWrite[0], ALUFlags[1:0], Flags[1:0]); // C V
  
  
  //update CondEx
  condcheck cc(Cond, Flags, CondEx);
  //the final output pins
  assign FlagWrite = FlagW & {2{CondEx}};
  assign RegWrite = RegW & CondEx;
  assign MemWrite = MemW & CondEx;
  assign PCSrc = PCS & CondEx;
  
endmodule 
  
// condEx output block 

module condcheck(
    input [3:0] Cond,
    input [3:0] Flags, 
    output reg CondEx
  );
    wire neg, zero, carry, overflow, ge;
    assign {neg, zero, carry, overflow} = Flags;
    assign ge = ~(neg^overflow);
    
    always@(*)
      case(Cond)
        4'b0000: CondEx = zero;   	 //EQ
        4'b0001: CondEx = ~zero;   	 //NE
        4'b0010: CondEx = carry;  	 //Cs/HS
        4'b0011: CondEx = ~carry; 	 //cc/LO
        4'b0100: CondEx = neg;    	 //MI
		4'b0101: CondEx = ~neg;      // PL
      	4'b0110: CondEx = overflow;  // VS
      	4'b0111: CondEx = ~overflow; // VC
      	4'b1000: CondEx = carry & ~zero; // unsigned higher HI
        4'b1001: CondEx = ~(carry & ~zero); // unsigned lower or same LS
      	4'b1010: CondEx = ge; 			// Greater than or equal 
      	4'b1011: CondEx = ~ge; 			// Less then LT
      	4'b1100: CondEx = ~zero & ge; 	// Greater than GT
        4'b1101: CondEx = (zero | ~ge); // LE
      	4'b1110: CondEx = 1'b1; 		// Always
      default: CondEx = 1'bx; 
      endcase
 endmodule 

