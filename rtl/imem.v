module imem(input [31:0] a,
            output [31:0] rd
           );
  
  reg [31:0] RAM[63:0];
  
  initial 
      $readmemh("memfile.dat",RAM); //read hexadecimal
 
  // Right shift by 2 to divide the address by 4 
  //the adress of ram is word aligned 
    assign rd = RAM[a[31:2]];  
  
  
endmodule 