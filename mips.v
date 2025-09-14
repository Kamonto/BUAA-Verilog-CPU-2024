`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:19:25 10/29/2024 
// Design Name: 
// Module Name:    mips 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mips(
    input clk,
    input reset
    );
    
    // PC and NPC
    wire [31:0] pc;
    wire [31:0] npc;
    wire [31:0] pcplus4;
    
    //IM
    wire [31:0] Instr;
    wire [5:0] OpCode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] shamt;
    wire [5:0] Funct;
    wire [15:0] imm16;
    wire [25:0] imm26;
    
    //control
    wire RegDst;
    wire ALUSrc;
    wire MemtoReg;
    wire RegWrite;
    wire MemWrite;
    wire [1:0] nPC_sel;
    wire ExtOp;
    wire PCtoReg;
    wire Regra;
    wire [4:0] ALUctr;
    
    //GRF
    wire [4:0] A1;
    wire [4:0] A2;
    wire [4:0] A3;
    wire [31:0] WD_Reg;
    wire [31:0] RD1;
    wire [31:0] RD2;
    
    //EXT
    wire [31:0] ext32;
    
    //ALU
    wire [31:0] inputA;
    wire [31:0] inputB;
    wire [31:0] outputA;
    wire zero;
    
    //DM
    wire [31:0] addr;
    wire [31:0] WD_Mem;
    wire [31:0] data;
    
    PC PC (.clk(clk), .reset(reset), .inputPC(npc), .outputPC(pc));
    NPC NPC (.PC(pc), .nPC_sel(nPC_sel), .zero(zero), .imm16(imm16), 
             .imm26(imm26), .GRF(outputA), .PCplus4(pcplus4), .NPC(npc));
    IM IM (.addr(pc), .data(Instr));
    control control (.OpCode(OpCode), .Funct(Funct), .RegDst(RegDst),
                     .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite),
                     .MemWrite(MemWrite), .nPC_sel(nPC_sel), .ExtOp(ExtOp),
                     .PCtoReg(PCtoReg), .Regra(Regra), .ALUctr(ALUctr));
    GRF GRF (.clk(clk), .reset(reset), .WE(RegWrite), .A1(A1), .A2(A2),
             .A3(A3), .WD(WD_Reg), .PC(pc), .RD1(RD1), .RD2(RD2));
    EXT EXT (.imm16(imm16), .ExtOp(ExtOp), .ext32(ext32));
    ALU ALU (.inputA(inputA), .inputB(inputB), .type(ALUctr), .outputA(outputA),
             .zero(zero));
    DM DM (.clk(clk), .reset(reset), .WE(MemWrite), .addr(addr), .WD(WD_Mem),
           .PC(pc), .data(data));

    assign OpCode = Instr[31:26];
    assign rs = Instr[25:21];
    assign rt = Instr[20:16];
    assign rd = Instr[15:11];
    assign shamt = Instr[10:6];
    assign Funct = Instr[5:0];
    assign imm16 = Instr[15:0];
    assign imm26 = Instr[25:0];
    
    assign A1 = rs;
    assign A2 = rt;
    assign A3 = (Regra) ? 5'b11111 :
                (RegDst) ? rd : rt;
    assign WD_Reg = (PCtoReg) ? pcplus4 :
                    (MemtoReg) ? data : outputA;
    
    assign inputA = RD1;
    assign inputB = (ALUSrc) ? ext32 : RD2;
    
    assign addr = outputA;
    assign WD_Mem = RD2;
    
endmodule
