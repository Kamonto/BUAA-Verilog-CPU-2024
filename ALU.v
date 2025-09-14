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
    output [31:0] outputA,
    output zero
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
              
    wire [31:0] adduAB;
    wire [31:0] subuAB;
    wire [31:0] andAB;
    wire [31:0] orAB;
    wire [31:0] sll16B;
    wire [31:0] none;

assign adduAB = (inputA + inputB);
assign subuAB = (inputA - inputB);
assign andAB = (inputA & inputB);
assign orAB = (inputA | inputB);
assign sll16B = (inputB << 16);
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
                 (type == OR) ? orAB : none;
                
assign zero = ((type == BEQ) && (inputA == inputB)) ? 1'b1 :
              ((type == BNE) && (inputA != inputB)) ? 1'b1 :
              (type == JAL) ? 1'b1 :
              (type == JR) ? 1'b1 :
              (type == J) ? 1'b1 : 1'b0;

endmodule
