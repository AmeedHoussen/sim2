// 32X32 Multiplier FSM
module mult32x32_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    output logic busy,            // Multiplier busy indication
    output logic [1:0] a_sel,     // Select one byte from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [2:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

   
    typedef enum { s0, s1, s2, s3, s4, s5,
  s6, s7, s8} sm_type;

    sm_type current_state;
    sm_type next_state;
   
always_comb begin
    //Default values
next_state = current_state;
busy = 1'b1;
upd_prod = 1'b0;
if( reset == 1'b0 )
begin
upd_prod = 1'b1;
clr_prod = 1'b0;
end
else
begin
upd_prod = 1'b0;
clr_prod = 1'b1;
end

    case (current_state)
    s0: begin
if(start == 1'b1)
begin
a_sel = 2'b00;
b_sel = 1'b0;
shift_sel = 3'b000;
    busy = 1'b0;
upd_prod = 1'b0;
clr_prod = 1'b1;
next_state = s1;
end
else
begin
busy = 1'b0;
upd_prod = 1'b0;
clr_prod = 1'b0;
end
    end
    s1: begin
next_state = s2;
a_sel = 2'b00;
b_sel = 1'b0;
shift_sel = 3'b000;
busy = 1'b1;
upd_prod = 1'b1;
clr_prod = 1'b0;

    end
   
s2: begin
next_state = s3;
a_sel = 2'b00;
b_sel = 1'b1;
shift_sel = 3'b010;
busy = 1'b1;
upd_prod = 1'b1;
clr_prod = 1'b0;

    end
s3: begin
next_state = s4;
a_sel = 2'b01;
b_sel = 1'b0;
shift_sel = 3'b001;
busy = 1'b1;
upd_prod = 1'b1;
clr_prod = 1'b0;

    end
s4: begin
next_state = s5;
a_sel = 2'b01;
b_sel = 1'b1;
shift_sel = 3'b011;
busy = 1'b1;
upd_prod = 1'b1;
clr_prod = 1'b0;

    end
s5: begin
next_state = s6;
a_sel = 2'b10;
b_sel = 1'b0;
shift_sel = 3'b010;
busy = 1'b1;
upd_prod = 1'b1;
clr_prod = 1'b0;

    end
s6: begin
next_state = s7;
a_sel = 2'b10;
b_sel = 1'b1;
shift_sel = 3'b100;
busy = 1'b1;
upd_prod = 1'b1;
clr_prod = 1'b0;

    end
s7: begin
next_state = s8;
a_sel = 2'b11;
b_sel = 1'b0;
shift_sel = 3'b011;
busy = 1'b1;
upd_prod = 1'b1;
clr_prod = 1'b0;

    end
s8: begin
next_state = s0;
a_sel = 2'b11;
b_sel = 1'b1;
shift_sel = 3'b101;
busy = 1'b1;
upd_prod = 1'b1;
clr_prod = 1'b0;

    end
    endcase
end

always_ff @(posedge clk, posedge reset) begin
        if (reset == 1'b1) begin
            current_state <= s0;
        end
        else begin
            current_state <= next_state;
        end
    end

endmodule
