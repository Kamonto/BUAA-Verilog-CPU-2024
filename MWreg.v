`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:42:22 11/07/2024 
// Design Name: 
// Module Name:    MWreg 
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
module MWreg(
    input clk,
    input en,
    input reset,
    input clear,
    input Req,
    input [31:0] M_outputA,
    input [31:0] M_data,
    input [4:0] M_A3,
    input [31:0] M_PCplus8,
    input [31:0] M_pc,
    input [31:0] M_Instr,
    input [4:0] M_ExcCode,
    input M_BDIn,
    output [31:0] W_outputA,
    output [31:0] W_data,
    output [4:0] W_A3,
    output [31:0] W_PCplus8,
    output [31:0] W_pc,
    output [31:0] W_Instr,
    output [4:0] W_ExcCode,
    output W_BDIn,
    
    input [31:0] M_temp32,
    input [4:0] M_temp5,
    input M_temp1,
    output [31:0] W_temp32,
    output [4:0] W_temp5,
    output W_temp1
    );
    
    reg [31:0] MW_outputA_reg;
    reg [31:0] MW_data_reg;
    reg [4:0] MW_A3_reg;
    reg [31:0] MW_PCplus8_reg;
    reg [31:0] MW_pc_reg;
    reg [31:0] MW_Instr_reg;
    reg [4:0] MW_ExcCode_reg;
    reg MW_BDIn_reg;
    
    reg [31:0] MW_temp32_reg;
    reg [4:0] MW_temp5_reg;
    reg MW_temp1_reg;

always@(posedge clk) begin
    if (reset | clear | Req) begin
        MW_outputA_reg <= 32'h00000000;
        MW_data_reg <= 32'h00000000;
        MW_A3_reg <= 5'b00000;
        MW_PCplus8_reg <= 32'h00000000;
        MW_Instr_reg <= 32'h00000000;
        MW_pc_reg <= reset ? 32'h00000000 : Req ? 32'h00004180 : M_pc;
        MW_ExcCode_reg <= reset ? 5'b00000 : Req ? 5'b00000 : M_ExcCode;
        MW_BDIn_reg <= reset ? 1'b0 : Req ? 1'b0 : M_BDIn;
        
        MW_temp32_reg <= 32'h00000000;
        MW_temp5_reg <= 5'b00000;
        MW_temp1_reg <= 1'b0;
    end
    else begin
        if (en) begin
            MW_outputA_reg <= M_outputA;
            MW_data_reg <= M_data;
            MW_A3_reg <= M_A3;
            MW_PCplus8_reg <= M_PCplus8;
            MW_pc_reg <= M_pc;
            MW_Instr_reg <= M_Instr;
            MW_ExcCode_reg <= M_ExcCode;
            MW_BDIn_reg <= M_BDIn;
            
            MW_temp32_reg <= M_temp32;
            MW_temp5_reg <= M_temp5;
            MW_temp1_reg <= M_temp1;
        end
    end
end

assign W_outputA = MW_outputA_reg;
assign W_data = MW_data_reg;
assign W_A3 = MW_A3_reg;
assign W_PCplus8 = MW_PCplus8_reg;
assign W_pc = MW_pc_reg;
assign W_Instr = MW_Instr_reg;
assign W_ExcCode = MW_ExcCode_reg;
assign W_BDIn = MW_BDIn_reg;

assign W_temp32 = MW_temp32_reg;
assign W_temp5 = MW_temp5_reg;
assign W_temp1 = MW_temp1_reg;

endmodule
