`timescale 1ns / 1ps
//2:1 mux 
module mux(
    output reg out, //Output
    input sel, //Select line
    input a, //Input 1
    input b //Input 2
    );
    
    wire not_sel;
    always @(sel or not_sel)
        out = (sel&a)|(not_sel&b);
    
    assign not_sel = ~sel;
    
endmodule
