/*module flopr(
  input clk, reset,
  input [31:0] d,
  output reg [31:0] q);
  
  always @(posedge clk, posedge reset)
  	if (reset) q<=0;
  	else q<=d;

endmodule */

module flopenr #(parameter WIDTH=32)
  (input clk, reset, en,
   input reg [WIDTH-1:0] d,
   output reg [WIDTH-1:0] q);
  
  always @(posedge clk, posedge reset)
    if (reset) q<=0;
    else if (en) q<=d;
endmodule 