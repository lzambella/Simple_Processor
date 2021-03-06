`timescale 1ns / 1ps

module CPU();

/* ALU opcodes */
`define ALU_ADD 'b000       // ALU add
`define ALU_INVERT 'b001    // Invert AC
`define ALU_INCR 'b010      // Increment AC

reg [15:0] AC;          // Instr Reg, Mem Dat, Accum Reg
reg [11:0] PC;              // Prgm Count
wire [11:0] MA;             // Mem addr never gets assigned directly, always from IR
wire [15:0] IR;
wire [15:0] MD;             // mem data is never directly assigned
wire [2:0] ALU_OP;           // ALU opcode
wire INSTR_ENABLE, 
     MEM_FETCH_ENABLE, 
     ALU_ENABLE,
     MEM_STORE_ENABLE,
     PC_ENABLE,
     WRITEBACK_ENABLE,
     FETCH_OPCODE,
     JUMP_AC_DIRECT,
     JUMP,
     ADDRESS_MODE;              // Jump state 
reg clk;                                      // System Clock
reg [3:0] opcode;                                    // operation code
wire [15:0] ALU_OUT;                                   // ALU output, assigns to AC
wire cin, cout;
CU CONTROL(
            clk,                // System clock
            opcode,             // Opcode
            AC,                 // accumulator input
            ALU_OP,             // alu opcode
            ALU_ENABLE,         // Enable ALU?
            MEM_FETCH_ENABLE,   // Enable mem fetch?
            INSTR_ENABLE,       // Enable isntruction fetch?
            MEM_STORE_ENABLE,    // Store into mem?
            PC_ENABLE,          // incr pc
            WRITEBACK_ENABLE,    // write temp reg to accumulator
            FETCH_OPCODE,         // Whether to fetch opcode from instruction
            ADDRESS_MODE,      // Addressing mode
            JUMP                // Jump state
            );
            
ALU ALU_CTRL(
             clk,               // Clock
             ALU_OP,            // alu opcode
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

MU MEMORY_UNIT(
                .clk(clk),
                .Addr(MA),
                .WriteData(AC),
                .enable(MEM_FETCH_ENABLE),
                .WD(0),
                .ReadData(MD)
                );
                                                   
always @ (posedge clk) begin

    if (PC_ENABLE) begin
        PC = PC + 1;
    end
    else if (WRITEBACK_ENABLE) begin
        AC = ALU_OUT;
    end else if (FETCH_OPCODE) begin
        opcode = IR[15:12];
    
    /* If jump enabled */
    end else if (JUMP) begin
        if (ADDRESS_MODE) begin
        /*  MA gets data read at memory location (this already happens by default so PC gets MD) */
            PC <= MD;
        end else begin
        /* PC gets MA */
            PC <= MA;       // This case MA is not the memory address but the PC value we want
        end
    end
end 

assign MA = IR[11:0];           // Mem Addr reg always gets address referred to by IR            

initial begin
    AC = 0;
    PC = 0;
    clk = 0;
end

always begin
#5
clk = ~clk;
end
endmodule
