`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Luke Zambella
// 
// Create Date: 10/20/2018 06:00:27 PM
// Design Name: Instruction Memory Unit
// Module Name: InstrMem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Instruction memory, each instruction is referred to by the program counter
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InstrMem(
output reg [15:0] instruction,  // Instruction Output
input [11:0] MemAddr,           // Address input (Program counter)
input clk
    );
    
     reg [15:0] Memory [255:0]; // 255 word length of 16 bits
     
     always @ (posedge clk) begin
        instruction <= Memory[MemAddr]; // Output the contents referred to by the address
     end
     
     
     initial begin  // Test instructions
        Memory[16] = 'b001_0_000000000000; // Add with carry (addr location 0)
        Memory[32] = 'b001_0_000000010000; // Add with carry (addr location 16)
        Memory[48] = 'b001_0_000000100000; // Add with carry (addr location 16)
        Memory[64] = 'b001_0_000000000000; // Add with carry (addr location 16)
     end
endmodule
