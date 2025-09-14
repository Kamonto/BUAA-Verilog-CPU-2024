`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:59 10/29/2024 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] inputA,
    input [31:0] inputB,
    input [4:0] type,
    output [31:0] outputA
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
              SLT = 5'b01101,
              SLTU = 5'b01110,
              ADDI = 5'b01111,
              ANDI = 5'b10000,
              LB = 5'b10001,
              LH = 5'b10010,
              SB = 5'b10011,
              SH = 5'b10100,
              MULT = 5'b10101,
              MULTU = 5'b10110,
              DIV = 5'b10111,
              DIVU = 5'b11000,
              MFHI = 5'b11001,
              MFLO = 5'b11010,
              MTHI = 5'b11011,
              MTLO = 5'b11100,
              NEWB = 5'b11101;
              
    wire [31:0] adduAB;
    wire [31:0] subuAB;
    wire [31:0] andAB;
    wire [31:0] orAB;
    wire [31:0] sll16B;
    wire [31:0] sltAB;
    wire [31:0] sltuAB;
    wire [31:0] none;

assign adduAB = (inputA + inputB);
assign subuAB = (inputA - inputB);
assign andAB = (inputA & inputB);
assign orAB = (inputA | inputB);
assign sll16B = (inputB << 16);
assign sltAB = ($signed(inputA) < $signed(inputB));
assign sltuAB = (inputA < inputB);
assign none = 32'h00000000;

assign outputA = (type == ADD) ? adduAB :
                 (type == SUB) ? subuAB :
                 (type == ORI) ? orAB :
                 (type == LW) ? adduAB :
                 (type == SW) ? adduAB :
                 (type == BEQ) ? none :
                 (type == LUI) ? sll16B :
                 (type == JAL) ? none :
                 (type == JR) ? inputA :
                 (type == BNE) ? none :
                 (type == J) ? none :
                 (type == AND) ? andAB :
                 (type == OR) ? orAB : 
                 (type == SLT) ? sltAB : 
                 (type == SLTU) ? sltuAB : 
                 (type == ADDI) ? adduAB : 
                 (type == ANDI) ? andAB : 
                 (type == LB) ? adduAB : 
                 (type == LH) ? adduAB : 
                 (type == SB) ? adduAB : 
                 (type == SH) ? adduAB : 
                 (type == MULT) ? none : 
                 (type == MULTU) ? none : 
                 (type == DIV) ? none : 
                 (type == DIVU) ? none : 
                 (type == MFHI) ? none : 
                 (type == MFLO) ? none : 
                 (type == MTHI) ? none : 
                 (type == MTLO) ? none : 
                 (type == NEWB) ? none : none;

endmodule
