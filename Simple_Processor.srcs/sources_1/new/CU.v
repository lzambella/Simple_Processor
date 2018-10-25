`timescale 1ns / 1ps

/* Control unit outputs enables for all registers and operations */
/* All those registers and operations are triggered on each clock cycle and check if they are enabled*/


module CU(
input clk,
input opcode,
output ALU_ENABLE,
output MEM_FETCH_ENABLE,
output INSTR_FETCH_ENABLE
);
`define STATE_LOAD_INSTR 'b000     // Load instruction from memory
`define STATE_INCR_COUNTER 'b001   // Increment program counter

reg [2:0] STATE = `STATE_LOAD_INSTR; // Current program state

always @ (posedge clk) begin
    case (STATE)
        `STATE_LOAD_INSTR: begin
            STATE <= `STATE_INCR_COUNTER;
        end
    endcase
end     

/* Assign enables depending on current state*/  
assign INSTR_FETCH_ENABLE = (STATE == `STATE_LOAD_INSTR);   // Enable the circuit to fetch an instruction

endmodule
