`timescale 1ns / 1ps

module dff(
    input D,
    input rst,
    input clk,
    output reg q
    );
    
    always @(posedge clk or posedge rst) begin
        if(rst) q<=0;
        else q<=D;
    end
    
endmodule
