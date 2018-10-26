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
input enable,                   // Memory enable
input [11:0] MemAddr,           // Address input (Program counter)
input clk
    );
    
     reg [15:0] Memory [255:0]; // 255 word length of 16 bits
     
     always @ (posedge clk) begin
         if (enable) begin
            instruction = Memory[MemAddr]; // Output the contents referred to by the address
         end
     end
     
     
     initial begin  // Test instructions
        Memory[0] = 'b011_0_000000000000;  // INCR Accumulator by one
        Memory[1] = 'b000_0_000000000000;  // invert
        Memory[2] = 'b000_0_000000000000;  // invert
        Memory[3] = 'b001_0_000000000010;  // add with carry
        Memory[4] = 'b001_0_000000000000;  // add with carry
        Memory[5] = 'b001_0_000000000001;  // add with carry
        Memory[6] = 'b001_0_000000000010;  // add with carry
        Memory[7] = 'b000_0_000000000000;  // add with carry
     end
endmodule
