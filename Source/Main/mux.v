`timescale 1ns / 1ps

module mux(
    output reg out,
    input sel,
    input a,
    input b
    );
    
    wire not_sel;
    always @(sel or not_sel)
        out = (sel&a)|(not_sel&b);
    
    assign not_sel = ~sel;
    
endmodule
