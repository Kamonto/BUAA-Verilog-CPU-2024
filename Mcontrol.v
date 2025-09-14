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
    output MemWrite,
    output [4:0] ALUctr,
    output [3:0] rsTuse,
    output [3:0] rtTuse,
    output [3:0] Tnew
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
              OR = 5'b01100,
              NEWB = 5'b01101;
    
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
// assign newb

assign MemWrite = (sw) ? 1'b1 : 1'b0;
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
                (newb) ? NEWB : 5'b11111;

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
              (newb) ? 4'hf : 4'hf;
                
endmodule
