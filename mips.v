`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:19:25 10/29/2024 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset,
    input interrupt,
    input [31:0] i_inst_rdata,
    input [31:0] m_data_rdata,
    output [31:0] macroscopic_pc,
    output [31:0] i_inst_addr,
    output [31:0] m_data_addr,
    output [31:0] m_data_wdata,
    output [3:0] m_data_byteen,
    output [31:0] m_int_addr,
    output [3:0] m_int_byteen,
    output [31:0] m_inst_addr,
    output w_grf_we,
    output [4:0] w_grf_addr,
    output [31:0] w_grf_wdata,
    output [31:0] w_inst_addr
    );
    
    wire [5:0] ori_HWInt;
    wire [31:0] ori_i_inst_rdata;
    wire [31:0] ori_m_data_rdata;
    wire [31:0] ori_i_inst_addr;
    wire [31:0] ori_m_data_addr;
    wire [31:0] ori_m_data_wdata;
    wire [3:0] ori_m_data_byteen;
    wire [31:0] ori_m_inst_addr;
    wire ori_w_grf_we;
    wire [4:0] ori_w_grf_addr;
    wire [31:0] ori_w_grf_wdata;
    wire [31:0] ori_w_inst_addr;
    wire [31:0] ori_macroscopic_pc;
    
    wire [31:2] t0_Addr;
    wire t0_WE;
    wire [31:0] t0_Din;
    wire [31:0] t0_Dout;
    wire t0_IRQ;
    
    wire [31:2] t1_Addr;
    wire t1_WE;
    wire [31:0] t1_Din;
    wire [31:0] t1_Dout;
    wire t1_IRQ;
    
    Orimips Orimips (
        .clk(clk),
        .reset(reset),
        .HWInt(ori_HWInt),
        .i_inst_rdata(ori_i_inst_rdata),
        .m_data_rdata(ori_m_data_rdata),
        .i_inst_addr(ori_i_inst_addr),
        .m_data_addr(ori_m_data_addr),
        .m_data_wdata(ori_m_data_wdata),
        .m_data_byteen(ori_m_data_byteen),
        .m_inst_addr(ori_m_inst_addr),
        .w_grf_we(ori_w_grf_we),
        .w_grf_addr(ori_w_grf_addr),
        .w_grf_wdata(ori_w_grf_wdata),
        .w_inst_addr(ori_w_inst_addr),
        .macroscopic_pc(ori_macroscopic_pc)
    );
    
    Bridge Bridge (
        .orimips_HWInt(ori_HWInt),
        .orimips_i_inst_rdata(ori_i_inst_rdata),
        .orimips_m_data_rdata(ori_m_data_rdata),
        .orimips_i_inst_addr(ori_i_inst_addr),
        .orimips_m_data_addr(ori_m_data_addr),
        .orimips_m_data_wdata(ori_m_data_wdata),
        .orimips_m_data_byteen(ori_m_data_byteen),
        .orimips_m_inst_addr(ori_m_inst_addr),
        .orimips_w_grf_we(ori_w_grf_we),
        .orimips_w_grf_addr(ori_w_grf_addr),
        .orimips_w_grf_wdata(ori_w_grf_wdata),
        .orimips_w_inst_addr(ori_w_inst_addr),
        .orimips_macroscopic_pc(ori_macroscopic_pc),
 
        .mips_interrupt(interrupt),
        .mips_i_inst_rdata(i_inst_rdata),
        .mips_m_data_rdata(m_data_rdata),
        .mips_macroscopic_pc(macroscopic_pc),
        .mips_i_inst_addr(i_inst_addr),
        .mips_m_data_addr(m_data_addr),
        .mips_m_data_wdata(m_data_wdata),
        .mips_m_data_byteen(m_data_byteen),
        .mips_m_int_addr(m_int_addr),
        .mips_m_int_byteen(m_int_byteen),
        .mips_m_inst_addr(m_inst_addr),
        .mips_w_grf_we(w_grf_we),
        .mips_w_grf_addr(w_grf_addr),
        .mips_w_grf_wdata(w_grf_wdata),
        .mips_w_inst_addr(w_inst_addr),
 
        .timer0_Addr(t0_Addr),
        .timer0_WE(t0_WE),
        .timer0_Din(t0_Din),
        .timer0_Dout(t0_Dout),
        .timer0_IRQ(t0_IRQ),
 
        .timer1_Addr(t1_Addr),
        .timer1_WE(t1_WE),
        .timer1_Din(t1_Din),
        .timer1_Dout(t1_Dout),
        .timer1_IRQ(t1_IRQ)
    );
    
    TC Timer0 (
        .clk(clk),
        .reset(reset),
        .Addr(t0_Addr),
        .WE(t0_WE),
        .Din(t0_Din),
        .Dout(t0_Dout),
        .IRQ(t0_IRQ)
    );
    
    TC Timer1 (
        .clk(clk),
        .reset(reset),
        .Addr(t1_Addr),
        .WE(t1_WE),
        .Din(t1_Din),
        .Dout(t1_Dout),
        .IRQ(t1_IRQ)
    );

endmodule
