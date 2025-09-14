`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:55:39 10/29/2024 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
    input [31:0] PC,
    input [1:0] nPC_sel,
    input zero,
    input Req,
    input eret,
    input [31:0] EPC,
    input [15:0] imm16,
    input [25:0] imm26,
    input [31:0] GRF,
    output [31:0] PCplus8,
    output [31:0] NPC
    );
    
    parameter PCPLUS4 = 2'b00,
              IMM16 = 2'b01,
              IMM26 = 2'b10,
              GRFconst = 2'b11;
    
    wire [31:0] sign_ext;
    wire [31:0] NPC_Req;
    wire [31:0] NPC_eret;
    wire [31:0] NPC_PCplus4;
    wire [31:0] NPC_imm16;
    wire [31:0] NPC_imm26;
    wire [31:0] NPC_GRF;

assign sign_ext = ({{16{imm16[15]}}, imm16} << 2);
assign NPC_Req = 32'h00004180;
assign NPC_eret = EPC;
assign NPC_PCplus4 = PC + 32'h00000004;
assign NPC_imm16 = PC + sign_ext;
assign NPC_imm26 = {PC[31:28], imm26, 2'b00};
assign NPC_GRF = GRF;

assign PCplus8 = PC + 32'h00000008;
assign NPC = (Req) ? NPC_Req :
             (eret && zero) ? NPC_eret :
             (nPC_sel == PCPLUS4) ? NPC_PCplus4 :
             (nPC_sel == IMM16 && zero) ? NPC_imm16 :
             (nPC_sel == IMM26 && zero) ? NPC_imm26 :
             (nPC_sel == GRFconst && zero) ? NPC_GRF :
             NPC_PCplus4;

endmodule
