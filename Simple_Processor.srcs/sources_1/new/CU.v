`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Luke Zambella
// 
// Create Date: 10/11/2018 01:00:40 PM
// Design Name: 
// Module Name: CU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Control Unit for basic accumulator
//              The main function is to decode instructions from memory                
// 
// Dependencies: ALU.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CU(
input wire clk,      // Clock input
output reg reset,
input [15:0] instr,  // 16-bit Instruction
output reg [15:0] PC     // Program counter
    );
    
    reg [2:0] opcode; // Operation code for CPU, spans from instruction[13:15]
    reg AM; // Addressin moode, instr[12] 
    
    reg [4:0] regEnable; // enable output for all registers
    
    /*
    *   Registers
    */
    reg[15:0] IR, MD, AC; // Instruction register, MD, Accumulator Register
    reg[11:0] MA;         // MA Register, from instr[0:11]
    /********/
    reg[15:0] accum_in; // value referred to by address in the instruction
    wire c_out;
    reg[2:0] aluCom;
    reg writeMemData;
    /***************
        Data Memory, stores actual values as opposed to the instruction memory
    ****************/
    MU Memory(  MA,           // Memory address (from register)
                AC,           // Accumulator register, what gets written to memory
                MD,           // Memory contents outputs to  Memory Data register
                writeMemData, // wire that determines whether data will be read or written to the address
                clk);         // Clock 
    
    /*
    *   ALU
    */
    ALU alu(aluCom, // alu opcode
            AC,     // Input a, this redirects from accumulator register
            accum_in,   // input_b this is get from the value at the adsress from the instr
            c_out,  // Carry in is the carry out
            AC,     // Output, goes to accumulator register
            c_out); // Carry output
    
    
    
    always @ (posedge clk) begin // run on Clock cycle
        /* Get the opcode of the instruction */
        assign opcode = instr[15:13];
        
        /* Fetch value from memory referred to by the instrution*/

        //TODO
        
        /*Perform function on the value*/
        case (opcode)
            'b000: AC = !AC; // Invert accumulator
            'b001:           // add with carry
               begin
                    writeMemData = 0;
                    MA <= instr[0:11]; // Store the memory address from the instruction into the register
                    assign aluCom = 'b000;  // Feed add opcode into ALU
               end
            'b010:           // Jump if AC register > 0
                if (AC > 0) begin
                    // do nothing?
                end
                else begin
                    // check which addressing mode
                    if (AM) begin // if addressing mode = 1;
                        assign MA = IR;   // Store instruction register into memory address register
                        writeMemData = 0; // pull the contents from memory (should happen automatically)
                        PC <= MD;         // Set Program counter instruction 
                    end
                    else begin
                        PC <= IR;
                        reset <= 1;
                    end
                end
            'b011:      // Increment accumulator
                AC <= AC + 1;
            'b100:      // Store and clear AC register
            begin
                writeMemData = 0;  // set memory for reading
                MA <= instr[0:11]; // Store the memory address from the instruction into the register
                if (AM) begin      // if indirect addressing mode
                    
                end
            end
        endcase
    end
endmodule
