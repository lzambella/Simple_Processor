/*
*   16 bit ALU for simple processor
*   Luke Zambella
*/

module ALU(
input wire clk,     // Clock input
input [2:0] opcode, // ALU opcode independant of CPU Opcode
input [15:0] a,     // Input a
input [15:0] b,     // Input b
input cin,          // Carry in
output reg [15:0] y,// Output
output reg cout);   // Carry out
    always @ (posedge clk) begin    
        case (opcode)
            'b000: y = a + b; // Add inputs
            'b001: y = !(a); // Invert a
            'b010: y = a + 1; // Increment the accumulator register by 1
            'b011: y = 0; // zero the accumulator register?
            'b100: y = b; // pass input b
        endcase
    end


endmodule