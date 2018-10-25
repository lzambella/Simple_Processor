`timescale 1ns / 1ps

/* Control unit outputs enables for all registers and operations */
/* All those registers and operations are triggered on each clock cycle and check if they are enabled*/


module CU(
input clk,
input [2:0] opcode,
output[2:0] ALU_OPCODE,
output ALU_ENABLE,
output MEM_FETCH_ENABLE,
output INSTR_FETCH_ENABLE,
output MEM_STORE_ENABLE,
output PC_ENABLE,
output WRITEBACK_ENABLE,
output FETCH_OPCODE
);
/* Control states */
`define STATE_LOAD_INSTR            'b00000         // Load instruction from memory
`define STATE_INCR_COUNTER          'b00001         // Increment program counter
`define STATE_DECODE_OPCODE         'b00010         // Fetch opcode state
`define STATE_ADD_ACCUM             'b00011         // Add MD register to AC
`define STATE_INVERT_ACCUM          'b00100         // Invert accumulator
`define STATE_ADD_CARRY             'b00101         // Add with carry
`define STATE_INCR_ACCUM            'b00110         // Increment accumulator by one
`define STATE_PASS_IN_B             'b00111         // pass input b for alu
`define STATE_WRITE_ACCUM           'b01000         // Write ALU output to accumulator
/* Opcodes */
`define INVERT          'b000
`define ADC             'b001
`define JPA             'b010
`define INCA            'b011
`define STA             'b100
`define LDA             'b101


/* ALU opcodes */
`define ALU_ADD 'b000       // ALU add
`define ALU_INVERT 'b001    // Invert AC
`define ALU_INCR 'b010      // Increment AC
`define PASS_IN_B 'b100     // pass input b

reg [7:0] STATE = `STATE_LOAD_INSTR; // Initial program state, load instruction from memory
reg [2:0] ALU_OP;                    // Local ALU opcode
/* Finite state machine */
always @ (posedge clk) begin
    case (STATE)
        `STATE_LOAD_INSTR: begin
            STATE <= `STATE_INCR_COUNTER;
        end
        `STATE_INCR_COUNTER: begin
            STATE <= `STATE_DECODE_OPCODE;
        end
        
        /* OPCODE STATES */
        `STATE_DECODE_OPCODE: begin
            case (opcode)
                `INVERT: begin    // Invert accumulator
                    STATE <= `STATE_INVERT_ACCUM;
                    ALU_OP <= `ALU_INVERT;
                end
                `ADC: begin
                    STATE <= `STATE_ADD_CARRY;
                    ALU_OP <= `ALU_ADD;
                end
                `INCA: begin
                    STATE <= `STATE_INCR_ACCUM;
                    ALU_OP <= `ALU_INCR;
                end
                /* TODO: Write memfetch and store states */
                default: begin
                     STATE <= `STATE_LOAD_INSTR;
                end
            endcase
        end
        
        /* Certain ALU states go to writeback */
        `STATE_INVERT_ACCUM: begin          
            STATE <= `STATE_WRITE_ACCUM;
        end
        `STATE_ADD_CARRY: begin
            STATE <= `STATE_WRITE_ACCUM;
            
        end
        `STATE_INCR_ACCUM: begin
            STATE <= `STATE_WRITE_ACCUM;
            
        end
        `STATE_PASS_IN_B: begin
            STATE <= `STATE_WRITE_ACCUM;
            
        end
        
        /* Reset states */
        `STATE_WRITE_ACCUM: begin
            STATE <= `STATE_LOAD_INSTR;
        end
        
        default: STATE <= `STATE_LOAD_INSTR;
    endcase
         
end     

/* Assign enables depending on current state*/  
assign ALU_OPCODE = ALU_OP;                                                                                     // Assign ALU opcode to output
assign INSTR_FETCH_ENABLE = (STATE == `STATE_LOAD_INSTR);                                                       // Enable the circuit to fetch an instruction from memory
assign ALU_ENABLE = (STATE == `STATE_INCR_ACCUM | STATE == `STATE_ADD_CARRY | STATE == `STATE_INVERT_ACCUM);    // Enable ALU
assign PC_ENABLE  = (STATE == `STATE_INCR_COUNTER);
assign WRITEBACK_ENABLE = (STATE == `STATE_WRITE_ACCUM);
assign FETCH_OPCODE = (STATE == `STATE_DECODE_OPCODE);
//assign MEM_FETCH_ENABLE = (STATE == `STATE_MEM_FETCH);
endmodule
