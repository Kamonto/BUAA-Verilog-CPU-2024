`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:36:34 11/07/2024 
// Design Name: 
// Module Name:    DEreg 
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
module DEreg(
    input clk,
    input en,
    input reset,
    input clear,
    input Req,
    input [31:0] D_fixedRD1,
    input [31:0] D_fixedRD2,
    input [31:0] D_ext32,
    input [4:0] D_A3,
    input [31:0] D_PCplus8,
    input [31:0] D_pc,
    input [31:0] D_Instr,
    input [4:0] D_ExcCode,
    input D_BDIn,
    output [31:0] E_RD1,
    output [31:0] E_RD2,
    output [31:0] E_ext32,
    output [4:0] E_A3,
    output [31:0] E_PCplus8,
    output [31:0] E_pc,
    output [31:0] E_Instr,
    output [4:0] E_ExcCode,
    output E_BDIn,
    
    input [31:0] D_temp32,
    input [4:0] D_temp5,
    input D_temp1,
    output [31:0] E_temp32,
    output [4:0] E_temp5,
    output E_temp1
    );
    
    reg [31:0] DE_fixedRD1_reg;
    reg [31:0] DE_fixedRD2_reg;
    reg [31:0] DE_ext32_reg;
    reg [4:0] DE_A3_reg;
    reg [31:0] DE_PCplus8_reg;
    reg [31:0] DE_pc_reg;
    reg [31:0] DE_Instr_reg;
    reg [4:0] DE_ExcCode_reg;
    reg DE_BDIn_reg;
    
    reg [31:0] DE_temp32_reg;
    reg [4:0] DE_temp5_reg;
    reg DE_temp1_reg;

always@(posedge clk) begin
    if (reset | clear | Req) begin
        DE_fixedRD1_reg <= 32'h00000000;
        DE_fixedRD2_reg <= 32'h00000000;
        DE_ext32_reg <= 32'h00000000;
        DE_A3_reg <= 5'b00000;
        DE_PCplus8_reg <= 32'h00000000;
        DE_Instr_reg <= 32'h00000000;
        DE_pc_reg <= reset ? 32'h00000000 : Req ? 32'h00004180 : D_pc;
        DE_ExcCode_reg <= reset ? 5'b00000 : Req ? 5'b00000 : D_ExcCode;
        DE_BDIn_reg <= reset ? 1'b0 : Req ? 1'b0 : D_BDIn;
        
        DE_temp32_reg <= 32'h00000000;
        DE_temp5_reg <= 5'b00000;
        DE_temp1_reg <= 1'b0;
    end
    else begin
        if (en) begin
            DE_fixedRD1_reg <= D_fixedRD1;
            DE_fixedRD2_reg <= D_fixedRD2;
            DE_ext32_reg <= D_ext32;
            DE_A3_reg <= D_A3;
            DE_PCplus8_reg <= D_PCplus8;
            DE_pc_reg <= D_pc;
            DE_Instr_reg <= D_Instr;
            DE_ExcCode_reg <= D_ExcCode;
            DE_BDIn_reg <= D_BDIn;
            
            DE_temp32_reg <= D_temp32;
            DE_temp5_reg <= D_temp5;
            DE_temp1_reg <= D_temp1;
        end
    end
end

assign E_RD1 = DE_fixedRD1_reg;
assign E_RD2 = DE_fixedRD2_reg;
assign E_ext32 = DE_ext32_reg;
assign E_A3 = DE_A3_reg;
assign E_PCplus8 = DE_PCplus8_reg;
assign E_pc = DE_pc_reg;
assign E_Instr = DE_Instr_reg;
assign E_ExcCode = DE_ExcCode_reg;
assign E_BDIn = DE_BDIn_reg;

assign E_temp32 = DE_temp32_reg;
assign E_temp5 = DE_temp5_reg;
assign E_temp1 = DE_temp1_reg;

endmodule
