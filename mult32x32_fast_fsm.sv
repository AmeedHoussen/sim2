// 32X32 Multiplier FSM
module mult32x32_fast_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    input logic a_msb_is_0,       // Indicates MSB of operand A is 0
    input logic b_msw_is_0,       // Indicates MSW of operand B is 0
    output logic busy,            // Multiplier busy indication
    output logic [1:0] a_sel,     // Select one byte from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [2:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

// Put your code here
// ------------------
typedef enum  {s0,s1,s2,s3,s4,s5,s6,s7,s8} sm_type;
sm_type current_state;
sm_type next_state;
always_ff @(posedge clk,posedge reset) begin
    if (reset == 1'b1) begin
        current_state <= s0;
    end
    else begin
        current_state<=next_state;
    end
end
always_comb begin
next_state = current_state;
busy=1'b0;
a_sel=2'b00;
b_sel=1'b0;  
shift_sel=3'b000;
upd_prod=1'b0;
clr_prod=1'b1;
case (current_state)
    s0:begin
       if (start == 1'b1) begin
          upd_prod=1'b1;
           next_state=s1;
       end
    end
    s1:begin
       if(b_msw_is_0==1'b1) begin
      next_state=s3;
       busy=1'b1;
       a_sel=2'b01;
       b_sel=1'b0;
       shift_sel=3'b001;
      upd_prod=1'b1;
      clr_prod= 1'b0;
end
else begin 
next_state=s2;
       busy=1'b1;
       a_sel=2'b00;
       b_sel=1'b0;
       shift_sel=3'b000;
      upd_prod=1'b1;
      clr_prod= 1'b0;
end
    end
s2: begin
        next_state=s3;
       busy=1'b1;
       a_sel=2'b00;
       b_sel=1'b1;
       shift_sel=3'b010;
      upd_prod=1'b1;
      clr_prod= 1'b0;
    end
    s3: begin
     if(b_msw_is_0==1'b1) begin
       next_state=s5;
       busy=1'b1;
       a_sel=2'b01;
       b_sel=1'b1;
       shift_sel=3'b011;
      upd_prod=1'b1;
      clr_prod= 1'b0;
end 
  else begin
       next_state=s4;
       busy=1'b1;
       a_sel=2'b01;
       b_sel=1'b0;
       shift_sel=3'b001;
      upd_prod=1'b1;
      clr_prod= 1'b0;
end
    end


    s4: begin

           next_state=s5;
       busy=1'b1;
       a_sel=2'b01;
       b_sel=1'b1;
       shift_sel=3'b011;
      upd_prod=1'b1;
      clr_prod= 1'b0;
    end


    s5: begin
 if(b_msw_is_0==1'b1) begin
    if(a_msb_is_0==1'b1) begin
       next_state=s0;
       busy=1'b1;
      clr_prod= 1'b1;
end
     else begin
          next_state=s7;
       busy=1'b1;
       a_sel=2'b10;
       b_sel=1'b1;
       shift_sel=3'b100;
      upd_prod=1'b1;
      clr_prod= 1'b0;
     end

end
else begin 
       next_state=s6;
       busy=1'b1;
       a_sel=2'b10;
       b_sel=1'b0;
       shift_sel=3'b010;
      upd_prod=1'b1;
      clr_prod= 1'b0;
    end
end

    s6: begin
if (a_msb_is_0==1'b1) begin
     next_state=s0;
      busy=1'b1;
      clr_prod= 1'b1;
end
else begin
     next_state=s7;
       busy=1'b1;
       a_sel=2'b10;
       b_sel=1'b1;
       shift_sel=3'b100;
      upd_prod=1'b1;

      clr_prod= 1'b0;
end
    end
    s7: begin
if (b_msw_is_0==1'b1) begin
next_state=s0;
      busy=1'b1;
      clr_prod= 1'b1;
end
else begin
        next_state=s8;
       busy=1'b1;
       a_sel=2'b11;
       b_sel=1'b0;
       shift_sel=3'b011;
      upd_prod=1'b1;
      clr_prod= 1'b0;
end
    end
    s8: begin
         next_state=s0;
       busy=1'b1;
       a_sel=2'b11;
       b_sel=1'b1;
       shift_sel=3'b101;
      upd_prod=1'b1;
      clr_prod= 1'b0;
    end
endcase 
end
// End of your code

endmodule
