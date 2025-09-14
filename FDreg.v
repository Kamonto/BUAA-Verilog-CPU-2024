`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:08:30 11/07/2024 
// Design Name: 
// Module Name:    FDreg 
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
module FDreg(
    input clk,
    input en,
    input reset,
    input clear,
    input Req,
    input flush,
    input [31:0] F_PCplus8,
    input [31:0] F_pc,
    input [31:0] F_Instr,
    input [4:0] F_ExcCode,
    input F_BDIn,
    output [31:0] D_Instr,
    output [31:0] D_PCplus8,
    output [31:0] D_pc,
    output [4:0] D_ExcCode,
    output D_BDIn,
    
    input [31:0] F_temp32,
    input [4:0] F_temp5,
    input F_temp1,
    output [31:0] D_temp32,
    output [4:0] D_temp5,
    output D_temp1
    );
    
    reg [31:0] FD_Instr_reg;
    reg [31:0] FD_PCplus8_reg;
    reg [31:0] FD_pc_reg;
    reg [4:0] FD_ExcCode_reg;
    reg FD_BDIn_reg;
    
    reg [31:0] FD_temp32_reg;
    reg [4:0] FD_temp5_reg;
    reg FD_temp1_reg;

always@(posedge clk) begin
    if (reset | clear | Req | flush) begin
        FD_Instr_reg <= 32'h00000000;
        FD_PCplus8_reg <= 32'h00000000;
        FD_pc_reg <= reset ? 32'h00000000 : Req ? 32'h00004180 : clear ? F_pc : FD_pc_reg;
        FD_ExcCode_reg <= reset ? 5'b00000 : Req ? 5'b00000 : clear ? F_ExcCode : FD_ExcCode_reg;
        FD_BDIn_reg <= reset ? 1'b0 : Req ? 1'b0 : clear ? F_BDIn : FD_BDIn_reg;
        
        FD_temp32_reg <= 32'h00000000;
        FD_temp5_reg <= 5'b00000;
        FD_temp1_reg <= 1'b0;
    end
    else begin
        if (en) begin
            FD_Instr_reg <= F_Instr;
            FD_PCplus8_reg <= F_PCplus8;
            FD_pc_reg <= F_pc;
            FD_ExcCode_reg <= F_ExcCode;
            FD_BDIn_reg <= F_BDIn;
            
            FD_temp32_reg <= F_temp32;
            FD_temp5_reg <= F_temp5;
            FD_temp1_reg <= F_temp1;
        end
    end
end

assign D_Instr = FD_Instr_reg;
assign D_PCplus8 = FD_PCplus8_reg;
assign D_pc = FD_pc_reg;
assign D_ExcCode = FD_ExcCode_reg;
assign D_BDIn = FD_BDIn_reg;

assign D_temp32 = FD_temp32_reg;
assign D_temp5 = FD_temp5_reg;
assign D_temp1 = FD_temp1_reg;

endmodule
