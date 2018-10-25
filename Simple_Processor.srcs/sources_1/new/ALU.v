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
    always @ (posedge enable) begin
        if (enable) begin
            case (opcode)
                'b000: y <= a + b;   // Add inputs
                'b001: y <= ~b;        // Invert b
                'b010: y <= a + 1;   // Increment the accumulator register by 1
                'b011: y <= 0;       // zero the accumulator register?
                'b100: y <= b;       // pass input b
                default: y <= b;     // Unknown opcode then pass accumulator value
            endcase
        end else begin
            y <= b;     // pass accumulator if not enabled
        end
    end


endmodule