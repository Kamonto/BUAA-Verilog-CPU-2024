`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:03:44 11/07/2024 
// Design Name: 
// Module Name:    Mcontrol 
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
module Mcontrol(
    input [5:0] OpCode,
    input [5:0] Funct,
    input [4:0] rs,
    output cpzfix, 
    output cpzWrite, 
    output [5:0] ALUctr,
    output [3:0] rsTuse,
    output [3:0] rtTuse,
    output [3:0] Tnew
    );
    
    parameter ADD = 6'b000000,
              SUB = 6'b000001,
              ORI = 6'b000010,
              LW = 6'b000011,
              SW = 6'b000100,
              BEQ = 6'b000101,
              LUI = 6'b000110,
              JAL = 6'b000111,
              JR = 6'b001000,
              BNE = 6'b001001,
              J = 6'b001010,
              AND = 6'b001011,
              OR = 6'b001100,
              SLT = 6'b001101,
              SLTU = 6'b001110,
              ADDI = 6'b001111,
              ANDI = 6'b010000,
              LB = 6'b010001,
              LH = 6'b010010,
              SB = 6'b010011,
              SH = 6'b010100,
              MULT = 6'b010101,
              MULTU = 6'b010110,
              DIV = 6'b010111,
              DIVU = 6'b011000,
              MFHI = 6'b011001,
              MFLO = 6'b011010,
              MTHI = 6'b011011,
              MTLO = 6'b011100,
              MFCZ = 6'b011101,
              MTCZ = 6'b011110,
              SYS = 6'b011111,
              ERET = 6'b100000,
              NEWB = 6'b100001;
    
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
    wire slt;
    wire sltu;
    wire addi;
    wire andi;
    wire lb;
    wire lh;
    wire sb;
    wire sh;
    wire mult;
    wire multu;
    wire div;
    wire divu;
    wire mfhi;
    wire mflo;
    wire mthi;
    wire mtlo;
    wire mfcz;
    wire mtcz;
    wire sys;
    wire eret;
    wire newb;
    
              
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
assign slt = (OpCode == 6'b000000 && Funct == 6'b101010) ? 1'b1 : 1'b0;
assign sltu = (OpCode == 6'b000000 && Funct == 6'b101011) ? 1'b1 : 1'b0;
assign addi = (OpCode == 6'b001000) ? 1'b1 : 1'b0;
assign andi = (OpCode == 6'b001100) ? 1'b1 : 1'b0;
assign lb = (OpCode == 6'b100000) ? 1'b1 : 1'b0;
assign lh = (OpCode == 6'b100001) ? 1'b1 : 1'b0;
assign sb = (OpCode == 6'b101000) ? 1'b1 : 1'b0;
assign sh = (OpCode == 6'b101001) ? 1'b1 : 1'b0;
assign mult = (OpCode == 6'b000000 && Funct == 6'b011000) ? 1'b1 : 1'b0;
assign multu = (OpCode == 6'b000000 && Funct == 6'b011001) ? 1'b1 : 1'b0;
assign div = (OpCode == 6'b000000 && Funct == 6'b011010) ? 1'b1 : 1'b0;
assign divu = (OpCode == 6'b000000 && Funct == 6'b011011) ? 1'b1 : 1'b0;
assign mfhi = (OpCode == 6'b000000 && Funct == 6'b010000) ? 1'b1 : 1'b0;
assign mflo = (OpCode == 6'b000000 && Funct == 6'b010010) ? 1'b1 : 1'b0;
assign mthi = (OpCode == 6'b000000 && Funct == 6'b010001) ? 1'b1 : 1'b0;
assign mtlo = (OpCode == 6'b000000 && Funct == 6'b010011) ? 1'b1 : 1'b0;
assign mfcz = (OpCode == 6'b010000 && rs == 5'b00000) ? 1'b1 : 1'b0;
assign mtcz = (OpCode == 6'b010000 && rs == 5'b00100) ? 1'b1 : 1'b0;
assign sys = (OpCode == 6'b000000 && Funct == 6'b001100) ? 1'b1 : 1'b0;
assign eret = (OpCode == 6'b010000 && Funct == 6'b011000) ? 1'b1 : 1'b0;
// assign newb

assign cpzfix = (mfcz) ? 1'b1 : 1'b0;
assign cpzWrite = (mtcz) ? 1'b1 : 1'b0;
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
                (orf) ? OR : 
                (slt) ? SLT :
                (sltu) ? SLTU :
                (addi) ? ADDI :
                (andi) ? ANDI :
                (lb) ? LB :
                (lh) ? LH :
                (sb) ? SB :
                (sh) ? SH :
                (mult) ? MULT :
                (multu) ? MULTU :
                (div) ? DIV :
                (divu) ? DIVU :
                (mfhi) ? MFHI :
                (mflo) ? MFLO :
                (mthi) ? MTHI :
                (mtlo) ? MTLO :
                (mfcz) ? MFCZ :
                (mtcz) ? MTCZ :
                (sys) ? SYS :
                (eret) ? ERET :
                // (newb) ? NEWB : 
                6'b111111;

assign rsTuse = (add) ? 4'h1 :
                (sub) ? 4'h1 :
                (ori) ? 4'h1 :
                (lw) ? 4'h1 :
                (sw) ? 4'h1 :
                (beq) ? 4'h0 :
                (lui) ? 4'hf :
                (jal) ? 4'hf :
                (jr) ? 4'h0 :
                (bne) ? 4'h0 :
                (j) ? 4'hf :
                (andf) ? 4'h1 :
                (orf) ? 4'h1 : 
                (slt) ? 4'h1 :
                (sltu) ? 4'h1 :
                (addi) ? 4'h1 :
                (andi) ? 4'h1 :
                (lb) ? 4'h1 :
                (lh) ? 4'h1 :
                (sb) ? 4'h1 :
                (sh) ? 4'h1 :
                (mult) ? 4'h1 :
                (multu) ? 4'h1 :
                (div) ? 4'h1 :
                (divu) ? 4'h1 :
                (mfhi) ? 4'hf :
                (mflo) ? 4'hf :
                (mthi) ? 4'h1 :
                (mtlo) ? 4'h1 :
                (mfcz) ? 4'hf :
                (mtcz) ? 4'hf :
                (sys) ? 4'hf :
                (eret) ? 4'hf :
                (newb) ? 4'hf : 4'hf;
                
assign rtTuse = (add) ? 4'h1 :
                (sub) ? 4'h1 :
                (ori) ? 4'hf :
                (lw) ? 4'hf :
                (sw) ? 4'h2 :
                (beq) ? 4'h0 :
                (lui) ? 4'hf :
                (jal) ? 4'hf :
                (jr) ? 4'hf :
                (bne) ? 4'h0 :
                (j) ? 4'hf :
                (andf) ? 4'h1 :
                (orf) ? 4'h1 : 
                (slt) ? 4'h1 :
                (sltu) ? 4'h1 :
                (addi) ? 4'hf :
                (andi) ? 4'hf :
                (lb) ? 4'hf :
                (lh) ? 4'hf :
                (sb) ? 4'h2 :
                (sh) ? 4'h2 :
                (mult) ? 4'h1 :
                (multu) ? 4'h1 :
                (div) ? 4'h1 :
                (divu) ? 4'h1 :
                (mfhi) ? 4'hf :
                (mflo) ? 4'hf :
                (mthi) ? 4'hf :
                (mtlo) ? 4'hf :
                (mfcz) ? 4'hf :
                (mtcz) ? 4'h2 :
                (sys) ? 4'hf :
                (eret) ? 4'hf :
                (newb) ? 4'hf : 4'hf;

assign Tnew = (add) ? 4'h0 :
              (sub) ? 4'h0 :
              (ori) ? 4'h0 :
              (lw) ? 4'h1 :
              (sw) ? 4'hf :
              (beq) ? 4'hf :
              (lui) ? 4'h0 :
              (jal) ? 4'h0 :
              (jr) ? 4'hf :
              (bne) ? 4'hf :
              (j) ? 4'hf :
              (andf) ? 4'h0 :
              (orf) ? 4'h0 : 
              (slt) ? 4'h0 :
              (sltu) ? 4'h0 :
              (addi) ? 4'h0 :
              (andi) ? 4'h0 :
              (lb) ? 4'h1 :
              (lh) ? 4'h1 :
              (sb) ? 4'hf :
              (sh) ? 4'hf :
              (mult) ? 4'hf :
              (multu) ? 4'hf :
              (div) ? 4'hf :
              (divu) ? 4'hf :
              (mfhi) ? 4'h0 :
              (mflo) ? 4'h0 :
              (mthi) ? 4'hf :
              (mtlo) ? 4'hf :
              (mfcz) ? 4'h1 :
              (mtcz) ? 4'hf :
              (sys) ? 4'hf :
              (eret) ? 4'hf :
              (newb) ? 4'hf : 4'hf;
                
endmodule
