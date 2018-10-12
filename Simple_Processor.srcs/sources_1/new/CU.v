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
input [15:0] instr
    );
    
    reg [2:0] opcode; // Operation code for CPU, spans from instruction[13:15]
    reg AM; // Addressin moode, instr[12] 
    reg [12:0] address; // Address to get data value from, spans from instruction[0:11]
    
    reg [4:0] regEnable; // enable output for all registers
    
    /*
    *   Registers
    */
    reg[15:0] IR, MD, AC; // Instruction register, MD, Accumulator Register
    reg[11:0] MA;         // MA Register
    /********/
    reg[15:0] accum_in; // value referred to by address in the instruction
    wire c_out;
    reg[2:0] aluCom;
    
    ALU alu(aluCom, // alu opcode
            AC,     // Input a, this redirects from accumulator register
            accum_in,   // input_b this is get from the value at the adsress from the instr
            c_out,  // Carry in is the carry out
            AC,     // Output, goes to accumulator register
            c_out); // Carry output
    
    always @ instr begin // run on instr change
        /* Get the opcode of the instruction */
        assign opcode = instr[15:13];
        /* Fetch value from memory referred to by the instrution*/
        //TODO
        case (opcode)
            'b000: AC = !AC; // Invert accumulator
            'b001:           // add with carry
                assign aluCom = 'b000;  // Feed add opcode into ALU
                
        endcase
    end
endmodule
