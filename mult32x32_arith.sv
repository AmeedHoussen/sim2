// 32X32 Multiplier arithmetic unit template
module mult32x32_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic [1:0] a_sel,     // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [2:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic [63:0] product  // Miltiplication product
);

// Put your code here
// ------------------
logic [7:0]muxa_out;
logic [15:0]muxb_out;
logic [23:0]mult_out;
logic [63:0]mux4_out;
always_comb begin
case (a_sel)
       2'b00: muxa_out = a[7:0];
       2'b01: muxa_out = a[15:8];
       2'b10: muxa_out = a[23:16];
       2'b11: muxa_out = a[31:24];
   endcase 
end
always_comb begin
   case (b_sel)
       1'b1: muxb_out = b[31:16];
       1'b0: muxb_out = b[15:0];
 endcase 
end

assign mult_out=muxa_out*muxb_out;
always_comb begin
   case (shift_sel)
       3'b000: mux4_out = mult_out;
       3'b001: mux4_out = mult_out<<8;
       3'b010 :mux4_out=mult_out<<16;
       3'b011:mux4_out=mult_out<<24;
      3'b100: mux4_out = mult_out<<32;
       3'b101: mux4_out = mult_out<<40;
       3'b110 :mux4_out=mult_out;
       3'b111:mux4_out=64'b0;
   endcase 
end
always_ff @(posedge clk,posedge reset) begin
    if (reset==1'b1) begin
        product<=64'b0;
    end
    else begin
        if (clr_prod==1'b1) begin
            product<=64'b0;
        end
        else if(upd_prod==1'b1) begin
            product<=product+mux4_out;
        end
    end
end

// End of your code

endmodule