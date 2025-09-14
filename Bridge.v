`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:24:49 12/05/2024 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
    // attach Orimips
    output [5:0] orimips_HWInt,
    output [31:0] orimips_i_inst_rdata,
    output [31:0] orimips_m_data_rdata,
    input [31:0] orimips_i_inst_addr,
    input [31:0] orimips_m_data_addr,
    input [31:0] orimips_m_data_wdata,
    input [3:0] orimips_m_data_byteen,
    input [31:0] orimips_m_inst_addr,
    input orimips_w_grf_we,
    input [4:0] orimips_w_grf_addr,
    input [31:0] orimips_w_grf_wdata,
    input [31:0] orimips_w_inst_addr,
    input [31:0] orimips_macroscopic_pc,

    // attach mips
    input mips_interrupt,
    input [31:0] mips_i_inst_rdata,
    input [31:0] mips_m_data_rdata,
    output [31:0] mips_macroscopic_pc,
    output [31:0] mips_i_inst_addr,
    output [31:0] mips_m_data_addr,
    output [31:0] mips_m_data_wdata,
    output [3:0] mips_m_data_byteen,
    output [31:0] mips_m_int_addr,
    output [3:0] mips_m_int_byteen,
    output [31:0] mips_m_inst_addr,
    output mips_w_grf_we,
    output [4:0] mips_w_grf_addr,
    output [31:0] mips_w_grf_wdata,
    output [31:0] mips_w_inst_addr,
    
    // attach Timer0
    output [31:2] timer0_Addr,
    output timer0_WE,
    output [31:0] timer0_Din,
    input [31:0] timer0_Dout,
    input timer0_IRQ,
    
    // attach Timer1
    output [31:2] timer1_Addr,
    output timer1_WE,
    output [31:0] timer1_Din,
    input [31:0] timer1_Dout,
    input timer1_IRQ
    );
    
    wire isDM;
    wire isTimer0;
    wire isTimer1;
    wire isInterrupt;

assign isDM = (orimips_m_data_addr >= 32'h00000000 && orimips_m_data_addr < 32'h00003000) ? 1'b1 : 1'b0;
assign isTimer0 = (orimips_m_data_addr >= 32'h00007f00 && orimips_m_data_addr < 32'h00007f0c) ? 1'b1 : 1'b0;
assign isTimer1 = (orimips_m_data_addr >= 32'h00007f10 && orimips_m_data_addr < 32'h00007f1c) ? 1'b1 : 1'b0;
assign isInterrupt = (orimips_m_data_addr >= 32'h00007f20 && orimips_m_data_addr < 32'h00007f24) ? 1'b1 : 1'b0;
    
assign orimips_HWInt = {3'b0, mips_interrupt, timer1_IRQ, timer0_IRQ};
assign orimips_i_inst_rdata = mips_i_inst_rdata;
assign orimips_m_data_rdata = (isDM) ? mips_m_data_rdata :
                              (isTimer0) ? timer0_Dout :
                              (isTimer1) ? timer1_Dout :
                              (isInterrupt) ? 32'h00000000 :
                              32'h00000000;

assign mips_macroscopic_pc = orimips_macroscopic_pc;
assign mips_i_inst_addr = orimips_i_inst_addr;
assign mips_m_data_addr = orimips_m_data_addr;
assign mips_m_data_wdata = orimips_m_data_wdata;
assign mips_m_data_byteen = (isDM) ? orimips_m_data_byteen :
                            (isTimer0) ? 4'h0 :
                            (isTimer1) ? 4'h0 :
                            (isInterrupt) ? 4'h0 :
                            4'h0;
assign mips_m_int_addr = orimips_m_data_addr;
assign mips_m_int_byteen = (isDM) ? 4'h0 :
                           (isTimer0) ? 4'h0 :
                           (isTimer1) ? 4'h0 :
                           (isInterrupt) ? orimips_m_data_byteen :
                           4'h0;
assign mips_m_inst_addr = orimips_m_inst_addr;
assign mips_w_grf_we = orimips_w_grf_we;
assign mips_w_grf_addr = orimips_w_grf_addr;
assign mips_w_grf_wdata = orimips_w_grf_wdata;
assign mips_w_inst_addr = orimips_w_inst_addr;

assign timer0_Addr = orimips_m_data_addr[31:2];
assign timer0_WE = (isDM) ? 1'b0 :
                   (isTimer0) ? (&orimips_m_data_byteen) :
                   (isTimer1) ? 1'b0 :
                   (isInterrupt) ? 1'b0 :
                   1'b0;
assign timer0_Din = orimips_m_data_wdata;

assign timer1_Addr = orimips_m_data_addr[31:2];
assign timer1_WE = (isDM) ? 1'b0 :
                   (isTimer0) ? 1'b0 :
                   (isTimer1) ? (&orimips_m_data_byteen) :
                   (isInterrupt) ? 1'b0 :
                   1'b0;
assign timer1_Din = orimips_m_data_wdata;

endmodule
