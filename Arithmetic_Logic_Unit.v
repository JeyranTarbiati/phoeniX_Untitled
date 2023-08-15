/*
    RV32IMF Core - Arithmetic Logic Unit
    - This unit executes R-Type and I-Type instructions
    - Inputs bus_rs1, bus_rs2 comes from Register_File
    - Input immediate comes from Immediate_Generator
    - Inputs forward_exe_rs1, forward_exe_rs2 comes from the execution-unit output (bypassed)
    - Input signals opcode, funct3, funct7, comes from Instruction_Decoder
    - Input signals mux1_select, mux2_select comes from Control_Unit
    - Supported Instructions :

        I-TYPE : ADDI - SLTI - SLTIU     R-TYPE : ADD  - SUB  - SLL           
                 XORI - ORI  - ANDI               SLT  - SLTU - XOR                         
                 SLLI - SRLI - SRAI               SRL  - SRA  - OR  - AND                             
*/
module Arithmetic_Logic_Unit 
(
    input [6 : 0] opcode,               // ALU Operation
    input [2 : 0] funct3,               // ALU Operation
    input [6 : 0] funct7,               // ALU Operation
    
    input [1 : 0] mux1_select,          // Bypass Mux for operand_1
    input [2 : 0] mux2_select,          // Bypass Mux for operand_2

    input [31 : 0] PC,                  // Program Counter Register
    input [31 : 0] bus_rs1,             // Register Source 1
    input [31 : 0] bus_rs2,             // Register Source 2
    input [31 : 0] immediate,           // Immediate Source
    input [31 : 0] forward_exe_rs1,     // Forwarded Data 1 from execution stage
    input [31 : 0] forward_exe_rs2,     // Forwarded Data 2 from execution stage
    input [31 : 0] forward_mem_rs1,     // Forwarded Data 1 from memory stage
    input [31 : 0] forward_mem_rs2,     // Forwarded Data 2 from memory stage

    output reg [31 : 0] alu_output      // ALU Result
);

    reg [31 : 0] operand_1;
    reg [31 : 0] operand_2;

    // Bypassing (Data Forwarding) Multiplexer 1
    always @(*) begin
        case (mux1_select)
            2'b00 : operand_1 = bus_rs1;
            2'b01 : operand_1 = forward_exe_rs1;
            2'b10 : operand_1 = PC;
            2'b11 : operand_1 = forward_mem_rs1;
        endcase
    end
    // Bypassing (Data Forwarding) Multiplexer 2
    always @(*) begin
        case (mux2_select)
            3'b000 : operand_2 = bus_rs2;
            3'b001 : operand_2 = forward_exe_rs2;
            3'b010 : operand_2 = immediate;
            3'b011 : operand_2 = 32'd4;
            3'b100 : operand_2 = forward_mem_rs2;
        endcase
    end

    always @(*)
    begin
        casex ({funct7, funct3, opcode})
            // I-TYPE Intructions
            17'bxxxxxxx_000_0010011 : alu_output = operand_1 + operand_2;                           // ADDI
            17'bxxxxxxx_010_0010011 : alu_output = $signed(operand_1) < $signed(operand_2) ? 1 : 0; // SLTI
            17'bxxxxxxx_011_0010011 : alu_output = operand_1 < operand_2 ? 1 : 0;                   // SLTIU
            17'bxxxxxxx_100_0010011 : alu_output = operand_1 ^ operand_2;                           // XORI
            17'bxxxxxxx_110_0010011 : alu_output = operand_1 | operand_2;                           // ORI
            17'bxxxxxxx_111_0010011 : alu_output = operand_1 & operand_2;                           // ANDI
            17'b0000000_001_0010011 : alu_output = operand_1 << operand_2 [4 : 0];                  // SLLI
            17'b0000000_101_0010011 : alu_output = operand_1 >> operand_2 [4 : 0];                  // SRLI
            17'b0100000_101_0010011 : alu_output = operand_1 >> $signed(operand_2 [4 : 0]);         // SRAI

            // R-TYPE Instructions
            17'b0000000_000_0110011 : alu_output = operand_1 + operand_2;                           // ADD
            17'b0100000_000_0110011 : alu_output = operand_1 - operand_2;                           // SUB
            17'b0000000_001_0110011 : alu_output = operand_1 << operand_2;                          // SLL
            17'b0000000_010_0110011 : alu_output = $signed(operand_1) < $signed(operand_2) ? 1 : 0; // SLT
            17'b0000000_011_0110011 : alu_output = operand_1 < operand_2 ? 1 : 0;                   // SLTU
            17'b0000000_100_0110011 : alu_output = operand_1 ^ operand_2;                           // XOR
            17'b0000000_101_0110011 : alu_output = operand_1 >> operand_2;                          // SRL
            17'b0100000_101_0110011 : alu_output = operand_1 >> $signed(operand_2);                 // SRA
            17'b0000000_110_0110011 : alu_output = operand_1 | operand_2;                           // OR
            17'b0000000_111_0110011 : alu_output = operand_1 & operand_2;                           // AND

            // JAL and JALR Instructions
            17'bxxxxxxx_xxx_1101111 : alu_output = operand_1 + operand_2;                           // JAL
            17'bxxxxxxx_000_1100111 : alu_output = operand_1 + operand_2;                           // JALR
            
            // AUIPC Instruction
            17'bxxxxxxx_xxx_0010011 : alu_output = operand_1 + operand_2;                           // AUIPC
            default: alu_output = 32'bz; 
        endcase
    end
    
endmodule