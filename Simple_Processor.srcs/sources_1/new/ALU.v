/*
*   16 bit ALU for simple processor
*   Luke Zambella
*/

module ALU(
input [2:0] opcode,
input [15:0] a,
input [15:0] b,
input cin,
output reg [15:0] y,
output reg cout);
    always @ opcode begin    
        case (opcode)
            'b000: y = a + b; // Add inputs
            'b001: y = !(a); // Invert a
            'b010: y = a + 1; // Increment the accumulator register by 1
            'b011: y = 0; // zero the accumulator register?
            'b100: y = b; // pass input b
        endcase
    end


endmodule