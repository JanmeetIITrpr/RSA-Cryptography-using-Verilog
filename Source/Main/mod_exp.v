`timescale 1ns / 1ps
`define UPDATE 2'd1
`define HOLD 2'd2

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
