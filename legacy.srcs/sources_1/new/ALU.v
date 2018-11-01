/*
*   16 bit ALU for simple processor
*   Luke Zambella
*/

module ALU(
input clk,     // Clock input
input [2:0] opcode, // ALU opcode independant of CPU Opcode
input [15:0] a,     // Input a
input [15:0] b,     // Input b
input cin,          // Carry in
input enable,       // enable input
output reg [15:0] y,// Output
output reg cout);      
    always @ (posedge clk) begin
        if (enable) begin
            case (opcode)
                'b000: y <= a + b;   // Add inputs (AC and MD)
                'b001: y <= ~a;      // Invert accumulator register (reg should be input a)
                'b010: y <= a + 1;   // Increment the accumulator register by 1
                'b011: y <= 0;       // Pass zero
                'b100: y <= b;       // pass input b (MD)
                default: y <= b;     // Unknown opcode then pass accumulator value
            endcase
        end
    end


endmodule