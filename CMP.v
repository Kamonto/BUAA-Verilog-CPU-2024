`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:32:49 11/07/2024 
// Design Name: 
// Module Name:    CMP 
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
module CMP(
    input [5:0] D_type,
    input [31:0] D_fixedRD1,
    input [31:0] D_fixedRD2,
    output D_zero,
    output D_flush
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

assign D_zero = ((D_type == BEQ) && (D_fixedRD1 == D_fixedRD2)) ? 1'b1 :
                ((D_type == BNE) && (D_fixedRD1 != D_fixedRD2)) ? 1'b1 :
                (D_type == JAL) ? 1'b1 :
                (D_type == JR) ? 1'b1 :
                (D_type == J) ? 1'b1 :
                (D_type == ERET) ? 1'b1 : 1'b0;

assign D_flush = (D_type == ERET) ? 1'b1 : 1'b0;

endmodule
