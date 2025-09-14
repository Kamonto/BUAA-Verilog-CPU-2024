`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:13:48 11/07/2024 
// Design Name: 
// Module Name:    EMreg 
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
module EMreg(
    input clk,
    input en,
    input reset,
    input clear,
    input Req,
    input [31:0] E_outputA,
    input [31:0] E_fixedRD2,
    input [4:0] E_A3,
    input [31:0] E_PCplus8,
    input [31:0] E_pc,
    input [31:0] E_Instr,
    input [4:0] E_ExcCode,
    input E_BDIn,
    output [31:0] M_outputA,
    output [31:0] M_RD2,
    output [4:0] M_A3,
    output [31:0] M_PCplus8,
    output [31:0] M_pc,
    output [31:0] M_Instr,
    output [4:0] M_ExcCode,
    output M_BDIn,
    
    input [31:0] E_temp32,
    input [4:0] E_temp5,
    input E_temp1,
    output [31:0] M_temp32,
    output [4:0] M_temp5,
    output M_temp1
    );
    
    reg [31:0] EM_outputA_reg;
    reg [31:0] EM_fixedRD2_reg;
    reg [4:0] EM_A3_reg;
    reg [31:0] EM_PCplus8_reg;
    reg [31:0] EM_pc_reg;
    reg [31:0] EM_Instr_reg;
    reg [4:0] EM_ExcCode_reg;
    reg EM_BDIn_reg;
    
    reg [31:0] EM_temp32_reg;
    reg [4:0] EM_temp5_reg;
    reg EM_temp1_reg;

always@(posedge clk) begin
    if (reset | clear | Req) begin
        EM_outputA_reg <= 32'h00000000;
        EM_fixedRD2_reg <= 32'h00000000;
        EM_A3_reg <= 5'b00000;
        EM_PCplus8_reg <= 32'h00000000;
        EM_Instr_reg <= 32'h00000000;
        EM_pc_reg <= reset ? 32'h00000000 : Req ? 32'h00004180 : E_pc;
        EM_ExcCode_reg <= reset ? 5'b00000 : Req ? 5'b00000 : E_ExcCode;
        EM_BDIn_reg <= reset ? 1'b0 : Req ? 1'b0 : E_BDIn;
        
        EM_temp32_reg <= 32'h00000000;
        EM_temp5_reg <= 5'b00000;
        EM_temp1_reg <= 1'b0;
    end
    else begin
        if (en) begin
            EM_outputA_reg <= E_outputA;
            EM_fixedRD2_reg <= E_fixedRD2;
            EM_A3_reg <= E_A3;
            EM_PCplus8_reg <= E_PCplus8;
            EM_pc_reg <= E_pc;
            EM_Instr_reg <= E_Instr;
            EM_ExcCode_reg <= E_ExcCode;
            EM_BDIn_reg <= E_BDIn;
            
            EM_temp32_reg <= E_temp32;
            EM_temp5_reg <= E_temp5;
            EM_temp1_reg <= E_temp1;
        end
    end
end

assign M_outputA = EM_outputA_reg;
assign M_RD2 = EM_fixedRD2_reg;
assign M_A3 = EM_A3_reg;
assign M_PCplus8 = EM_PCplus8_reg;
assign M_pc = EM_pc_reg;
assign M_Instr = EM_Instr_reg;
assign M_ExcCode = EM_ExcCode_reg;
assign M_BDIn = EM_BDIn_reg;

assign M_temp32 = EM_temp32_reg;
assign M_temp5 = EM_temp5_reg;
assign M_temp1 = EM_temp1_reg;

endmodule
