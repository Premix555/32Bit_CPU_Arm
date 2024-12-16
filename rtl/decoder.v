module decoder(input [1:0]Op,
               input [5:0] Funct,
               input [3:0] Rd, //desgination reg adress
               output reg [1:0] FlagW,
               output reg PCS, RegW, MemW, 
               output reg MemtoReg, ALUSrc,
               output reg [1:0] ImmSrc, RegSrc, ALUControl);
  
  //Internal Wires 
  reg [9:0] controls;
  reg branch,ALUOp;
  
  //Main Decoder 
  always @(*) begin
    casex(Op)
      2'b00:begin if(Funct[5]) controls = 10'b0011001001; //DP Imm
      		else controls = 10'b0000001001;      	//DP reg
        end
      2'b01:begin if(Funct[0]) controls = 10'b0101011000; //LDR
        else controls = 10'b0011010100;			//STR (simbu) 
      	end
      2'b10: controls = 10'b1001100010;  //branch
      default: controls = 10'bx;
    endcase

  assign {branch,MemtoReg,MemW,ALUSrc,ImmSrc,
          RegW,RegSrc,ALUOp} = controls;
  end // end of main decoder 
  
  
  //ALU Decoder 
  always @(*) begin 
    if (ALUOp) begin
      case(Funct[4:1])
       4'b0100: ALUControl = 2'b00; //ADD 
       4'b0010: ALUControl = 2'b01; //SUB
       4'b0000: ALUControl = 2'b10; // AND
       4'b1100: ALUControl = 2'b11; //OR
       default: ALUControl = 2'bx; //Eat 5 start do nothing
      endcase
      //Update Flags if S bit is set
      FlagW[1] = Funct[0];		  // Neg,Zero
      FlagW[0] = Funct[0] & (ALUControl == 2'b00 | ALUControl  ==2'b01); // Carry.Overflow
    end
    else begin   // ALU is ADD by default for STR,LDR operations
      ALUControl = 2'b00;
      FlagW = 2'b00;
    end
  end
  
  
  //PCS
  assign PCS = ((Rd == 4'b1111) & RegW) | branch;
  
endmodule 