`timescale 1ns / 1ps
`define UPDATING 3'd1
`define CHECK 3'd2
`define HOLDING 3'd3
`define UPDATE 2'd1
`define HOLD 2'd2


module mod(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] n,
    output [WIDTH-1:0] R,
    output [WIDTH-1:0] Q
    );
   parameter WIDTH = 19;
   reg [WIDTH-1:0] A,N;
   reg [WIDTH:0] p;   
   integer i;
  
   always@ (a or n) begin
       A = a;
       N = n;
       p = 0;
       for(i=0;i < WIDTH;i=i+1) begin 
           p = {p[WIDTH-2:0],A[WIDTH-1]};
           A[WIDTH-1:1] = A[WIDTH-2:0];
           p = p-N;
           if(p[WIDTH-1] == 1)begin
                A[0] = 1'b0;
                p = p + N;   
           end
           else
                A[0] =1'b1;
      end
         
   end    
   
   assign R = p,Q = A;
endmodule

module mod_exp(
    input [WIDTH*2-1:0] base,
	input [WIDTH*2-1:0] modulo,
	input [WIDTH*2-1:0] exponent,
	input clk,
	input reset,
	output finish,
    output [WIDTH*2-1:0] result
    );
    
    parameter WIDTH = 32;
        
    reg [WIDTH*2-1:0] base_reg,modulo_reg,exponent_reg,result_reg;
    reg [1:0] state;
    
    wire [WIDTH*2-1:0] result_mul_base = result_reg * base_reg;
    wire [WIDTH*2-1:0] result_next;
    wire [WIDTH*2-1:0] base_squared = base_reg * base_reg;
    wire [WIDTH*2-1:0] base_next;
    wire [WIDTH*2-1:0] exponent_next = exponent_reg >> 1;
    
    assign finish = (state == `HOLD) ? 1'b1:1'b0;
    assign result = result_reg;
    
    mod base_squared_mod(base_squared,modulo_reg,base_next,);
    defparam base_squared_mod.WIDTH = WIDTH*2;
                                                                                  
    mod result_mul_base_mod (result_mul_base,modulo_reg,result_next,);
    defparam result_mul_base_mod.WIDTH = WIDTH*2;
    
   
    always @(posedge clk) begin
        if(reset) begin
            base_reg <= base;
            modulo_reg <= modulo;
            exponent_reg <= exponent;                
            result_reg <= 32'd1;
            state <= `UPDATE;
        end
        else case(state)
            `UPDATE: begin
                if (exponent_reg != 64'd0) begin
                    if (exponent_reg[0])
                        result_reg <= result_next;
                    base_reg <= base_next;
                    exponent_reg <= exponent_next;
                    state <= `UPDATE;
                end
                else state <= `HOLD;
            end
            
           `HOLD: begin
                end
       endcase
    end
endmodule

module inverter(
    input [WIDTH-1:0] p,
	input [WIDTH-1:0] q,
	input clk,
	input reset,
	output finish,
	output [WIDTH*2-1:0] e,
	output [WIDTH*2-1:0] d
    );
    
    parameter WIDTH = 32;
    
    reg [WIDTH*2-1:0] totient_reg,a,b,y,y_prev;
    reg [2:0] state;
    reg [WIDTH-1:0] e_reg;
    
    wire [WIDTH*2-1:0] totient = (p-1)*(q-1);
    wire [WIDTH*2-1:0] quotient,b_next;
    wire [WIDTH*2-1:0] y_next = y_prev - quotient * y;
    wire [WIDTH-1:0] e_plus3 = e_reg + 2;
    assign finish = (state == `HOLDING) ? 1'b1 : 1'b0;
    assign e = e_reg;
    assign d = y_prev;
    
    mod x_mod_y(a,b,b_next,quotient);
    defparam x_mod_y.WIDTH = WIDTH*2;
    
    always @(posedge clk) begin
        if(reset) begin
            totient_reg <= totient;
            a <= totient;
            b <= 3;
            e_reg <=3;
            y <= 1;
            y_prev <= 0;
            state = `UPDATING;
        end 
              case(state)
                `UPDATING: begin
                    if(b != 64'd0) begin
                        a <= b;
                        b <= b_next;
                        y <= y_next;
                        y_prev <= y;
                        state <= `UPDATING;
                    end
                    else state <= `CHECK;
                 end
                `CHECK: begin
                    if(a == 64'd1 && y_prev[WIDTH*2-1] == 1'b0) 
                        state = `HOLDING;
                    else begin
                         a <= totient_reg;
                         b <= e_plus3;
                         e_reg <= e_plus3;
                         y <= 1;
                         y_prev = 0;
                         state <= `UPDATING;
                   end
                 end
                `HOLDING: begin
                    end
           endcase 
    end
    
endmodule

module control(
    input [WIDTH-1:0] p,q,
    input clk,
    input reset,
    input reset1,
    input encrypt_decrypt,
    input [WIDTH-1:0] msg_in,
  output [WIDTH*2-1:0] msg_out,
    output mod_exp_finish
    );
    
    parameter WIDTH = 32;
    
    wire inverter_finish;
    wire [WIDTH*2-1:0] e,d;
    wire [WIDTH*2-1:0] exponent = encrypt_decrypt?e:d;
    wire [WIDTH*2-1:0] modulo = p*q;
    wire mod_exp_reset  = 1'b0;
    
    reg [WIDTH*2-1:0] exp_reg,msg_reg;
    reg [WIDTH*2-1:0] mod_reg;
    
    always @(posedge clk)begin
         exp_reg <= exponent;
         mod_reg <= modulo;
         msg_reg <= msg_in;
    end
    
    inverter i(p,q,clk,reset,inverter_finish,e,d);
    defparam i.WIDTH = WIDTH;
    mod_exp m(msg_reg,mod_reg,exp_reg,clk,reset1,mod_exp_finish,msg_out);
    defparam m.WIDTH = WIDTH;
    
endmodule
