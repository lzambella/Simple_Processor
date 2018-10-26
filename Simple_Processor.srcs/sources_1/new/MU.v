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
input clk,                  // Clock        
input [11:0] Addr,          // address of memory to store or write
input [15:0] WriteData,     // memory data being written to address
input enable,               // Enable
input WD,                   // 1 if we are writing data, other wise output data at memory location
output reg [15:0] ReadData  // output data memory 
);
    
    reg [15:0] Memory [255:0]; // 255 word length of 16 bits
    
    /*Perform the memory operation*/
    always @ (posedge clk) begin
        if (enable) begin
            if (WD) begin   // Write data to memory
                Memory[Addr] <= WriteData;
            end
            else begin  // Read data from memory
                 ReadData <= Memory[Addr]; 
            end
        end
    end
    
    
    initial begin // Store some values in memory
        Memory[0] = 'h0010;
        Memory[1] = 'h0001;
        Memory[2] = 'h000A;
        Memory[3] = 'h0FFF;
    end
endmodule
