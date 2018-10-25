`timescale 1ns / 1ps

module CPU();

/* ALU opcodes */
`define ALU_ADD 'b000       // ALU add
`define ALU_INVERT 'b001    // Invert AC
`define ALU_INCR 'b010      // Increment AC

reg [15:0] MD, AC;          // Instr Reg, Mem Dat, Accum Reg
reg [11:0] PC, MA;          // Prgm Count, Mem Addr reg
wire [15:0] IR;
wire [2:0] ALU_OP;           // ALU opcode
wire INSTR_ENABLE, 
     MEM_FETCH_ENABLE, 
     ALU_ENABLE,
     MEM_STORE_ENABLE,
     PC_ENABLE,
     WRITEBACK_ENABLE,
     FETCH_OPCODE; 
reg clk;                                      // System Clock
reg [2:0] opcode;                                    // operation code
wire [15:0] ALU_OUT;                                   // ALU output, assigns to AC
wire cin, cout;
CU CONTROL(
            clk,                // System clock
            opcode,             // Opcode
            ALU_OP,             // alu opcode
            ALU_ENABLE,         // Enable ALU?
            MEM_FETCH_ENABLE,   // Enable mem fetch?
            INSTR_ENABLE,       // Enable isntruction fetch?
            MEM_STORE_ENABLE,    // Store into mem?
            PC_ENABLE,          // incr pc
            WRITEBACK_ENABLE,    // write temp reg to accumulator
            FETCH_OPCODE         // Whether to fetch opcode from instruction
            );
ALU ALU_CTRL(
             clk,               // Clock
             ALU_OP,        // alu opcode
             AC,                // memory data register (input a)
             MD,                // Accumulator register (input b)
             cin,               // carry in
             ALU_ENABLE,        // alu enable
             ALU_OUT,           // alu result output
             cout               // carry out
             );         
InstrMem INSTR_MEMORY(
                      IR,
                      INSTR_ENABLE,
                      PC,
                      clk
                      );
                                   
always @ (posedge clk) begin

    if (PC_ENABLE) begin
        PC = PC + 1;
    end
    else if (WRITEBACK_ENABLE) begin
        AC <= ALU_OUT;
    end else if (FETCH_OPCODE) begin
        opcode <= IR[15:13];
    end
end 
            

initial begin
    AC = 0;
    MD = 0;
    PC = 0;
    clk = 0;
end

always begin
#5
clk = ~clk;
end
endmodule
