`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Luke Zambella
// 
// Create Date: 10/18/2018 12:59:48 PM
// Design Name: Memory Unit
// Module Name: MU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MU(
input [11:0] Addr,          // address of memory to store or write
input [15:0] WriteData,     // memory data being written to address
output reg [15:0] ReadData, // output data memory
input WD,                   // 1 if we are writing data, other wise output data at memory location
input wire clk         
    );
    
    reg [15:0] Memory [255:0]; // 255 word length of 16 bits
    
    /*Perform the memory operation*/
    always @ (posedge clk) begin
        if (WD) begin   // Write data to memory
            Memory[Addr] <= WriteData;
        end
        else begin  // Read data from memory
             ReadData <= Memory[Addr]; 
        end
    end
    
    
    initial begin // Store some values in memory
        Memory[0] = 'h0000;
        Memory[16] = 'h0001;
        Memory[32] = 'h000A;
        Memory[48] = 'h0FFF;
    end
endmodule
