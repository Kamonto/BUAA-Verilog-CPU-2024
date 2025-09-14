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
    input [4:0] D_type,
    input [31:0] D_fixedRD1,
    input [31:0] D_fixedRD2,
    output D_zero,
    output D_flush
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

assign D_zero = ((D_type == BEQ) && (D_fixedRD1 == D_fixedRD2)) ? 1'b1 :
                ((D_type == BNE) && (D_fixedRD1 != D_fixedRD2)) ? 1'b1 :
                (D_type == JAL) ? 1'b1 :
                (D_type == JR) ? 1'b1 :
                (D_type == J) ? 1'b1 : 1'b0;

assign D_flush = 1'b0; //((D_type == BEQ) && (D_fixedRD1 != D_fixedRD2)) ? 1'b1 : 1'b0;

endmodule
