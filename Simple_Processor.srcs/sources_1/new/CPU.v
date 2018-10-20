`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Luke Zambella
// 
// Create Date: 10/11/2018 12:57:55 PM
// Design Name: 
// Module Name: CPU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Main CPU unit. Fetches instructions from memory and feeds into control unit. also handles program counter
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CPU(

    );
    
    reg [11:0] PC; // Program counter
    wire clk;
    
    always @ (posedge clk) begin
    // Every clock cycle, read a new instruction from memory and feed into CU
    end
    
endmodule
