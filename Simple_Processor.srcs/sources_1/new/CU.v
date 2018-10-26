`timescale 1ns / 1ps

/* Control unit outputs enables for all registers and operations */
/* All those registers and operations are triggered on each clock cycle and check if they are enabled*/


module CU(
input clk,
input [3:0] opcode,     // opcode contains opcode and addressing mode
input ACCUMULATOR,
output[2:0] ALU_OPCODE,
output ALU_ENABLE,
output MEM_FETCH_ENABLE,
output INSTR_FETCH_ENABLE,
output MEM_STORE_ENABLE,
output PC_ENABLE,
output WRITEBACK_ENABLE,
output FETCH_OPCODE,
output PC_DIRECT_JMP,
output WRITE_DATA
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

`define STATE_JPA                   'b01001         // Jump if AC greater than zero
`define STATE_FETCH_MEM             'b01010         // Fetch from memory
`define STATE_AM_INDIR              'b01011         // Set PC to IR
`define STATE_LOAD_MEM              'b01100         // Load value from data mem
`define STATE_STORE_MEM             'b01101         // Store into memory
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

/* Local variables */
wire ADDRESS_MODE;          // addressing mode


reg [7:0] STATE = `STATE_LOAD_INSTR; // Initial program state, load instruction from memory
reg [2:0] ALU_OP;                    // Local ALU opcode

/* Finite state machine */
always @ (posedge clk) begin
    case (STATE)
        `STATE_LOAD_INSTR: begin
            STATE <= `STATE_INCR_COUNTER;
        end
        `STATE_INCR_COUNTER: begin
            if (opcode[3:1] == `JPA) begin // if opcode is jump, or store dont load memory. Opcode is already loaded at this point
                STATE <= `STATE_JPA;
            end else begin                 // else jump to load memory state
                STATE <= `STATE_LOAD_MEM;
            end
        end
        /* Load value from memory if opcode isnt immediate*/
        `STATE_LOAD_MEM: begin
            STATE <= `STATE_DECODE_OPCODE;
        end
        
        /* OPCODE STATES */
        `STATE_DECODE_OPCODE: begin
            case (opcode[3:1])
                `INVERT: begin    // Invert accumulator
                    STATE <= `STATE_INVERT_ACCUM;
                    ALU_OP <= `ALU_INVERT;
                end
                
                `ADC: begin       // Add with carry                 
                    STATE <= `STATE_ADD_CARRY;
                    ALU_OP <= `ALU_ADD;
                end
                
                `INCA: begin      // Increment accum by one
                    STATE <= `STATE_INCR_ACCUM;
                    ALU_OP <= `ALU_INCR;
                end
                
                default: begin
                     STATE <= `STATE_LOAD_INSTR;
                end
            endcase
        end
        
        
        /* Jump state */
        `STATE_JPA: begin
            if (ACCUMULATOR > 0) begin
                /* Check addressing mode */
                if (ADDRESS_MODE) begin
                    /* MA gets address referred to by IR */
                    
                end else begin
                    /* set PC to value referred to by IR */
                    STATE <= `STATE_AM_INDIR;
                end
            end else begin
                STATE <= `STATE_LOAD_INSTR;
            end
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
        
        `STATE_AM_INDIR: begin
            STATE <= `STATE_LOAD_INSTR;
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
assign MEM_FETCH_ENABLE = (STATE == `STATE_LOAD_MEM);
assign PC_DIRECT_JMP = (STATE == `STATE_AM_INDIR);
assign ADDRESS_MODE = opcode[0];
endmodule
