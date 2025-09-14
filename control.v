`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:26:09 10/29/2024 
// Design Name: 
// Module Name:    control 
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
module control(
    input [5:0] OpCode,
    input [5:0] Funct,
    output RegDst,
    output ALUSrc,
    output MemtoReg,
    output RegWrite,
    output MemWrite,
    output [1:0] nPC_sel,
    output ExtOp,
    output PCtoReg,
    output Regra,
    output [4:0] ALUctr
    );
    
    parameter ADD = 5'b00000,
              SUB = 5'b00001,
              ORI = 5'b00010,
              LW = 5'b00011,
              SW = 5'b00100,
              BEQ = 5'b00101,
              LUI = 5'b00110,
              JAL = 5'b00111,
              JR = 5'b01000,
              BNE = 5'b01001,
              J = 5'b01010,
              AND = 5'b01011,
              OR = 5'b01100;
    
    wire add;
    wire sub;
    wire ori;
    wire lw;
    wire sw;
    wire beq;
    wire lui;
    wire jal;
    wire jr;    
    wire bne;
    wire j;
    wire andf;
    wire orf;
    
              
assign add = (OpCode == 6'b000000 && Funct == 6'b100000) ? 1'b1 : 1'b0;
assign sub = (OpCode == 6'b000000 && Funct == 6'b100010) ? 1'b1 : 1'b0;
assign ori = (OpCode == 6'b001101) ? 1'b1 : 1'b0;
assign lw = (OpCode == 6'b100011) ? 1'b1 : 1'b0;
assign sw = (OpCode == 6'b101011) ? 1'b1 : 1'b0;
assign beq = (OpCode == 6'b000100) ? 1'b1 : 1'b0;
assign lui = (OpCode == 6'b001111) ? 1'b1 : 1'b0;
assign jal = (OpCode == 6'b000011) ? 1'b1 : 1'b0;
assign jr = (OpCode == 6'b000000 && Funct == 6'b001000) ? 1'b1 : 1'b0;
assign bne = (OpCode == 6'b000101) ? 1'b1 : 1'b0;
assign j = (OpCode == 6'b000010) ? 1'b1 : 1'b0;
assign andf = (OpCode == 6'b000000 && Funct == 6'b100100) ? 1'b1 : 1'b0;
assign orf = (OpCode == 6'b000000 && Funct == 6'b100101) ? 1'b1 : 1'b0;

assign RegDst = (add | sub | andf | orf) ? 1'b1 : 1'b0;
assign ALUSrc = (ori | lw | sw | lui) ? 1'b1 : 1'b0;
assign MemtoReg = (lw) ? 1'b1 : 1'b0;
assign RegWrite = (add | sub | ori | lw | lui | jal | andf | orf) ? 1'b1 : 1'b0;
assign MemWrite = (sw) ? 1'b1 : 1'b0;
assign nPC_sel = (beq | bne) ? 2'b01 :
                 (jal | j) ? 2'b10 :
                 (jr) ? 2'b11 : 2'b00;
assign ExtOp = (lw | sw) ? 1'b1 : 1'b0;
assign PCtoReg = (jal) ? 1'b1 : 1'b0;
assign Regra = (jal) ? 1'b1 : 1'b0;
assign ALUctr = (add) ? ADD :
                (sub) ? SUB :
                (ori) ? ORI :
                (lw) ? LW :
                (sw) ? SW :
                (beq) ? BEQ :
                (lui) ? LUI :
                (jal) ? JAL :
                (jr) ? JR :
                (bne) ? BNE :
                (j) ? J :
                (andf) ? AND :
                (orf) ? OR : 5'b11111;

endmodule
