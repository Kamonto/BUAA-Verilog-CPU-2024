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
    input [5:0] type,
    output [31:0] outputA,
    output [4:0] ExcCode
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
              
    wire [31:0] adduAB;
    wire [31:0] subuAB;
    wire [31:0] andAB;
    wire [31:0] orAB;
    wire [31:0] sll16B;
    wire [31:0] sltAB;
    wire [31:0] sltuAB;
    wire [31:0] none;
    
    wire [32:0] add_overflow_temp;
    wire [32:0] sub_overflow_temp;
    wire overflow;

assign adduAB = (inputA + inputB);
assign subuAB = (inputA - inputB);
assign andAB = (inputA & inputB);
assign orAB = (inputA | inputB);
assign sll16B = (inputB << 16);
assign sltAB = ($signed(inputA) < $signed(inputB));
assign sltuAB = (inputA < inputB);
assign none = 32'h00000000;

assign add_overflow_temp = {inputA[31], inputA} + {inputB[31], inputB};
assign sub_overflow_temp = {inputA[31], inputA} - {inputB[31], inputB};
assign overflow = ((type == ADD || type == ADDI || type == LW || type == LH || type == LB || 
                    type == SW || type == SH || type == SB) && (add_overflow_temp[32] != add_overflow_temp[31])) ? 1'b1 : 
                  ((type == SUB) && (sub_overflow_temp[32] != sub_overflow_temp[31])) ? 1'b1 : 1'b0;

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
                 (type == MFCZ) ? none :
                 (type == MTCZ) ? none :
                 (type == NEWB) ? none : none;

assign ExcCode = (type == LW && adduAB[1:0] != 2'b00) ? 5'b00100 : 
                 
                 (type == LH && adduAB[0] != 1'b0) ? 5'b00100 : 
                 
                 (type == LW && !((adduAB >= 32'h00000000 && adduAB < 32'h00003000) || (adduAB >= 32'h00007f00 && adduAB < 32'h00007f0c) || 
                 (adduAB >= 32'h00007f10 && adduAB < 32'h00007f1c) || (adduAB >= 32'h00007f20 && adduAB < 32'h00007f24))) ? 5'b00100 : 
                 
                 ((type == LH || type == LB) && !((adduAB >= 32'h00000000 && adduAB < 32'h00003000) || 
                 (adduAB >= 32'h00007f20 && adduAB < 32'h00007f24))) ? 5'b00100 : 
                 
                 ((type == LW || type == LH || type == LB) && overflow) ? 5'b00100 : 
                 
                 (type == SW && adduAB[1:0] != 2'b00) ? 5'b00101 : 
                 
                 (type == SH && adduAB[0] != 1'b0) ? 5'b00101 : 
                 
                 (type == SW && !((adduAB >= 32'h00000000 && adduAB < 32'h00003000) || (adduAB >= 32'h00007f00 && adduAB < 32'h00007f08) || 
                 (adduAB >= 32'h00007f10 && adduAB < 32'h00007f18) || (adduAB >= 32'h00007f20 && adduAB < 32'h00007f24))) ? 5'b00101 : 
                 
                 ((type == SH || type == SB) && !((adduAB >= 32'h00000000 && adduAB < 32'h00003000) || 
                 (adduAB >= 32'h00007f20 && adduAB < 32'h00007f24))) ? 5'b00101 : 
                 
                 ((type == SW || type == SH || type == SB) && overflow) ? 5'b00101 : 
                 
                 ((type == ADD || type == SUB || type == ADDI) && overflow) ? 5'b01100 : 5'b00000;
                 
endmodule
