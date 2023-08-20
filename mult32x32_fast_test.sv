// 32X32 Multiplier test template
module mult32x32_fast_test;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Start signal
    logic [31:0] a;       // Input a
    logic [31:0] b;       // Input b
    logic busy;           // Multiplier busy indication
    logic [63:0] product; // Miltiplication product

// Put your code here
// ------------------
 mult32x32_fast inst(.clk(clk),.reset(reset),.start(start),.a(a),.b(b),.busy(busy),.product(product));
always begin
   #5
   clk = ~clk;
end
initial begin
   clk=1'b1;
    reset=1'b1;
    start=1'b0;
    a=32'b0;
    b=32'b0;

#40
reset=1'b0;
start=1'b0;
#10
start=1'b1;
a=32'd315481341;
b=32'd211438619;
#10
  start=1'b0;
#160
reset=1'b1;

#20
reset=1'b0;
start=1'b1;
          
a=32'b00000000000000001110011111101;
b=32'b0000000000000000110000011011;

#10

start=1'b0;

#160

start=1'b0;
end
// End of your code

endmodule
