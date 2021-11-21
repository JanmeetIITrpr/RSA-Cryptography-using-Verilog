`timescale 1ns / 1ps

/*to calculate decryption key 'd' and encryption key 'e' we use extended euclidian algorithm  
i.e                 d * e = 1 mod (phi)
*/

module control(
    input [WIDTH-1:0] p,q,//prime numbers
    input clk,
    input reset,
    input reset1,
    input encrypt_decrypt,//if =1 it is used for encryption, otherwise decryption.
    input [WIDTH-1:0] msg_in,//msg input to be encrypted/decrypted
    output [WIDTH*2-1:0] msg_out,//output message after running the program
    output mod_exp_finish
    );
   
    parameter WIDTH = 32;
    
    wire inverter_finish;
    wire [WIDTH*2-1:0] e,d;//e=encryption key.d=decryption key.
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
